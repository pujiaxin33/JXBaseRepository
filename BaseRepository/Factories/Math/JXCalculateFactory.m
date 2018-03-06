//
//  JXCalculateFactory.m
//  BaseRepository
//
//  Created by jiaxin on 2018/3/6.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXCalculateFactory.h"

@implementation JXCalculateFactory

+ (CGFloat)interpolateFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent {
    percent = MAX(0, MIN(1, percent));
    return (to - from)*percent + from;
}

@end
