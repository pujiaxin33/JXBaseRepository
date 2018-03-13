//
//  UIViewController+CDNavigationItem.m
//  CodoonSport
//
//  Created by GaoYongyue on 16/8/13.
//  Copyright © 2016年 Codoon. All rights reserved.
//

#import "UIViewController+CDNavigationItem.h"

#import "UIBarButtonItem+CDProduce.h"

@implementation UIViewController (CDNavigationItem)

#pragma mark - 导航栏按钮事件
- (void)didNaviLeftButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didNaviRightButtonClicked
{

}


#pragma mark 导航栏按钮设置

- (void)setNaviLeftTitle:(NSString*)title{
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(didNaviLeftButtonClicked) title:title];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setNaviRightTitle:(NSString*)title{
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(didNaviRightButtonClicked) title:title];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setNaviLeftTitle:(NSString*)title
               textColor:(UIColor *)color{
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(didNaviLeftButtonClicked) title:title font:CDFont(kTitleSizeNormal) titleColor:color highlightedColor:nil titleEdgeInsets:UIEdgeInsetsZero];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setNaviRightTitle:(NSString*)title
                textColor:(UIColor *)color{
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(didNaviRightButtonClicked) title:title font:CDFont(kTitleSizeNormal) titleColor:color highlightedColor:nil titleEdgeInsets:UIEdgeInsetsZero];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setNaviLeftImage:(UIImage*)normal
               highlight:(UIImage*)highlight
{
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(didNaviLeftButtonClicked) image:normal];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setNaviLeftView:(UIView *)leftView
{   if (leftView == nil) {
        self.navigationItem.leftBarButtonItem = nil;
    }else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    }
}

- (void)setNaviRightView:(UIView *)rightView
{
    if (rightView == nil) {
        self.navigationItem.rightBarButtonItem = nil;
    }else {
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    }
}

- (void)setNaviRightImage:(UIImage*)normal
                highlight:(UIImage*)highlight
{
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(didNaviRightButtonClicked) image:normal];
    self.navigationItem.rightBarButtonItem = item;
}

@end
