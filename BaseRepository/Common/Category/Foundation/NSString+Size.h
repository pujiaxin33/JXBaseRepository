//
//  NSString+Size.h
//  CodoonSport
//
//  Created by gaoyongyue on 8/20/14.
//  Copyright (c) 2014 codoon.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)sizeOfFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeOfFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreak:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeOfFont:(UIFont *)font;
- (CGSize)sizeOfFont:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode;

- (CGFloat)lineHeightOfFont:(UIFont *)font;
- (CGFloat)lineWidthOfFont:(UIFont *)font;
- (CGFloat)lineHeightOfFont:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode;
- (CGFloat)lineWidthOfFont:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode;
@end
