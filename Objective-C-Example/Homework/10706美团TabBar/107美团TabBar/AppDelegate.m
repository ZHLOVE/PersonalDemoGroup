//
//  AppDelegate.m
//  107美团TabBar
//
//  Created by student on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "MerchantViewController.h"
#import "MineViewController.h"
#import "MiscViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    HomePageViewController *homePageVC= [[HomePageViewController alloc]init];
    MerchantViewController *merchantVC = [[MerchantViewController alloc]init];
    MineViewController *mineVC = [[MineViewController alloc]init];
    MiscViewController *miscVC = [[MiscViewController alloc]init];
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    tabBar.viewControllers = @[homePageVC,merchantVC,mineVC,miscVC];
    
    homePageVC.title = @"首页";
    homePageVC.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_homepage"];
    homePageVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_tabbar_homepage_selected"];
    
    merchantVC.title = @"商家";
    merchantVC.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_merchant_normal"];
    merchantVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_tabbar_merchant_selected"];
    
    mineVC.title = @"我的";
    [mineVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"icon_tabbar_mine_selected"]];
    mineVC.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_mine"];
    
    miscVC.title = @"更多";
    [miscVC.tabBarItem setImage:[UIImage imageNamed:@"icon_tabbar_misc"]];
    [miscVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"icon_tabbar_misc_selected"]];
    //tabBar文字颜色
    tabBar.tabBar.tintColor = [UIColor colorWithRed:0.17 green:0.73 blue:0.69 alpha:1.00];
    self.window.rootViewController = tabBar;
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
