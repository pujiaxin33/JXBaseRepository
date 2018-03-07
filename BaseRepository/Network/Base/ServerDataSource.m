//
//  ServerDataSource.m
//  CodoonSport
//
//  Created by Leo on 14-5-5.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import "ServerDataSource.h"
#import "CDJsonKit.h"
#import <AFNetworking/AFNetworking.h>
#import "NSData+MD5Digest.h"
#import "NSData+CommonCrypto.h"
#import "NSString+URLEncode.h"

#define  kCodoonErrorDomainString   @"com.codoon.error"
static float const kRequestTimeoutInterval = 30.f;
static NSString * const kCustomTokenErrorDomain = @"codoon.request&3007";
@interface ServerDataSource ()
@property (nonatomic, strong) NSMutableDictionary *requestOperationPool;
@end

@implementation ServerDataSource
@synthesize manager;
@synthesize baseUrl;

- (instancetype)initWithBaseUrl:(NSString *)url
{
    self = [super init];
    if (self)
    {
        //基本URL
        self.baseUrl = url;
        [self initManagersForUrl:url];

    }
    return self;
}

- (void)initManagersForUrl:(NSString *)url {
    //连接池
    self.requestOperationPool = [[NSMutableDictionary alloc] initWithCapacity:10];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = kRequestTimeoutInterval;
    //        configuration.protocolClasses = @[[CDCountURLProtocol class]];

    //初始化网络操作管理
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:url] sessionConfiguration:configuration];
}

//处理POST请求
- (NSURLSessionTask *)post:(NSString *)url
      params:(NSDictionary *)params
       cache:(BOOL)cache
onCompletion:(CommonBlockCompletion)completionCallback
     onError:(CommonBlockError)errorCallback
{
    return [self post:url
        params:params
          type:CDHttpSerializerTypeNone
         cache:cache
onCacheFlagCompletion:^(id obj, BOOL cache) {
    if (completionCallback != nil)
    {
        completionCallback(obj);
    }
}
       onError:errorCallback];
}

- (NSURLSessionTask *)post:(NSString *)url
                    params:(NSDictionary *)params
              appendHeader:(NSDictionary *)appendHeader
                     cache:(BOOL)cache
              onCompletion:(CommonBlockCompletion)completionCallback
                   onError:(CommonBlockError)errorCallback{
    NSString *token = @"";
    return [self post:url
               params:params
         appendHeader:appendHeader
                cache:cache
                 type:CDHttpSerializerTypeNone
                token:token
            tokenType:@"Bearer"
onCacheFlagCompletion:^(id obj, BOOL cache) {
            if (completionCallback != nil){
                completionCallback(obj);
            }
            } onError:errorCallback];
}

//处理POST请求
- (void)post:(NSString *)url
      params:(NSDictionary *)params
       cache:(BOOL)cache
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
     onError:(CommonBlockError)errorCallback
{
    [self post:url
        params:params
          type:CDHttpSerializerTypeNone
         cache:cache
onCacheFlagCompletion:completionCallback
       onError:errorCallback];
}

//处理POST请求
- (NSURLSessionTask *)post:(NSString *)url
      params:(NSDictionary *)params
        type:(CDHttpSerializerType)type
       cache:(BOOL)cache
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
     onError:(CommonBlockError)errorCallback
{
    NSParameterAssert(params);
    
    NSString *token = @"";
    
    return [self post:url
        params:params
         cache:cache
          type:type
         token:token
onCacheFlagCompletion:completionCallback onError:errorCallback];
}


//处理POST请求
- (NSURLSessionTask *)post:(NSString *)url
      params:(NSDictionary *)params
       cache:(BOOL)cache
        type:(CDHttpSerializerType)type
       token:(NSString *)token
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
     onError:(CommonBlockError)errorCallback
{
    return [self post:url
        params:params
         cache:cache
          type:type
         token:token
     tokenType:@"Bearer"
onCacheFlagCompletion:completionCallback
       onError:errorCallback];
    
}

