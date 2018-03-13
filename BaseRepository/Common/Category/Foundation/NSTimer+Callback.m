//
//  NSTimer+Callback.m
//  CodoonBluetoothKit
//
//  Created by CHEN on 15/7/24.
//  Copyright (c) 2015年 com.codoon. All rights reserved.
//

#import "NSTimer+Callback.h"

@interface NSTimer (CallbackPrivate)

+ (void)cd_executeBlockFromTimer:(NSTimer *)aTimer;

@end

@implementation NSTimer(Callback)

+ (id)cd_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats
{
    NSParameterAssert(block != nil);
    return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(cd_executeBlockFromTimer:) userInfo:[block copy] repeats:inRepeats];
}

+ (id)cd_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats
{
    NSParameterAssert(block != nil);
    return [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(cd_executeBlockFromTimer:) userInfo:[block copy] repeats:inRepeats];
}

+ (void)cd_executeBlockFromTimer:(NSTimer *)aTimer {
    void (^block)(NSTimer *) = [aTimer userInfo];
    if (block) block(aTimer);
}

@end
