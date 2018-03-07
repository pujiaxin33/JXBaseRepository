//
//  UIView+GestureBlock.m
//  BaseRepository
//
//  Created by Imp on 2018/3/7.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "UIView+GestureBlock.h"
#import <objc/runtime.h>

static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;
static char kActionHandlerLongPressBlockKey;
static char kActionHandlerLongPressGestureKey;

@implementation UIView (GestureBlock)

- (void)addTapActionBlock:(GestureActionBlock)actionBlock {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, actionBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        GestureActionBlock actionBlock = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        if (actionBlock)
        {
            actionBlock(gesture);
        }
    }
}

- (void)addLongPressActionBlock:(GestureActionBlock)actionBlock {
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerLongPressGestureKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(self, &kActionHandlerLongPressBlockKey, actionBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        GestureActionBlock actionBlock = objc_getAssociatedObject(self, &kActionHandlerLongPressBlockKey);
        if (actionBlock)
        {
            actionBlock(gesture);
        }
    }
}
@end