//处理POST请求
- (NSURLSessionTask *)post:(NSString *)url
      params:(NSDictionary *)params
       cache:(BOOL)cache
        type:(CDHttpSerializerType)type
       token:(NSString *)token
   tokenType:(NSString *)tokenType
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
     onError:(CommonBlockError)errorCallback
{
    NSParameterAssert(params);
    
    return [self post:url
               params:params
         appendHeader:nil
                cache:cache
                 type:type
                token:token
            tokenType:tokenType
onCacheFlagCompletion:completionCallback
              onError:errorCallback];
}

//处理POST请求
- (NSURLSessionTask *)post:(NSString *)url
                    params:(NSDictionary *)params
              appendHeader:(NSDictionary *)appendHeader
                     cache:(BOOL)cache
                      type:(CDHttpSerializerType)type
                     token:(NSString *)token
                 tokenType:(NSString *)tokenType
     onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
                   onError:(CommonBlockError)errorCallback{
    //配置请求和响应序列化
    [self configRequestAndResponseSerializer:url type:type];

    //特殊转化率使用
    NSString *utm = [[params validDictionary] validStringForKey:@"utm"];
    //设置验证token和token类型
    [self configureHeaderFieldsWithToken:token tokenType:tokenType forURLString:url utm:utm];
    [self configureSignatureWithURLString:url HTTPMethod:@"POST" parameters:params];
    
    [appendHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];

    
    //创建操作
    NSURLSessionDataTask *requestTask = [self.manager POST:url
                                                parameters:params
                                                  progress:nil
                                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                       [self.manager invalidateSessionCancelingTasks:NO];
                                                       [self handleCallback:responseObject
                                                                                       url:url
                                                                              onCompletion:completionCallback
                                                                                    onFail:errorCallback];
                                                       [self.requestOperationPool removeObjectForKey:url];

                                                   }
                                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                                                       
                                                       [self handleFailTask:task error:error params:params tokenType:tokenType completion:^(id obj, BOOL cache) {
                                                           [self.manager invalidateSessionCancelingTasks:NO];
                                                           !completionCallback ?: completionCallback(obj, cache);
                                                       } errorCallback:^(NSError *error) {
                                                           [self.manager invalidateSessionCancelingTasks:YES];
                                                           !errorCallback ?: errorCallback(error);
                                                       }];
                                                   }];
    //将操作加入连接池
    [self.requestOperationPool setSafeObject:requestTask forKey:url];
    
    return requestTask;
}


//处理POST请求 第三方 单独处理的
- (void)postOther:(NSString *)url
           params:(NSDictionary *)params
     onCompletion:(CommonBlockCompletion)completionCallback
          onError:(CommonBlockError)errorCallback
{
    [self postOther:url
        params:params
          type:CDHttpSerializerTypeNone
onCacheFlagCompletion:^(id obj, BOOL cache) {
    if (completionCallback != nil)
    {
        completionCallback(obj);
    }
}
       onError:errorCallback];
}

- (void)postOther:(NSString *)url
           params:(NSDictionary *)params
     appendHeader:(NSDictionary *)appendHeader
     onCompletion:(CommonBlockCompletion)completionCallback
          onError:(CommonBlockError)errorCallback{
    [self postOther:url
             params:params
       appendHeader:appendHeader
               type:CDHttpSerializerTypeNone
onCacheFlagCompletion:^(id obj, BOOL cache) {
        if (completionCallback != nil)
        {
            completionCallback(obj);
        }
        } onError:errorCallback];
}


//处理POST请求
- (void)postOther:(NSString *)url
           params:(NSDictionary *)params
             type:(CDHttpSerializerType)type
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
     onError:(CommonBlockError)errorCallback
{
    NSParameterAssert(params);
    
    return [self postOther:url
                    params:params
              appendHeader:nil
                      type:type
     onCacheFlagCompletion:completionCallback
                   onError:errorCallback];
}

