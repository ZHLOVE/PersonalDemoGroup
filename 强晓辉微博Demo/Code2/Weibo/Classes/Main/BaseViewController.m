//
//  BaseViewController.m
//  Weibo
//
//  Created by qiang on 4/22/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "BaseViewController.h"

#import "VisitorView.h"
#import "OAuthViewController.h"


@implementation BaseViewController

// 加载视图的时候根据用户是否登录，判断是否要加载访客视图
- (void)loadView
{
    if([[UserAccount sharedUserAccount] isLogined]) // 用户已登录显示正常tableview
    {
        [super loadView];
    }
    else
    {
        // 未登录,加载访客视图
        VisitorView *view = [[VisitorView alloc] init];
        self.view = view;
        self.vistorView = view;
        
        // 设置导航栏按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerBtnPressed:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginBtnPressed:)];
        
    }
}

- (void)registerBtnPressed:(id)sender
{
    
}

- (void)loginBtnPressed:(id)sender
{
    // 弹出登录页
    OAuthViewController *authVC = [[OAuthViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:authVC];
    [self presentViewController:navi animated:YES completion:nil];
}

@end
