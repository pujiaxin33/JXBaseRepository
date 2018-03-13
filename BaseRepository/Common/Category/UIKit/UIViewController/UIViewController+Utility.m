//
//  UIViewController+Utility.m
//  CodoonSport
//
//  Created by GaoYongyue on 16/5/30.
//  Copyright © 2016年 Codoon. All rights reserved.
//

#import "UIViewController+Utility.h"

@implementation UITabBarController (TopMost)

- (UIViewController *)topMostViewController
{
    return [self.selectedViewController topMostViewController];
}

@end

@implementation UINavigationController (TopMost)

- (UIViewController *)topMostViewController
{
    return [self.viewControllers.lastObject topMostViewController];
}

@end

@implementation UIViewController (Utility)

- (UIViewController *)topMostViewController
{
    if (self.presentedViewController != nil)
    {
        return [self.presentedViewController topMostViewController];
    }
    return self;
}

@end

