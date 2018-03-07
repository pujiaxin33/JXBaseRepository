//
//  CDResumeOperation.m
//  CodoonSport
//
//  Created by Imp on 17/5/3.
//  Copyright © 2017年 Codoon. All rights reserved.
//

#import "CDResumeOperation.h"
#import <AFNetworking.h>

static inline NSString * CDKeyPathFromOperationState(CDResumeOperationState state) {
    switch (state) {
        case CDResumeOperationReadyState:
            return @"isReady";
        case CDResumeOperationExecutingState:
            return @"isExecuting";
        case CDResumeOperationFinishedState:
            return @"isFinished";
        case CDResumeOperationPausedState:
            return @"isPaused";
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            return @"state";
#pragma clang diagnostic pop
        }
    }
}

static inline BOOL CDStateTransitionIsValid(CDResumeOperationState fromState, CDResumeOperationState toState, BOOL isCancelled) {
    switch (fromState) {
        case CDResumeOperationReadyState:
            switch (toState) {
                case CDResumeOperationPausedState:
                case CDResumeOperationExecutingState:
                    return YES;
                case CDResumeOperationFinishedState:
                    return isCancelled;
                default:
                    return NO;
            }
        case CDResumeOperationExecutingState:
            switch (toState) {
                case CDResumeOperationPausedState:
                case CDResumeOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        case CDResumeOperationFinishedState:
            return NO;
        case CDResumeOperationPausedState:
            return toState == CDResumeOperationReadyState;
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            switch (toState) {
                case CDResumeOperationPausedState:
                case CDResumeOperationReadyState:
                case CDResumeOperationExecutingState:
                case CDResumeOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        }
#pragma clang diagnostic pop
    }
}

typedef void (^CDResumeOperationProgressBlock)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
typedef void (^CDResumeOperationCompletionBlock)(CDResumeOperation *operation, NSError *error, NSURL *fileURL, NSURLResponse *response);
typedef void (^CDResumaOpreationErrorBlock)(CDResumeOperation *opreation, NSError *error);

static NSString * const CDResumeOperationLockName = @"com.cdresume.operation.lock";


@interface CDResumeOperation ()

@property (readwrite, nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (strong, nonatomic) AFURLSessionManager *manager;

@property (readwrite, nonatomic, strong) NSError *error;

@property (readwrite, nonatomic, strong) NSURLRequest *request;

@property (readwrite, nonatomic, strong) NSURL *saveLocation;

@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;

@property (readwrite, nonatomic, assign) BOOL hasBreakOut; //是否是由杀掉App进来重新下载的

@property (readwrite, nonatomic, copy) CDResumeOperationProgressBlock downloadProgress;
@property (readwrite, nonatomic, copy) CDResumeOperationCompletionBlock completion;
@property (readwrite, nonatomic, copy) CDResumaOpreationErrorBlock errorBlock;

- (void)finish;

@end

@implementation CDResumeOperation

#pragma mark -
- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (nullable instancetype)initWithRequest:(NSURLRequest *)urlRequest targetLocation:(NSURL *)destination resumeData:(NSData *)operationResumeData{

    self = [self initWithRequest:urlRequest targetLocation:destination];

    if (self) {

        _operationResumeData = operationResumeData;

    }

    return self;
}


- (instancetype)initWithRequest:(NSURLRequest *)urlRequest targetLocation:(NSURL *)destination{

    NSParameterAssert(urlRequest);
    NSParameterAssert(destination);

    self = [super init];

    if (self) {

        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:urlRequest.URL.absoluteString];
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

        _manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];

        _state = CDResumeOperationReadyState;

        self.saveLocation = destination;
        self.request = urlRequest;
        _urlRequest = urlRequest;
        _destinationURL = destination;

        [self addObserver];
        [self registerCompletionBlock];
        [self registerDownloadTaskDidWriteDataBlock];

        self.lock = [[NSRecursiveLock alloc]init];
        self.lock.name = CDResumeOperationLockName;

    }

    return self;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChangeNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)networkChangeNotification:(NSNotification *)notification {
    NSNumber *num = notification.userInfo[AFNetworkingReachabilityNotificationStatusItem];
    if (num.integerValue == 0) {
        //no network
        [self pause];
    }
}

