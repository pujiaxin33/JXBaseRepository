//
//  ServerDownloadDataSource.m
//  CodoonSport
//
//  Created by CHEN on 14-8-1.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import "ServerDownloadDataSource.h"
#import "SJURLSessionOperation.h"
#import "CDResumeOperation.h"

@interface ServerDownloadDataSource ()

@property (nonatomic, strong) NSMutableDictionary *requestOperationPool;

@end

static ServerDownloadDataSource *staticDownloadDataSource = nil;

@implementation ServerDownloadDataSource

+ (ServerDownloadDataSource *)sharedServerDownloadDataSource
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!staticDownloadDataSource)
        {
            staticDownloadDataSource = [[ServerDownloadDataSource alloc] init];
        }
    });
    
    return staticDownloadDataSource;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        //init
        
        //连接池
        self.requestOperationPool = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return self;
}

- (void)downloadRequest:(NSString *)url
             targetPath:(NSString *)path
                 resume:(BOOL)isResume
             onProgress:(CommonBlockProgress)progressCallBack
           onCompletion:(CommonBlockCompletion)completionCallback
                onError:(CommonBlockError)errorCallback;
{
    NSURLRequest *downloadUrlRequst = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }

    //生成下载操作对象
    SJURLSessionOperation *operation = [[SJURLSessionOperation alloc] initWithRequest:downloadUrlRequst targetLocation:[[NSURL alloc] initFileURLWithPath:path]];
    
    //设置下载操作回调
    [operation setDownloadProgressBlock:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if (progressCallBack) {
            CGFloat progress = totalBytesWritten / (float)totalBytesExpectedToWrite;
            progressCallBack(progress);
        }
    }];
    
    //设置完成操作回调
    [operation setDownloadCompletionBlock:^(SJURLSessionOperation * _Nullable operation, NSError * _Nullable error, NSURL * _Nullable fileURL, NSURLResponse * _Nullable response) {
        if (error) {
            if (errorCallback) {
                errorCallback(error);
                [self.requestOperationPool removeObjectForKey:url];
            }
        }else {
            if (completionCallback) {
                completionCallback([fileURL path]);
            }
            [self.requestOperationPool removeObjectForKey:url];
        }
        
    }];
    
    
    //将操作加入连接池
    [self.requestOperationPool setObject:operation forKey:url];
    
    //
    [operation start];
}


- (void)downloadRequest:(NSString *)url
             targetPath:(NSString *)path
             resumeData:(NSData *)resumeData
             onProgress:(DownloadProgressBlock)progressCallBack
           onCompletion:(CommonBlockCompletion)completionCallback
                onError:(DownloadResumeErrorBlock)errorCallback
               breakOut:(DownloadBreakOutBlock)breakOutCallback;{
    NSURLRequest *downloadUrlRequst = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self removeCachedRequest:url];
    //生成下载操作对象
    CDResumeOperation *operation = [[CDResumeOperation alloc] initWithRequest:downloadUrlRequst targetLocation:[[NSURL alloc] initFileURLWithPath:path] resumeData:resumeData];
    //设置下载操作回调
    [operation setDownloadProgressBlock:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if (progressCallBack) {
            CGFloat progress = totalBytesWritten / (float)totalBytesExpectedToWrite;
            progressCallBack(totalBytesWritten,progress);
        }
    }];
    //设置完成操作回调
    [operation setDownloadCompletionBlock:^(CDResumeOperation * _Nullable operation, NSError * _Nullable error, NSURL * _Nullable fileURL, NSURLResponse * _Nullable response) {
        if (error) {
            if (errorCallback) {
                errorCallback(error,operation.operationResumeData,fileURL);
                [self.requestOperationPool removeObjectForKey:url];
            }
        }else {
            if (completionCallback) {
                completionCallback([fileURL path]);
            }
            [self.requestOperationPool removeObjectForKey:url];
        }

    }];
    [operation setBreakOutErrorBlock:^(CDResumeOperation *operation, NSError *error) {
        if (breakOutCallback) {
            breakOutCallback(operation.operationResumeData,error);
            [self.requestOperationPool removeObjectForKey:url];
        }
    }];
    //将操作加入连接池
    [self.requestOperationPool setObject:operation forKey:url];

    [operation start];
}

- (BOOL)isValidResumeData:(NSData *)data{
    if (!data || [data length] < 1) return NO;

    NSError *error;
    NSDictionary *resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    if (!resumeDictionary || error) return NO;

    NSString *localFilePath = [resumeDictionary objectForKey:@"NSURLSessionResumeInfoLocalPath"];
    if ([localFilePath length] < 1) return NO;

    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
}

- (void)removeCachedRequest:(NSString *)url
{
    
    //移除指定url缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)cancelDownloadRequest:(NSString *)url
{
    SJURLSessionOperation *downloadOP = [self.requestOperationPool objectForKey:url];
    if (downloadOP)
    {
        [downloadOP cancel];
        [self.requestOperationPool removeObjectForKey:url];
    }
}

@end
