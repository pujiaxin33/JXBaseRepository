//
//  NSError+Additions.m
//  CodoonSport
//
//  Created by CHEN on 14-9-5.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import "NSError+Additions.h"

@implementation NSError (Additions)

+ (NSError *)errorWithCode:(NSInteger )errorCode
               description:(NSString *)errorDescription
{
    return [NSError errorWithDomain:@"com.jx.base"
                               code:errorCode
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorDescription, NSLocalizedDescriptionKey, nil]
            ];
}

@end
