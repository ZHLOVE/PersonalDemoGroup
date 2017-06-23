//
//  AppDelegate.m
//  Calculation
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"

#import "AreaViewController.h"
#import "VolumeViewController.h"

#import "SummaryViewController.h"

// 1. 采用ToolBar方式的结构
// MainViewController (自定义的视图控制器)
// -View
//   |-(AreaViewController或者VolumeViewControlle的view)
//   |-UIToolBar对象

// MainViewController
// |-AreaViewController 对象
//   |-view
// |-VolumeViewController对象
//   |-view


// 2. 采用TabBarController的结构
// UITabbarConller对象
// -UIView
//  |-(子视图控制器控制的视图)
//  |-UITabBar视图

// UITabbarConller对象
// |-AreaViewController 对象
//   |-view
// |-VolumeViewController对象
//   |-view
// |-SummaryViewController
//   |-view

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 1. 创建子视图控制器
    // 创建计算面积的视图控制器
    AreaViewController *areaVC = [[AreaViewController alloc] init];
    // 设置标签栏上的文字及图片
    areaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"面积" image:[UIImage imageNamed:@"Area"] tag:0];
    
    // 创建计算体积的视图控制器
    VolumeViewController *volumeVC = [[VolumeViewController alloc] init];
    volumeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"体积" image:[UIImage imageNamed:@"Volume"] tag:1];
    
    // 创建统计次数的视图控制器
    SummaryViewController *summaryVC = [[SummaryViewController alloc] init];
    summaryVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"统计" image:[UIImage imageNamed:@"Summary"] tag:2];
    
    // 告诉areaVC,volumeVC,第三个视图控制器是哪个对象,以便他们程序中调用
    areaVC.summaryVC = summaryVC;
    volumeVC.summaryVC = summaryVC;
    
    // 2. 创建标签栏控制器(标签栏控制器中包含一个标签栏视图控件)
    UITabBarController *tabController = [[UITabBarController alloc] init];
    tabController.viewControllers = @[areaVC,volumeVC,summaryVC];// 设置标签栏控制器控制的子视图控制器
    tabController.selectedIndex = 1;// 当前选中的标签项
    
    self.window.rootViewController = tabController;
    
    return YES;
}

@end
