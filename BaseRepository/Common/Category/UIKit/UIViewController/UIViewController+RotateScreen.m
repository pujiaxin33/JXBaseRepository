//
//  UIViewController+RotateScreen.m
//  BaseRepository
//
//  Created by Imp on 2018/3/6.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "UIViewController+RotateScreen.h"

@implementation UIViewController (RotateScreen)

+ (void) load {
    [UIViewController swizzleMethod:@selector(shouldAutorotate) withMethod:@selector(cd_shouldAutorotate) error:nil];
    [UIViewController swizzleMethod:@selector(supportedInterfaceOrientations) withMethod:@selector(cd_supportedInterfaceOrientations) error:nil];
    [UIViewController swizzleMethod:@selector(preferredInterfaceOrientationForPresentation) withMethod:@selector(cd_preferredInterfaceOrientationForPresentation) error:nil];
}

- (BOOL) cd_shouldAutorotate {
    if([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *controller = (UITabBarController *) self;
        return controller.selectedViewController.shouldAutorotate;
    }
    if([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *controller = (UINavigationController *) self;
        return controller.topViewController.shouldAutorotate;
    }
    if(self.presentedViewController && !self.presentedViewController.isBeingDismissed) {
        return self.presentedViewController.shouldAutorotate;
    }
    return NO;
}

- (UIInterfaceOrientationMask) cd_supportedInterfaceOrientations {
    if([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *controller = (UITabBarController *) self;
        return controller.selectedViewController.supportedInterfaceOrientations;
    }
    if([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *controller = (UINavigationController *) self;
        return controller.topViewController.supportedInterfaceOrientations;
    }
    if(self.presentedViewController && !self.presentedViewController.isBeingDismissed) {
        return self.presentedViewController.supportedInterfaceOrientations;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation) cd_preferredInterfaceOrientationForPresentation {
    if([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *controller = (UITabBarController *) self;
        return controller.selectedViewController.preferredInterfaceOrientationForPresentation;
    }
    if([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *controller = (UINavigationController *) self;
        return controller.topViewController.preferredInterfaceOrientationForPresentation;
    }
    if(self.presentedViewController && !self.presentedViewController.isBeingDismissed) {
        return self.presentedViewController.preferredInterfaceOrientationForPresentation;
    }
    return UIInterfaceOrientationPortrait;
}

@end
