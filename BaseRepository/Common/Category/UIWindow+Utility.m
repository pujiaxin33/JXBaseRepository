//
//  UIWindow+Utility.m
//  CodoonSport
//
//  Created by Jinxiao on 16/10/2017.
//  Copyright © 2017 Codoon. All rights reserved.
//

#import "UIWindow+Utility.h"

@implementation UIWindow (SafeAreaAdapter)

- (UIEdgeInsets)layoutInsets {
    if (@available(iOS 11.0, *)) {
        if (WindowsSize.height == 812 || WindowsSize.width == 812) {
            return CDAppDelegateWindow.safeAreaInsets;
        }
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
    return UIEdgeInsetsMake(20, 0, 0, 0);
}

@end