#pragma mark -
-(void)registerCompletionBlock{

    __weak typeof(self)weakSelf = self;
    self.downloadTask = [self.manager downloadTaskWithRequest:self.request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return weakSelf.saveLocation;

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

        if (error == nil) {

            [weakSelf finish];
            weakSelf.error = error;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.completion) {
                    weakSelf.completion(weakSelf, error, filePath, response);
                    [weakSelf.manager.session invalidateAndCancel];
                }
            });
        }else{

            _operationResumeData = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];

            if (error && [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData] && [error.userInfo.allKeys containsObject:NSURLErrorBackgroundTaskCancelledReasonKey]) {
                if (weakSelf.errorBlock) {
                    weakSelf.errorBlock(weakSelf,error);
                    [weakSelf.downloadTask cancel];
                    [weakSelf registerDownloadTaskDidWriteDataBlock];
                    [weakSelf registerResumeDataCompletionBlock];
                }
            }else if(!weakSelf.hasBreakOut){
                [weakSelf finish];
                weakSelf.error = error;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.completion) {
                        weakSelf.completion(weakSelf, error, filePath, response);
                        [weakSelf.manager.session invalidateAndCancel];
                    }
                });
            }
        }

    }];

    [self.manager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        if (error && [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            _operationResumeData = resumeData;
            if ([error.userInfo.allKeys containsObject:NSURLErrorBackgroundTaskCancelledReasonKey]) {
                weakSelf.hasBreakOut = YES;
                if (weakSelf.errorBlock) {
                    weakSelf.errorBlock(weakSelf,error);
                    [weakSelf.downloadTask cancel];
                    [weakSelf registerDownloadTaskDidWriteDataBlock];
                    [weakSelf registerResumeDataCompletionBlock];
                }
            }
        }
    }];
}

-(void)registerResumeDataCompletionBlock{

    __weak typeof(self)weakSelf = self;
    self.downloadTask = [self.manager downloadTaskWithResumeData:self.operationResumeData progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return weakSelf.saveLocation;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

        if (error == nil) {

            [weakSelf finish];
            weakSelf.error = error;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.completion) {
                    weakSelf.completion(weakSelf, error, filePath, response);
                    [weakSelf.manager.session invalidateAndCancel];
                }
            });
        }else{

            _operationResumeData = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];

            if (error && [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData] && [error.userInfo.allKeys containsObject:NSURLErrorBackgroundTaskCancelledReasonKey]) {
                if (weakSelf.errorBlock) {
                    weakSelf.errorBlock(weakSelf,error);
                    [weakSelf.downloadTask cancel];
                    [weakSelf registerDownloadTaskDidWriteDataBlock];
                    [weakSelf registerResumeDataCompletionBlock];
                }
            }else if(!weakSelf.hasBreakOut){
                [weakSelf finish];
                weakSelf.error = error;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.completion) {
                        weakSelf.completion(weakSelf, error, filePath, response);
                        [weakSelf.manager.session invalidateAndCancel];
                    }
                });
            }
        }
    }];
    if (self.downloadTask) {
        [self.downloadTask resume];
    }
}

-(void)registerDownloadTaskDidWriteDataBlock{

    __weak typeof(self) weakSelf = self;

    [self.manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {

        dispatch_async(dispatch_get_main_queue(), ^{

            if (weakSelf.downloadProgress) {
                weakSelf.downloadProgress (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);

            }
        });

    }];

}

#pragma mark -
- (void)setDownloadProgressBlock:(void (^)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))block {
    self.downloadProgress = block;
}
- (void)setDownloadCompletionBlock:(void (^)(CDResumeOperation *, NSError *, NSURL *, NSURLResponse *))block{
    self.completion = block;
}
- (void)setBreakOutErrorBlock:(void (^)(CDResumeOperation *, NSError *))errorBlock {
    self.errorBlock = errorBlock;
}

#pragma mark -
- (void)setState:(CDResumeOperationState)state {
    if (!CDStateTransitionIsValid(self.state, state, [self isCancelled])) {
        return;
    }

    [self.lock lock];
    NSString *oldStateKey = CDKeyPathFromOperationState(self.state);
    NSString *newStateKey = CDKeyPathFromOperationState(state);

    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
    [self.lock unlock];
}




#pragma mark - NSOperation & Operation Control
-(void)resume{

    if (![self isPaused]) {
        return;
    }

    if (self.downloadTask) {
        [self.lock lock];
        self.state = CDResumeOperationReadyState;
        [self.lock unlock];
        [self start];
    }


}
-(void)pause{
    if ([self isPaused] || [self isFinished] || [self isCancelled]) {
        return;
    }

    [self.lock lock];

    if ([self isExecuting]) {

        if(self.downloadTask){

            [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                _operationResumeData = resumeData;
            }];
        }
    }

    self.state = CDResumeOperationPausedState;
    [self.lock unlock];
}

-(void)cancel{

    [self.lock lock];
    if (![self isFinished] && ![self isCancelled]) {
        [super cancel];

        if ([self isExecuting]) {

            [self.downloadTask cancel];
            [self finish];
        }
    }
    [self.lock unlock];

}
- (void)start {

    [self.lock lock];
    if ([self isCancelled]) {
        [self finish];
        return;

    } else if ([self isReady]) {
        self.state = CDResumeOperationExecutingState;

        if (self.operationResumeData) {

            [self registerResumeDataCompletionBlock];

        }else{

            [self.downloadTask resume];

        }
    }

    [self.lock unlock];
}

- (void)finish {

    [self.lock lock];
    self.state = CDResumeOperationFinishedState;
    [self.lock unlock];
}
- (BOOL)isPaused {
    return self.state == CDResumeOperationPausedState;
}
- (BOOL)isReady {
    return self.state == CDResumeOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.state == CDResumeOperationExecutingState;
}

- (BOOL)isFinished {
    return self.state == CDResumeOperationFinishedState
    ;
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
