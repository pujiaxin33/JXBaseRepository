//
//  ServerDownloadDataSource.h
//  CodoonSport
//
//  Created by CHEN on 14-8-1.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownloadResumeErrorBlock)(NSError *error,NSData *resumeData,NSURL *filePath);
typedef void(^DownloadProgressBlock)(int64_t totalBytesWritten, CGFloat progress);
typedef void(^DownloadBreakOutBlock)(NSData *resumeData,NSError *error);

@interface ServerDownloadDataSource : NSObject

+ (ServerDownloadDataSource *)sharedServerDownloadDataSource;

/**
 *  处理download请求服务
 *
 *  @param url      下载请求地址
 *  @param path     下载本地目标地址
 *  @param isResume 是否续传
 */
- (void)downloadRequest:(NSString *)url
             targetPath:(NSString *)path
                 resume:(BOOL)isResume
             onProgress:(CommonBlockProgress)progressCallBack
           onCompletion:(CommonBlockCompletion)completionCallback
                onError:(CommonBlockError)errorCallback;

/**
 *  处理download请求服务
 *
 *  @param url                  下载请求地址
 *  @param path                 下载本地目标地址
 *  @param resumeData           断点续传的resumeData 可以传nil(新的下载)
 *  @param progressCallBack     下载进度
 *  @param completionCallback   下载完成
 *  @param errorCallback        下载失败、错误 可以获取到resumeData
 *  @param breakOutCallback     杀掉App重新进来下载的
 */
- (void)downloadRequest:(NSString *)url
             targetPath:(NSString *)path
             resumeData:(NSData *)resumeData
             onProgress:(DownloadProgressBlock)progressCallBack
           onCompletion:(CommonBlockCompletion)completionCallback
                onError:(DownloadResumeErrorBlock)errorCallback
               breakOut:(DownloadBreakOutBlock)breakOutCallback;

/**
 *  移除指定url的缓存
 *
 *  @param url 指定url
 */
- (void)removeCachedRequest:(NSString *)url;

/**
 *  取消指定url的下载
 *
 *  @param url 指定url
 */
- (void)cancelDownloadRequest:(NSString *)url;



@end
