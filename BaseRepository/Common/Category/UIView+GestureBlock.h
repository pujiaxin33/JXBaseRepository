//
//  UIView+GestureBlock.h
//  BaseRepository
//
//  Created by Imp on 2018/3/7.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIView add gesture block

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (GestureBlock)

- (void)addTapActionBlock:(GestureActionBlock)actionBlock;

- (void)addLongPressActionBlock:(GestureActionBlock)actionBlock;

@end
