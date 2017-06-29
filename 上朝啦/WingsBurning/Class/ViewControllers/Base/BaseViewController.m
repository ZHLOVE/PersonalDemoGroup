//
//  BaseViewController.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController()

@end



@implementation BaseViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        Networking *network = [Networking sharedNetwork];
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    /**
     *  设置导航条UI
     */
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;   //禁用侧滑手势

}

/**
 * 将跳转后的VC的导航栏返回按钮标题设为空
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIBarButtonItem *returnBtnItem = [[UIBarButtonItem alloc]init];
    returnBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = returnBtnItem;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end

