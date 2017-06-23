//
//  AppDelegate.m
//  Weibo
//
//  Created by niit on 16/3/1.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"

#import "NewFeatureViewController.h"

#import "MainViewController.h"
#import "MessageViewController.h"

// 代码创建的TabBarController对象,处理方法:
//

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSHomeDirectory());
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [self defaultViewController];
    
    return YES;
}

- (void)loadMainTabBar
{
    // 替换根视图控制器
    self.window.rootViewController = [self mainTabBarController];
}


- (UIViewController *)defaultViewController
{
    // 得判断是不是第一启动或者是新版本，如果第一次启动，从新特性页面启动，否则就从主页启动
    
    // 1. 得到app版本信息
    // [NSBundle mainBundle].infoDictionary 直接可以读项目设置文件info.plist
    // 打开info.plist 右键点show row key,可看到设置对应的key
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSLog(@"%@",version);
    
    // 2. 得到之前打开时的版本
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];// 保存一些简单的信息
    NSString *lastVersion = [userDefault objectForKey:@"lastOpenVersion"];
    
    // 3. 判断，启动不同的视图控制器
    if([lastVersion isEqualToString:version])
    {
        // 前次打开的版本，和当前版本一致，直接打开首页即可
        return [self mainTabBarController];
    }
    else
    {
        // 之前没有打开过，或是新版本, 打开新属性页面
        [userDefault setObject:version forKey:@"lastOpenVersion"];
        [userDefault synchronize];// 保存一下
        
        NewFeatureViewController *vc = [[NewFeatureViewController alloc] init];
        return vc;
    }
}

- (UITabBarController *)mainTabBarController
{
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    MainViewController *vc1 = [[MainViewController alloc] init];
    MessageViewController *vc2 = [[MessageViewController alloc] init];
    
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    tabBarController.viewControllers = @[navi1,navi2];
    
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *item1 = tabBar.items[0];
    UITabBarItem *item2 = tabBar.items[1];
    
    item1.title = @"首页";
    item2.title = @"消息";
    
    item1.image = [UIImage imageNamed:@"tabbar_home"];
    item1.selectedImage = [UIImage imageNamed:@"tabbar_home_highlighted"];
    
    item2.image = [UIImage imageNamed:@"tabbar_message_center"];
    item2.selectedImage = [UIImage imageNamed:@"tabbar_message_center_highlighted"];
    
    return tabBarController;
}


@end
