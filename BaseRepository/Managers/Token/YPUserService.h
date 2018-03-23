//
//  YPUserService.h
//  BaseRepository
//
//  Created by Imp on 2018/3/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "CDAbstractService.h"

@interface YPUserService : CDAbstractService

+ (instancetype)sharedInstance;

- (void)updateTokenWithComplete:(CompleteCallback)callback;

- (void)tokenWithUserName:(NSString *)userName password:(NSString *)password userVerifyCode:(BOOL)userVerify callback:(CompleteCallback)callback;

+ (void)fetchUserListWithPage:(NSInteger)page limit:(NSInteger)limit callback:(CompleteCallback)callback;

@end
