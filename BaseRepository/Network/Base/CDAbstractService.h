//
//  CDAbstract.h
//  CodoonSport
//
//  Created by Leo on 14-5-5.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerDataSource.h"
#import "ServerDownloadDataSource.h"

@interface CDAbstractService : NSObject

//TODO: 如果有多个服务器接口资源，就创建多个 ServerDataSource 实例
+ (ServerDataSource *)defaultServer;

/**
 *  下载请求server
 *
 *  @return 下载source
 */
+ (ServerDownloadDataSource *)downloadServer;

@end