//处理POST请求
- (void)postOther:(NSString *)url
           params:(NSDictionary *)params
     appendHeader:(NSDictionary *)appendHeader
             type:(CDHttpSerializerType)type
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
          onError:(CommonBlockError)errorCallback
{
    NSParameterAssert(params);
    
    //配置请求和响应序列化
    [self configRequestAndResponseSerializer:url type:type];
    
    [appendHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    NSURLSessionTask *requestTask = [self.manager POST:url
                                            parameters:params
                                              progress:nil
                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                   [self.manager invalidateSessionCancelingTasks:NO];
                                                   if (responseObject && completionCallback) {
                                                       completionCallback(responseObject, NO);
                                                   }else {
                                                       NSMutableDictionary *userInfo = [@{} mutableCopy];
                                                       [userInfo setSafeObject:@"第三方请求错误" forKey:NSLocalizedDescriptionKey];
                                                       NSError *error = [NSError errorWithDomain:@"other" code:10000 userInfo:userInfo];
                                                       !errorCallback ?: errorCallback(error);
                                                   }
                                                   [self.requestOperationPool removeObjectForKey:url];
                                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   [self.manager invalidateSessionCancelingTasks:YES];
                                                   [self handleFailBlock:errorCallback
                                                                   error:error];
                                                   
                                                   //从连接池删除
                                                   [self.requestOperationPool removeObjectForKey:url];
                                               }];
    //将操作加入连接池
    [self.requestOperationPool setObject:requestTask forKey:url];
}

- (void)getOther:(NSString *)url
          params:(NSDictionary *)params
    onCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
         onError:(CommonBlockError)errorCallback{
    [self getOther:url
            params:params
      appendHeader:nil
      onCompletion:completionCallback
           onError:errorCallback];
}

- (void)getOther:(NSString *)url
          params:(NSDictionary *)params
    appendHeader:(NSDictionary *)appendHeader
    onCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
         onError:(CommonBlockError)errorCallback{
    NSParameterAssert(params);
    
    //配置请求和响应序列化
    [self configRequestAndResponseSerializer:url type:CDHttpSerializerTypeNone];
    
    [appendHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    NSURLSessionTask *requestTask =
    [self.manager GET:url
           parameters:params
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  [self.manager invalidateSessionCancelingTasks:NO];
                  if (responseObject && completionCallback) {
                      completionCallback(responseObject, NO);
                  }else {
                      NSMutableDictionary *userInfo = [@{} mutableCopy];
                      [userInfo setSafeObject:@"第三方请求错误" forKey:NSLocalizedDescriptionKey];
                      NSError *error = [NSError errorWithDomain:@"other" code:10000 userInfo:userInfo];
                      !errorCallback ?: errorCallback(error);
                  }
                  [self.requestOperationPool removeObjectForKey:url];
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  [self.manager invalidateSessionCancelingTasks:YES];
                  [self handleFailBlock:errorCallback
                                  error:error];
                  //从连接池删除
                  [self.requestOperationPool removeObjectForKey:url];
              }];
    
    //将操作加入连接池
    [self.requestOperationPool setObject:requestTask forKey:url];
}

- (NSURLSessionTask *)getRequestTask:(NSString *)url
{
    return [self.requestOperationPool objectForKey:url];
}

