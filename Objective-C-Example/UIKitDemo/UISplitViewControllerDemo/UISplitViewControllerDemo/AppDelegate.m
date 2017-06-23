//
//  AppDelegate.m
//  UISplitViewControllerDemo
//
//  Created by niit on 16/3/10.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    

    // 如果以Storyboard方式创建引用
    // didFinishLaunchingWithOptions方法是在Storyboard创建起始页面之后运行的
    // 此时 self.windwow 已经创建
    // self.window.rootViewController 已创建(就是Storyboard里的初始场景的控制器)
    
    
    // 得到当前根视图控制器
    UISplitViewController *splitViewController = self.window.rootViewController;
    NSLog(@"%@",splitViewController);
    // 得到splitViewController控制的控制器数组
    NSArray *vcArr = splitViewController.viewControllers;
    NSLog(@"%@",vcArr);
    
    // 得到MasterVC前套着的导航栏控制器
    UINavigationController *navi1 = vcArr[0];
    // 得到DetailVC前套着的导航栏控制器
    UINavigationController *navi2 = vcArr[1];
    
    // 得到导航栏控制器的根视图控制器,也就是masterVC 和 detailVC
    MasterViewController *masterVC = navi1.viewControllers[0];
    DetailViewController *detailVC = navi2.viewControllers[0];
    NSLog(@"%@",masterVC);
    NSLog(@"%@",detailVC);
    
    // 告诉masterVC:detailVC是哪个对象
    masterVC.detailVC = detailVC;
    
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
