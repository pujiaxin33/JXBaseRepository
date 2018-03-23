//
//  ViewController.m
//  BaseRepository
//
//  Created by jiaxin on 2018/3/4.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ViewController.h"
#import "YPUserService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (IBAction)buttonAction:(id)sender {
    [[YPUserService sharedInstance] tokenWithUserName:@"shaofanli" password:@"4c1f1e8dd07ebcddb9c91b4949eedc8b" userVerifyCode:NO callback:^(id data, NSError *error) {
        if (error) {
            NSLog(@"error = %@",error);
        } else {
            NSLog(@"登陆成功");
        }
    }];
}

- (IBAction)userListAction:(id)sender {
    [YPUserService fetchUserListWithPage:1 limit:10 callback:^(id data, NSError *error) {
        if (error) {
            NSLog(@"error = %@",error);
        } else {
            NSLog(@"获取成功");
        }
    }];
}

@end
