//
//  YPRefreshTokenManager.h
//  BaseRepository
//
//  Created by Imp on 2018/3/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPRefreshTokenManager : NSObject

+ (void)refreshTokenWithRequestToken:(NSString *)requestToken completion:(void(^)(NSString *newToken, NSError *error))completion;

//本地的refreshToken
+ (NSString *)currentRefreshToken;

//需要让用户强制退出的情况
+ (void)logout;

@end
