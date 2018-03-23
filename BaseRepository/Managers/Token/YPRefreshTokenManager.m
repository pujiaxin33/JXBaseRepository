//
//  YPRefreshTokenManager.m
//  BaseRepository
//
//  Created by Imp on 2018/3/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "YPRefreshTokenManager.h"
#import "YPUserService.h"

@implementation YPRefreshTokenManager

+ (void)refreshTokenWithRequestToken:(NSString *)requestToken completion:(void(^)(NSString *newToken, NSError *error))completion {
    //1.先看currentToken是不是最新的Token,如果不是直接把最新token返回
    //2.如果已经是最新的token了，那么就用refreshToken换token,记录最新的token和refreshToken和过期时间  把最新的token返回去（注意只要新的token被使用，那么原来的refreshToken就作废了哦）
    //3.如果仍然失败，那么只能退出，重新登录<死前要再挣扎一次阿，阿门>
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token && [requestToken isEqualToString:token] == NO) {
        !completion ?: completion(token, nil);
    } else {
        NSLog(@"token本地token过期，需要刷新token");

        [[YPUserService sharedInstance] updateTokenWithComplete:^(id data, NSError *error) {
            //成功就取新的token,失败就取一次最新的token死前再挣扎一次
            //            NSString *newToken = [CDAccountManager sharedInstance].currentUserToken;
            NSString *newToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if ([newToken length] && [newToken isEqualToString:requestToken])
            {
                !completion ?: completion(@"", error);
            } else {
                !completion ?: completion(newToken, error);
            }
        }];
    }
}

+ (NSString *)currentRefreshToken
{
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"];
    return refreshToken;
}

+ (void)logout {
    //处理重新登录的逻辑 退出当前页面 切换到登录页面
}

@end
