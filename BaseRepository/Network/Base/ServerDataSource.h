//
//  ServerDataSource.h
//  CodoonSport
//
//  Created by Leo on 14-5-5.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CDHttpSerializerType)
{
    CDHttpSerializerTypeNone = 0,
    CDHttpSerializerTypeJson,
    CDHttpSerializerTypeForm,
    CDHttpSerializerTypePropertyList,
};

@class AFHTTPSessionManager;
@protocol AFMultipartFormData;

@interface ServerDataSource : NSObject

@property (nonatomic, readonly, getter = manager) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString *baseUrl;

/**
 *  根据服务器地址进行初始化
 *
 *  @param url 服务器地址
 *
 *  @return 当前实例
 */
- (instancetype)initWithBaseUrl:(NSString *)url;

//处理POST请求 第三方(不是请求咕咚的服务器) 单独处理的
- (void)postOther:(NSString *)url
           params:(NSDictionary *)params
     onCompletion:(CommonBlockCompletion)completionCallback
          onError:(CommonBlockError)errorCallback;

- (void)postOther:(NSString *)url
           params:(NSDictionary *)params
     appendHeader:(NSDictionary *)appendHeader
     onCompletion:(CommonBlockCompletion)completionCallback
          onError:(CommonBlockError)errorCallback;

- (void)postOther:(NSString *)url
           params:(NSDictionary *)params
             type:(CDHttpSerializerType)type
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
          onError:(CommonBlockError)errorCallback;

//处理GET请求 第三方(不是请求咕咚的服务器) 单独处理的
- (void)getOther:(NSString *)url
          params:(NSDictionary *)params
    onCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
         onError:(CommonBlockError)errorCallback;

- (void)getOther:(NSString *)url
          params:(NSDictionary *)params
    appendHeader:(NSDictionary *)appendHeader
    onCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
         onError:(CommonBlockError)errorCallback;

/**
 *  处理Http POST 请求服务
 *
 *  @param url                请求地址
 *  @param params             参数字典
 *  @param completionCallback 请求成功回调
 *  @param errorCallback      请求失败回调
 */
- (NSURLSessionTask *)post:(NSString *)url
      params:(NSDictionary *)params
       cache:(BOOL)cache
onCompletion:(CommonBlockCompletion)completionCallback
     onError:(CommonBlockError)errorCallback;

/**
 *  处理Http POST 请求服务
 *
 *  @param url                请求地址
 *  @param params             参数字典
 *  @param appendHeader       附加header
 *  @param completionCallback 请求成功回调
 *  @param errorCallback      请求失败回调
 */
- (NSURLSessionTask *)post:(NSString *)url
                    params:(NSDictionary *)params
              appendHeader:(NSDictionary *)appendHeader
                     cache:(BOOL)cache
              onCompletion:(CommonBlockCompletion)completionCallback
                   onError:(CommonBlockError)errorCallback;

/**
 *  处理Http POST 请求服务
 *
 *  @param url                              请求地址
 *  @param params                           参数字典
 *  @param completionWithCacheFlagCallback  请求成功回调(包含是否缓存的Flag)
 *  @param errorCallback                    请求失败回调
 */
- (void)post:(NSString *)url
      params:(NSDictionary *)params
       cache:(BOOL)cache
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionWithCacheFlagCallback
     onError:(CommonBlockError)errorCallback;

/**
 *  处理POST请求
 *
 *  @param url                请求地址
 *  @param params             参数字典
 *  @param cache              是否缓存
 *  @param type               传输序列化类型
 *  @param completionCallback 请求成功回调
 *  @param errorCallback      请求失败回调
 */
- (NSURLSessionTask *)post:(NSString *)url
      params:(NSDictionary *)params
        type:(CDHttpSerializerType)type
       cache:(BOOL)cache
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
     onError:(CommonBlockError)errorCallback;


/**
 *  处理POST请求
 *
 *  @param url                请求地址
 *  @param params             参数字典
 *  @param cache              是否缓存
 *  @param type               传输序列化类型
 *  @param token              TOKEN
 *  @param completionCallback 请求成功回调
 *  @param errorCallback      请求失败回调
 */
- (NSURLSessionTask *)post:(NSString *)url
      params:(NSDictionary *)params
       cache:(BOOL)cache
        type:(CDHttpSerializerType)type
       token:(NSString *)token
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
     onError:(CommonBlockError)errorCallback;

/**
 *  处理POST请求
 *
 *  @param url                请求地址
 *  @param params             参数字典
 *  @param cache              是否缓存
 *  @param type               传输序列化类型
 *  @param token              TOKEN
 *  @param tokenType          TOKEN类型
 *  @param completionCallback 请求成功回调
 *  @param errorCallback      请求失败回调
 */
- (NSURLSessionTask *)post:(NSString *)url
      params:(NSDictionary *)params
       cache:(BOOL)cache
        type:(CDHttpSerializerType)type
       token:(NSString *)token
   tokenType:(NSString *)tokenType
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
     onError:(CommonBlockError)errorCallback;

/**
 *  处理GET请求
 *
 *  @param url                请求地址
 *  @param params             参数字典
 *  @param cache              是否缓存
 *  @param completionCallback 请求成功回调
 *  @param errorCallback      请求失败回调
 */
- (void)get:(NSString *)url
     params:(NSDictionary *)params
      cache:(BOOL)cache
    onCompletion:(CommonBlockCompletionWithCacheFlagWithError)completionCallback
    onError:(CommonBlockError)errorCallback;

/**
 *  处理GET请求
 *
 *  @param url                请求地址
 *  @param params             参数字典
 *  @param appendHeader       附加header
 *  @param cache              是否缓存
 *  @param completionCallback 请求成功回调
 *  @param errorCallback      请求失败回调
 */
- (void)get:(NSString *)url
     params:(NSDictionary *)params
appendHeader:(NSDictionary *)appendHeader
      cache:(BOOL)cache
onCompletion:(CommonBlockCompletion)completionCallback
    onError:(CommonBlockError)errorCallback;

/**
 *  处理GET请求
 *
 *  @param url                请求地址
 *  @param params             参数字典
 *  @param cache              是否缓存
 *  @param type               传输序列化类型
 *  @param token              TOKEN
 *  @param tokenType          TOKEN类型
 *  @param completionCallback 请求成功回调
 *  @param errorCallback      请求失败回调
 */
- (void)get:(NSString *)url
     params:(NSDictionary *)params
      cache:(BOOL)cache
       type:(CDHttpSerializerType)type
      token:(NSString *)token
  tokenType:(NSString *)tokenType
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
    onError:(CommonBlockError)errorCallback;

//处理第三方GET请求
- (void)getOther:(NSString *)url
          params:(NSDictionary *)params
onCacheFlagCompletion:(CommonBlockCompletionWithCacheFlag)completionCallback
         onError:(CommonBlockError)errorCallback;

/**
 *  获取当前请求的操作
 *
 *  @param url 请求的Url
 *
 *  @return 对应的操作
 */
- (NSURLSessionTask *)getRequestTask:(NSString *)url;

@end