#pragma mark - Config
- (void)configRequestAndResponseSerializer:(NSString *)url type:(CDHttpSerializerType)type
{
    //先恢复成默认的、注意：这里是需要这样做的，这句不能删掉，否则将收不到回调
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置为新的
    switch (type)
    {
        case CDHttpSerializerTypeForm:
        {
            AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.requestSerializer = requestSerializer;
            [manager.requestSerializer setTimeoutInterval:kRequestTimeoutInterval];
        }
            break;
        case CDHttpSerializerTypeJson:
        {
            AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
            [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            manager.requestSerializer = requestSerializer;
            [manager.requestSerializer setTimeoutInterval:kRequestTimeoutInterval];
        }
            break;
        case CDHttpSerializerTypeNone:
        {
            if ([self.baseUrl rangeOfString:@"/api/"].length > 0 || [url rangeOfString:@"/api/"].length > 0 || [url rangeOfString:@"/v2/"].length > 0)
            {
                //请求
                AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
                [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                manager.requestSerializer = requestSerializer;
                [manager.requestSerializer setTimeoutInterval:kRequestTimeoutInterval];
            }
            else if ([url hasPrefix:@"http://notify.codoon.com"])
            {
                //设置超时时间
                [manager.requestSerializer setTimeoutInterval:120];
            }
        }
            break;
        case CDHttpSerializerTypePropertyList:
        {
            AFPropertyListRequestSerializer *requestSerializer = [AFPropertyListRequestSerializer serializer];
            manager.requestSerializer = requestSerializer;
            [manager.requestSerializer setTimeoutInterval:kRequestTimeoutInterval];
        }
            break;
    }
}

- (void)configureSignatureWithURLString:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.HTTPMethod = HTTPMethod;
    
    NSURLRequest *tempRequest = [self.manager.requestSerializer requestBySerializingRequest:request withParameters:parameters error:nil];
    
    NSString *bodyString = nil;
    if(![self.manager.requestSerializer.HTTPMethodsEncodingParametersInURI containsObject:HTTPMethod]) {
        bodyString = [[NSString alloc] initWithData:tempRequest.HTTPBody encoding:self.manager.requestSerializer.stringEncoding];
    }
    
    [self configureSignatureWithTagert:self.manager.requestSerializer URL:request.URL bodyString:bodyString queryString:tempRequest.URL.query];
}

//重新发请求的时候签名要更新，因为时间戳变化了
- (void)configureSignatureWithResendableRequest:(NSMutableURLRequest *)request {
    NSString *bodyString = nil;
    if(![self.manager.requestSerializer.HTTPMethodsEncodingParametersInURI containsObject:request.HTTPMethod]) {
        bodyString = [[NSString alloc] initWithData:request.HTTPBody encoding:self.manager.requestSerializer.stringEncoding];
    }
    
    [self configureSignatureWithTagert:request URL:request.URL bodyString:bodyString queryString:request.URL.query];
}

- (void)configureSignatureWithTagert:(id)target URL:(NSURL *)URL bodyString:(NSString *)bodyString queryString:(NSString *)queryString {

}

- (void)configureHeaderFieldsWithToken:(NSString *)token tokenType:(NSString *)tokenType forURLString:(NSString *)URLString utm:(NSString *)utm {
}

#pragma mark - handle
- (NSString *)requestTokenForTask:(NSURLSessionTask *)task
{
    NSDictionary *header = task.originalRequest.allHTTPHeaderFields;
    NSString *authorization = [header validStringForKey:@"Authorization"];
    NSArray *comps = [authorization componentsSeparatedByString:@" "];
    NSString *requestToken = [comps safeObjectAtIndex:1];
    return requestToken;
}

- (void)handleFailTask:(NSURLSessionTask *)task error:(NSError *)error params:(NSDictionary *)params tokenType:(NSString *)tokenType completion:(CommonBlockCompletionWithCacheFlag)completionCallback errorCallback:(CommonBlockError)errorCallback

{
//    NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
//    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
//    NSDictionary *jsonError = [errResponse cd_objectFromJSONString];
//    NSInteger errorCode = [[[jsonError validDictionary] validNumberForKey:@"error_code"] integerValue];
}

- (void)requestNewTask:(NSURLSessionTask *)task newToken:(NSString *)newToken error:(NSError *)error params:(NSDictionary *)params tokenType:(NSString *)tokenType completion:(CommonBlockCompletionWithCacheFlag)completionCallback errorCallback:(CommonBlockError)errorCallback {
    NSMutableURLRequest *request = [task.originalRequest mutableCopy];
    
    NSString *authorization = [NSString stringWithFormat:@"%@ %@", tokenType, newToken];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    
//    NSString *timestamp = [CDRefreshTokenManager serverTimestampForCurrent];
//    [request setValue:timestamp forHTTPHeaderField:@"Timestamp"];

    [self configureSignatureWithResendableRequest:request];

    NSURLSessionTask *newTask = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self handleFailTask:task error:error params:params tokenType:tokenType completion:completionCallback errorCallback:errorCallback];
        }else {
            NSString *url = [[request URL] absoluteString];
            [self handleCallback:responseObject url:url onCompletion:completionCallback onFail:errorCallback];
            if (task.originalRequest.URL.absoluteString) {
                [self.requestOperationPool removeObjectForKey:task.originalRequest.URL.absoluteString];
            }
        }
    }];
    [newTask resume];
}

