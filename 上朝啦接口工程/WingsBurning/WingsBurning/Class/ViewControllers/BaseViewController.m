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

- (void)viewDidLoad{
    [super viewDidLoad];
    Networking *network = [Networking sharedNetwork];
    /**
     *  设置导航条UI
     */
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{@"NSForegroundColorAttributeName":[UIColor whiteColor]}];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
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

