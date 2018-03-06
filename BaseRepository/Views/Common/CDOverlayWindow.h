//
//  DGOverlayWindow.h
//  DGUIKit
//
//  Created by Jinxiao on 2/17/14.
//  Copyright (c) 2013 debugeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDOverlayWindow : UIWindow

@property (readonly, nonatomic, strong) UIViewController *topVC;

+ (instancetype)sharedInstance;

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissAllViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

@end
