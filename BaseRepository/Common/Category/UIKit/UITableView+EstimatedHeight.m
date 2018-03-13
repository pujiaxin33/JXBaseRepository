//
//  UITableView+EstimatedHeight.m
//  CodoonSport
//
//  Created by Imp on 2017/8/24.
//  Copyright © 2017年 Codoon. All rights reserved.
//

#import "UITableView+EstimatedHeight.h"

@implementation UITableView (EstimatedHeight)

+ (void)load {
    if (CDIPHONE_OS_MIN_VERSION_ALLOWED(@"11.0")) {
        [UITableView swizzleMethod:@selector(initWithFrame:style:) withMethod:@selector(cd_initWithFrame:style:) error:nil];
        [UITableView swizzleMethod:@selector(initWithCoder:) withMethod:@selector(cd_initWithCoder:) error:nil];
    }
}

// default is UITableViewAutomaticDimension, set to 0 to disable
- (id)cd_initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    UITableView *tableView = [self cd_initWithFrame:frame style:style];
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    return tableView;
}

- (id)cd_initWithCoder:(NSCoder *)aDecoder {
    UITableView *tableView = [self cd_initWithCoder:aDecoder];
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    return tableView;
}

@end