- (void)handleFailBlock:(CommonBlockError)failBlock
                  error:(NSError *)error
{
    //非业务的错误
    if (failBlock)
    {
        //网络连接错误
        if(error.code == -1003 || error.code == -1009)
        {
            NSError *resultError = [NSError errorWithDomain:error.domain
                                                       code:error.code
                                                   userInfo:@{NSLocalizedDescriptionKey:@"当前网络不可用，请检查您的网络设置"}];
            failBlock(resultError);
            return;
        }
        
        failBlock(error);
        return;
    }
}

//处理请求完成
-(BOOL)handleCallback:(NSDictionary *)response
                  url:(NSString *)url
         onCompletion:(CommonBlockCompletionWithCacheFlag)completionBlock
               onFail:(CommonBlockError)failBlock
{
    BOOL result = NO;
    if (completionBlock)
    {
        //先判断返回状态
        NSString *status = response[@"status"];
        id data = response[@"data"];
        NSArray *ads = response[@"ads"];
        if (status)
        {
            if ([status isKindOfClass:[NSString class]])
            {
                if ([[status uppercaseString] isEqualToString:@"OK"]) //业务请求正确
                {
                    completionBlock(response, NO);
                    result = YES;
                }
                else if ([[status uppercaseString] isEqualToString:@"FALSE"])  //Add by lichen, For BBS
                {
                    completionBlock(response, NO);
                    result = YES;
                }
                else if([[status lowercaseString] isEqualToString:@"error"]) //业务上的错误
                {
                    //兼容运动数据接口
                    NSInteger code = -9999;
                    if (![response[@"data"] isKindOfClass:[NSNull class]]){
                        if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                            code = -9999;
                        }else if ([response[@"data"] isKindOfClass:[NSNumber class]] || [response[@"data"] isKindOfClass:[NSString class]]) {
                            code = [response[@"data"] intValue];
                        }
                    }
                    
                    NSString *message = response[@"description"];
                    NSString *domain = kCodoonErrorDomainString;
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{NSLocalizedDescriptionKey:message}];
                    [userInfo setSafeObject:data forKey:@"codoon_data"];

                    NSError *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
                    [self handleFailBlock:failBlock error:error];
                }
                else
                {
                    NSString *message = @"服务器返回结果异常";
                    NSInteger code = -99999;
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:message};
                    NSError *error = [NSError errorWithDomain:kCodoonErrorDomainString code:code userInfo:userInfo];
                    [self handleFailBlock:failBlock error:error];
                }
            }
            else if ([status isKindOfClass:[NSNumber class]])
            {
                completionBlock(response, NO);
                result = YES;
            }
            else
            {
                NSString *message = @"服务器返回结果异常";
                NSInteger code = -99999;
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:message};
                NSError *error = [NSError errorWithDomain:kCodoonErrorDomainString code:code userInfo:userInfo];
                [self handleFailBlock:failBlock error:error];
            }
        }
        else if(data)
        {
            completionBlock(response, NO);
            result = YES;
        }
        //FIXME: 由于广告返回的数据跟其他数据结构不一致，所以进行单独处理
        else if (ads)
        {
            completionBlock(response, NO);
            result = YES;
        }
        else if (response)
        {
            completionBlock(response, NO);
            result = YES;
        }
        else
        {
            completionBlock(response, NO);
            result = YES;
        }
    }
    
    return result;
}

- (void)get:(NSString *)url
     params:(NSDictionary *)params
      cache:(BOOL)cache
onCompletion:(CommonBlockCompletionWithCacheFlagWithError)completionCallback
    onError:(CommonBlockError)errorCallback{
    NSParameterAssert(params);
    
    NSString *token = @"";
    
    [self get:url
       params:params
        cache:cache
         type:CDHttpSerializerTypeNone
        token:token
    tokenType:@"Bearer"
onCacheFlagCompletion:^(id obj, BOOL cache) {
    !completionCallback ?: completionCallback (obj, cache, nil);
    }
    onError:errorCallback];
}

