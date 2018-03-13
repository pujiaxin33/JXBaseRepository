//
//  UIView+CDExtension.h
//  CodoonSport
//
//  Created by Jinxiao on 9/7/16.
//  Copyright © 2016 Codoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CDLayoutExtension)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@end

extern CGFloat horizontalAdaptedSize(CGFloat size320, CGFloat size375);
extern CGFloat verticalAdaptedSize(CGFloat size480, CGFloat size667);
