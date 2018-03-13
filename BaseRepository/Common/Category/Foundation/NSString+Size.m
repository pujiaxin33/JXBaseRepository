//
//  NSString+Size.m
//  CodoonSport
//
//  Created by gaoyongyue on 8/20/14.
//  Copyright (c) 2014 codoon.com. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeOfFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize contentSize = [self boundingRectWithSize:size
                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                             attributes:@{NSFontAttributeName : font}
                                context:nil].size;
    return CGSizeMake(ceilf(contentSize.width), ceilf(contentSize.height));
}

- (CGSize)sizeOfFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreak:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    CGSize contentSize = [self boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                         attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy}
                                            context:nil].size;
    return CGSizeMake(ceilf(contentSize.width), ceilf(contentSize.height));
}

- (CGSize)sizeOfFont:(UIFont *)font
{
    CGSize contentSize = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    return CGSizeMake(ceilf(contentSize.width), ceilf(contentSize.height));
}

- (CGFloat)lineHeightOfFont:(UIFont *)font
{
    return ceilf(font.lineHeight);
}

- (CGFloat)lineWidthOfFont:(UIFont *)font
{
    return [self sizeOfFont:font].width;
}


- (CGSize)sizeOfFont:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    CGSize contentSize = [self sizeWithAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy}];
    return CGSizeMake(ceilf(contentSize.width), ceilf(contentSize.height));
}

- (CGFloat)lineHeightOfFont:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode
{
    return ceilf(font.lineHeight);
}

- (CGFloat)lineWidthOfFont:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode
{
    return [self sizeOfFont:font lineBreak:lineBreakMode].width;
}

@end
