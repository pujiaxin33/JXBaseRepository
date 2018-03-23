//
//  YPServerConstans.m
//  BaseRepository
//
//  Created by Imp on 2018/3/23.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "YPServerConstans.h"

@implementation YPServerConstans

+ (NSString *)urlPathWithKey:(NSString *)key {
    NSAssert(key, @"key不能为nil");
    NSString *urlPath = [[self serverConstans] objectForKey:key];
    return [[self defaultHost] stringByAppendingString:urlPath];
}

+ (NSString *)defaultHost {
    return @"http://192.168.0.110:8081";
}

+ (NSDictionary *)serverConstans {
    return @{@"token"       :@"/token",
             @"userList"    :@"/home/user/list"};
}

@end
