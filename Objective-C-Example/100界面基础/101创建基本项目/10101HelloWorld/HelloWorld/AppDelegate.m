//
//  AppDelegate.m
//  HelloWorld
//
//  Created by niit on 16/1/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

// 常用的代理方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"程序已经完成载入");
    
    // 我们可以在这里:
    // 1 自定义设置
    // 2 载入界面
    // 3 读取用户配置信息
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"程序要进入暂停状态");
    
    // 1 暂停正在执行的任务
    // 2 暂停定时器
    // 3 降低OpenGL帧率
    // 4 暂停游戏
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"程序已经进入后台状态");
    
    // 1 释放共享资源
    // 2 存储状态
    // 3 要支持后台运行，这里要写相应代码
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"程序将要进入前台");
    // 恢复之前程序的运行
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"程序已经进入重新激活状态");
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"程序将要退出");
    
    // 保存设置和状态
}

@end