- (void)get:(NSString *)url
     params:(NSDictionary *)params
appendHeader:(NSDictionary *)appendHeader
      cache:(BOOL)cache
onCompletion:(CommonBlockCompletion)completionCallback
    onError:(CommonBlockError)errorCallback{
    NSString *token = @"";
    
    [self get:url
       params:params
 appendHeader:appendHeader
        cache:cache
         type:CDHttpSerializerTypeNone
        token:token
    tokenType:@"Bearer"
onCacheFlagCompletion:^(id obj, BOOL cache) {
        if (completionCallback != nil){
            completionCallback(obj);
        }
    } onError:errorCallback];
}

//处理GET请求
- (void)get:(NSString *)url
     params:(NSDictionary *)params
      cache:(BOOL)cache
       type:(CDHttpSerializerType)type
      token:(NSString *)token
  tokenType:(NSString *)tokenType
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
    onError:(CommonBlockError)errorCallback
{
    [self get:url
       params:params
 appendHeader:nil
        cache:cache
         type:type
        token:token
    tokenType:tokenType
onCacheFlagCompletion:completionCallback
      onError:errorCallback];
}

- (void)get:(NSString *)url
     params:(NSDictionary *)params
appendHeader:(NSDictionary *)appendHeader
      cache:(BOOL)cache
       type:(CDHttpSerializerType)type
      token:(NSString *)token
  tokenType:(NSString *)tokenType
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
    onError:(CommonBlockError)errorCallback
{
    NSParameterAssert(params);
    
    //配置请求和响应序列化
    [self configRequestAndResponseSerializer:url type:type];

    //特殊转化率使用
    NSString *utm = [[params validDictionary] validStringForKey:@"utm"];
    //设置验证token和token类型
    [self configureHeaderFieldsWithToken:token tokenType:tokenType forURLString:url utm:utm];
    [self configureSignatureWithURLString:url HTTPMethod:@"GET" parameters:params];

    [appendHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    NSURLSessionTask *requestTask = [self.manager GET:url
                                           parameters:params
                                             progress:nil
                                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                  [self.manager invalidateSessionCancelingTasks:NO];
                                                  [self handleCallback:responseObject url:url onCompletion:completionCallback onFail:errorCallback];
                                                  [self.requestOperationPool removeObjectForKey:url];
                                              }
                                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                  [self handleFailTask:task error:error params:params tokenType:tokenType completion:^(id obj, BOOL cache) {
                                                      !completionCallback ?: completionCallback(obj, cache);
                                                      [self.manager invalidateSessionCancelingTasks:NO];
                                                  } errorCallback:^(NSError *error) {
                                                      !errorCallback ?: errorCallback(error);
                                                      [self.manager invalidateSessionCancelingTasks:YES];
                                                  }];
                                                  //从连接池删除
                                                  [self.requestOperationPool removeObjectForKey:url];
                                              }];
    
    //将操作加入连接池
    [self.requestOperationPool setObject:requestTask forKey:url];
}

//处理第三方GET请求
- (void)getOther:(NSString *)url
          params:(NSDictionary *)params
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
    onError:(CommonBlockError)errorCallback{
    
    NSURLSessionTask *requestTask =
    [self.manager GET:url
           parameters:params
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  [self.manager invalidateSessionCancelingTasks:NO];
                  if (responseObject && completionCallback) {
                      completionCallback(responseObject, NO);
                  }else {
                      NSMutableDictionary *userInfo = [@{} mutableCopy];
                      [userInfo setSafeObject:@"第三方请求错误" forKey:NSLocalizedDescriptionKey];
                      NSError *error = [NSError errorWithDomain:@"other" code:10000 userInfo:userInfo];
                      !errorCallback ?: errorCallback(error);
                  }
                  [self.requestOperationPool removeObjectForKey:url];
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  [self.manager invalidateSessionCancelingTasks:YES];
                  [self handleFailBlock:errorCallback
                                  error:error];
                  
                  //从连接池删除
                  [self.requestOperationPool removeObjectForKey:url];
              }];
    
    //将操作加入连接池
    [self.requestOperationPool setObject:requestTask forKey:url];
}

@end
