//
//  YPUserService.m
//  BaseRepository
//
//  Created by Imp on 2018/3/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "YPUserService.h"
#import "CDGTMBase64.h"
#import "YPServerConstans.h"
#import <pthread.h>
#import "ServerHostManager.h"

const NSString *appKey = @"JBCID4CE9792EDEDD4253BE14506F5CF797C4";
const NSString *appSecret = @"JBCSFA0172D8253044A8867CE11B39DFA5B7E051723EB4D340E888CE5784240CF5AA";

@interface YPUserService ()

@property (nonatomic, strong) NSMutableArray *tokenCallbaks;
@property (nonatomic, assign) BOOL isRefreshingToken;
@property (nonatomic, assign) pthread_mutex_t lock;

@end

@implementation YPUserService

SHARED_INSTANCE(YPUserService)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _tokenCallbaks = [[NSMutableArray alloc] init];
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)updateTokenWithComplete:(CompleteCallback)callback {
    NSLog(@"刷新token中。。。");
    void (^completion) (id data, NSError *error) = ^(id data, NSError *error) {
        pthread_mutex_lock(&_lock);

        if(data != nil && error == nil)
        {
            [self handleResult:data];
        }
        self.isRefreshingToken = NO;
        [self.tokenCallbaks enumerateObjectsUsingBlock:^(CompleteCallback obj, NSUInteger idx, BOOL * stop) {
            !obj ?: obj(nil, error);
        }];
        [self.tokenCallbaks removeAllObjects];

        pthread_mutex_unlock(&_lock);
    };

    pthread_mutex_lock(&_lock);

    [self.tokenCallbaks addSafeObject:callback];

    if(!self.isRefreshingToken)
    {
        self.isRefreshingToken = YES;
        //验证信息
        NSString *secureDataStr = [@[appKey,appSecret] componentsJoinedByString:@":"];
        NSData *secureData = [secureDataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *secure = [CDGTMBase64 stringByWebSafeEncodingData:secureData padded:YES];

        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"];
        NSMutableDictionary *params = [@{@"grant_type":@"refresh_token"} mutableCopy];

        if (refreshToken && [refreshToken length]) {
            [params setSafeObject:refreshToken forKey:@"refresh_token"];
        } else {
            [params setSafeObject:@"" forKey:@"refresh_token"];
            [params setSafeObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
        }
        NSString *url = [YPServerConstans urlPathWithKey:@"token"];
        [[[self class] defaultServer] post:url params:params cache:NO type:CDHttpSerializerTypeForm token:secure tokenType:@"Basic" onCacheFlagCompletion:^(id obj, BOOL cache) {
            completion(obj,nil);
        } onError:^(NSError *error) {
            completion(nil,error);
        }];
    }
    pthread_mutex_unlock(&_lock);
}

- (void)handleResult:(NSDictionary *)result {
    //获得新的 token
    NSString *newToken = result[@"access_token"];
    NSString *refreshToken = result[@"refresh_token"];
    double expireTime = [[result validNumberForKey:@"expire_in"] doubleValue];

    if (refreshToken && [refreshToken isKindOfClass:[NSNull class]])
    {
        refreshToken = @"";
    }
    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refresh_token"];
    [[NSUserDefaults standardUserDefaults] setObject:@(expireTime) forKey:@"expire_time"];
    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tokenWithUserName:(NSString *)userName password:(NSString *)password userVerifyCode:(BOOL)userVerify callback:(CompleteCallback)callback {
    //验证信息
    NSString *secureDataStr = [@[appKey,appSecret] componentsJoinedByString:@":"];
    NSData *secureData = [secureDataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *secure = [CDGTMBase64 stringByWebSafeEncodingData:secureData padded:YES];

    //参数字典
    NSDictionary *params = @{@"grant_type":@"password",
                             @"username":userName,
                             @"password":password};
    if(userVerify){
        params = @{@"grant_type":@"mobile_code",
                   @"client_secret":appSecret,
                   @"mobile":userName,
                   @"verify_code":password};
    }
    //链接
    NSString *url = [YPServerConstans urlPathWithKey:@"token"];

    //服务器资源
    ServerDataSource *server = [[self class] defaultServer];

    //发送
    __weak typeof(self)weakSelf = self;
    [server post:url
          params:params
           cache:NO
            type:CDHttpSerializerTypeForm
           token:secure
       tokenType:@"Basic" onCacheFlagCompletion:^(NSDictionary *result, BOOL cacheFlag) {
           [weakSelf handleResult:result];
           NSString *newToken = result[@"access_token"];
//           [weakSelf fetchUserProfile:newToken oauth:nil callback:callback];
       } onError:^(NSError *error) {
           callback(nil, error);
       }];
}

//根据token获取用户资料
- (void)fetchUserProfile:(NSString *)token oauth:(id)oauth callback:(CompleteCallback)callback {
    NSString *url = [YPServerConstans urlPathWithKey:@"userList"];
    NSMutableDictionary *params = @{}.mutableCopy;
    [[[self class] defaultServer] post:url params:params cache:NO onCompletion:^(id obj) {
        !callback?:callback(obj,nil);
    } onError:^(NSError *error) {
        !callback?:callback(nil,error);
    }];
}

+ (void)fetchUserListWithPage:(NSInteger)page limit:(NSInteger)limit callback:(CompleteCallback)callback {
    NSString *url = [YPServerConstans urlPathWithKey:@"userList"];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setSafeObject:@(page) forKey:@"page_index"];
    [params setSafeObject:@(limit) forKey:@"page_size"];
    [[[self class] defaultServer] post:url params:params cache:NO onCompletion:^(id obj) {
        !callback?:callback(obj,nil);
    } onError:^(NSError *error) {
        !callback?:callback(nil,error);
    }];
}

@end
