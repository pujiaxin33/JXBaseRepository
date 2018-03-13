//
//  NSString+Utility.h
//  CodoonSport
//
//  Created by Jinxiao on 12/29/15.
//  Copyright © 2015 Codoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

+ (NSString *)uuid;

- (BOOL)isWhitespace;
- (BOOL)isEmptyOrWhitespace;
- (BOOL)isEmptyWhitespaceOrNewLines;

- (NSString *)md5;

- (NSString *)cd_safeSubstringWithRange:(NSRange)range;

@end
