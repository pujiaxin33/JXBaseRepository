//
//  UIViewController+CDNavigationItem.h
//  CodoonSport
//
//  Created by GaoYongyue on 16/8/13.
//  Copyright © 2016年 Codoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (CDNavigationItem)


#pragma mark 导航栏按钮事件
/**
 *  左按钮被点击时调用
 *  需要时重载此函数
 */
- (void)didNaviLeftButtonClicked;

/**
 *  右按钮被点击时调用
 *  需要时重载此函数
 */
- (void)didNaviRightButtonClicked;


#pragma mark 导航栏按钮设置
/**
 *  设置导航栏左按钮标题
 *
 *  @param title 标题文字
 */
- (void)setNaviLeftTitle:(NSString*)title;
- (void)setNaviLeftTitle:(NSString*)title textColor:(UIColor *)color;

/**
 *  设置导航栏右按钮标题
 *
 *  @param title 标题文字
 */
- (void)setNaviRightTitle:(NSString*)title;
- (void)setNaviRightTitle:(NSString*)title textColor:(UIColor *)color;

/**
 *  设置导航栏左按钮图标
 *
 *  @param normal    普通状态图标
 *  @param highlight 高亮状态图标
 */
- (void)setNaviLeftImage:(UIImage*)normal highlight:(UIImage*)highlight;

/**
 *  设置导航栏左按钮
 *
 *  @param leftView 自定义视图
 */
- (void)setNaviLeftView:(UIView *)leftView;

- (void)setNaviRightView:(UIView *)rightView;

/**
 *  设置导航栏右按钮图标
 *
 *  @param normal    普通状态图标
 *  @param highlight 高亮状态图标
 */
- (void)setNaviRightImage:(UIImage*)normal highlight:(UIImage*)highlight;


@end
