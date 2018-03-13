//
//  UIView+CDExtension.m
//  CodoonSport
//
//  Created by Jinxiao on 9/7/16.
//  Copyright © 2016 Codoon. All rights reserved.
//

#import "UIView+CDLayoutExtension.h"

@implementation UIView (CDLayoutExtension)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end


CGFloat horizontalAdaptedSize(CGFloat size320, CGFloat size375)
{
    CGFloat minimumSize = size320; // 320
    CGFloat maximumSize = size375; // 375
    CGFloat size = ([UIScreen mainScreen].bounds.size.width - 320.0)/(375.0 - 320.0)*(maximumSize - minimumSize) + minimumSize;
    size = fmax(size, minimumSize);
    size = fmin(size, maximumSize);
    return size;
}

CGFloat verticalAdaptedSize(CGFloat size480, CGFloat size667)
{
    CGFloat minimumSize = size480; // 480
    CGFloat maximumSize = size667; // 667
    CGFloat size = ([UIScreen mainScreen].bounds.size.height - 480.0)/(667.0 - 480.0)*(maximumSize - minimumSize) + minimumSize;
    size = fmax(size, minimumSize);
    size = fmin(size, maximumSize);
    return size;
}
