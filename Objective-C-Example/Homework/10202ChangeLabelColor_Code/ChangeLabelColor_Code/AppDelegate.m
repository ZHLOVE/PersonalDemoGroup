//
//  AppDelegate.m
//  ChangeLabelColor_Code
//
//  Created by niit on 16/1/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"


// UIApplicaiton对象  (应用程序)
// AppDelegate对象    (应用程序代理类对象:负责应用程序生命周期响应处理)
//   |- UIWindows对象  (界面窗口:我们所看到界面的最底层的)
//        |- ViewController对象 (控制器对象:本身对象不可见,响应代码写在这个类里。它控制的视图可见)
//            |- UIView对象     (视图对象:被控制器所控制)
//                |- UILabel对象 (界面上的子视图对象)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // 创建界面
    
    // 1.创建self.window
    
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 作为主要窗体并可见(这样窗体可见并接受用户输入响应)
    [self.window makeKeyAndVisible];
    // 窗体背景色
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 2.创建视图控制器
    
    // 创建一个视图控制器
    ViewController *vc = [[ViewController alloc] init];
    // 把视图控制器作为window的根视图控制器(这样这个控制器控制的视图作为self.window的子视图了)
    self.window.rootViewController = vc;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
