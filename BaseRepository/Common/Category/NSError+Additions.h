//
//  NSError+Additions.h
//  CodoonSport
//
//  Created by CHEN on 14-9-5.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Additions)

+ (NSError *)errorWithCode:(NSInteger )errorCode
               description:(NSString *)errorDescription;

@end
