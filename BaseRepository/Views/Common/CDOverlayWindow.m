//
//  DGOverlayWindow.m
//  DGUIKit
//
//  Created by Jinxiao on 2/17/14.
//  Copyright (c) 2013 debugeek. All rights reserved.
//

#import "CDOverlayWindow.h"

@interface CDOverlayWindowRootViewController : UIViewController
@property (readwrite, nonatomic, assign) UIStatusBarStyle statusBarStyle;
@end

@implementation CDOverlayWindowRootViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _statusBarStyle;
}

@end

@interface CDOverlayWindow ()
@property (readwrite, nonatomic, strong) UIViewController *rootVC;
@property (readwrite, nonatomic, strong) NSMutableArray *viewControllers;
@property (readwrite, nonatomic, strong) NSLock *lock;
@property (readwrite, nonatomic, weak) UIWindow *originalKeyWindow;
@end

@implementation CDOverlayWindow

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.windowLevel = UIWindowLevelStatusBar - 1;
        self.backgroundColor = [UIColor clearColor];
        
        self.hidden = YES;
        
        self.lock = [[NSLock alloc] init];
        
        self.viewControllers = [[NSMutableArray alloc] init];

        CDOverlayWindowRootViewController *rootVC = [[CDOverlayWindowRootViewController alloc] init];
        rootVC.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;

        self.rootVC = rootVC;
        self.rootVC.view.backgroundColor = [UIColor clearColor];
        
        [self.rootVC beginAppearanceTransition:YES animated:NO];
        self.rootViewController = self.rootVC;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWindowBecomeKeyWindowNotification:) name:UIWindowDidBecomeKeyNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveWindowBecomeKeyWindowNotification:(NSNotification *)notification
{
    if(notification.object != self)
    {
        self.originalKeyWindow = notification.object;
    }
}

- (UIWindow *)originalKeyWindow
{
    return _originalKeyWindow ?: [UIApplication sharedApplication].delegate.window;
}

- (NSMutableArray *)viewControllers
{
    @synchronized(self)
    {
        return _viewControllers;
    }
}

- (UIViewController *)topVC
{
    if(self.viewControllers.count == 0)
    {
        return self.rootVC;
    }
    else
    {
        return self.viewControllers.lastObject;
    }
}

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if(![self.lock tryLock]) return;
    
    if(![self isKeyWindow])
    {
        [self makeKeyAndVisible];
    }
    
    UIViewController *topVC = self.topVC;
    [self.viewControllers addSafeObject:viewController];
    
    [topVC presentViewController:viewController animated:animated completion:^{
        [self.lock unlock];
        
        if(completion)
        {
            completion();
        }
    }];
}

- (void)dismissViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *topVC = self.topVC;
    if(topVC != viewController)
    {
        return;
    }
    
    if(![self.lock tryLock]) return;
    
    [viewController dismissViewControllerAnimated:animated completion:^{
        [self.lock unlock];
        
        [self.viewControllers removeLastObject];
        
        if(self.viewControllers.count == 0)
        {
            self.hidden = YES;
            [self.originalKeyWindow makeKeyAndVisible];
        }
        
        if(completion)
        {
            completion();
        }
    }];
}

- (void)dismissAllViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if(![self.lock tryLock]) return;
    
    [viewController dismissViewControllerAnimated:animated completion:^{
        [self.viewControllers removeLastObject];
        
        if(self.viewControllers.count == 0)
        {
            [self.lock unlock];
            
            self.hidden = YES;
            [self.originalKeyWindow makeKeyAndVisible];
            
            if(completion)
            {
                completion();
            }
        }
        else
        {
            UIViewController *controller = [self.viewControllers lastObject];
            [controller dismissViewControllerAnimated:YES completion:^{
                [self.lock unlock];
                [self.viewControllers removeLastObject];
                if(self.viewControllers.count == 0)
                {
                    self.hidden = YES;
                    [self.originalKeyWindow makeKeyAndVisible];
                }
                if(completion)
                {
                    completion();
                }
            }];
        }
    }];
}

@end
