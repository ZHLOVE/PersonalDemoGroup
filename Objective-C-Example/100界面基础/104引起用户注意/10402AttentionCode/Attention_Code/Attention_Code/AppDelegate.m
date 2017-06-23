//
//  AppDelegate.m
//  Attention_Code
//
//  Created by niit on 16/2/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

// 应用程序中的对象
// 应用程序对象        UIApplication类
// 应用程序代理类对象   AppDelegate类 (继承自 UIResponder 实现了<UIApplicationDelegate>协议)
// 窗口对象           UIWindow类
// 视图控制器对象      ViewController类 (继承自 UIViewController）
// 可见对象
// 视图对象           UIView类

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // 创建窗体
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 作为主窗体
    [self.window makeKeyAndVisible];
    // 背景色
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 创建一个控制器，控制器控制的视图就会显示条window上
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    
    return YES;
}

@end
