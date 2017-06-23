//
//  AppDelegate.m
//  土豆TabBar
//
//  Created by qiang on 16/2/22.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    UIViewController *vc2 = [[UIViewController alloc] init];
    UIViewController *vc3 = [[UIViewController alloc] init];
    UIViewController *vc4 = [[UIViewController alloc] init];
    UIViewController *vc5 = [[UIViewController alloc] init];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[vc1,vc2,vc3,vc4,vc5];
    
    self.window.rootViewController = tabBarController;
    
    UITabBar *tabbar = tabBarController.tabBar;
    UITabBarItem *item1 = tabbar.items[0];
    UITabBarItem *item2 = tabbar.items[1];
    UITabBarItem *item3 = tabbar.items[2];
    UITabBarItem *item4 = tabbar.items[3];
    UITabBarItem *item5 = tabbar.items[4];
    
    item1.selectedImage = [[UIImage imageNamed:@"home_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"home_homepage_notselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item2.selectedImage = [[UIImage imageNamed:@"home_classify_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"home_classify_notselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item3.selectedImage = [[UIImage imageNamed:@"home_subscribe_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"home_subscribe"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item4.selectedImage = [[UIImage imageNamed:@"home_find_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"home_find_notselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item5.selectedImage = [[UIImage imageNamed:@"home_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.image = [[UIImage imageNamed:@"home_mine_notselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
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
