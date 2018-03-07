//
//  CDAbstract.m
//  CodoonSport
//
//  Created by Leo on 14-5-5.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import "CDAbstractService.h"
#import "ServerHostManager.h"

@implementation CDAbstractService

+ (ServerDataSource *)defaultServer
{
    NSString *host = [ServerHostManager defaultHost];
    ServerDataSource *server = [[ServerDataSource alloc] initWithBaseUrl:host];
    return server;
}

+ (ServerDownloadDataSource *)downloadServer
{
    ServerDownloadDataSource *server = [ServerDownloadDataSource sharedServerDownloadDataSource];
    return server;
}


@end
