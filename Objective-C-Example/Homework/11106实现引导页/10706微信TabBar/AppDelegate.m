//
//  AppDelegate.m
//  10706微信TabBar
//
//  Created by student on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiXinViewController.h"
#import "ContactsViewController.h"
#import "DiscoverViewController.h"
#import "MeViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    WeiXinViewController *weixinVC = [[WeiXinViewController alloc]init];
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"微信" image:[UIImage imageNamed:@"tabbar_mainframe"] selectedImage:[UIImage imageNamed:@"tabbar_mainframeHL"]];
    weixinVC.tabBarItem = item;
    
    ContactsViewController *contactsVC = [[ContactsViewController alloc]init];
    
    DiscoverViewController *discoverVC = [[DiscoverViewController alloc]init];
    MeViewController *meVC = [[MeViewController alloc]init];
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    //tabBar文字颜色
    tabBarController.tabBar.tintColor = [UIColor greenColor];
    
    contactsVC.title = @"联系人";
    discoverVC.title = @"发现";
    meVC.title = @"我";
    
    tabBarController.viewControllers = @[weixinVC,contactsVC,discoverVC,meVC];
    
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *item2 = tabBar.items[1];
    UITabBarItem *item3 = tabBar.items[2];
    UITabBarItem *item4 = tabBar.items[3];
    
    item2.image = [[UIImage imageNamed:@"tabbar_contacts"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"tabbar_contactsHL"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"tabbar_discover"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"tabbar_discoverHL"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"tabbar_me"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"tabbar_meHL"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    contactsVC.tabBarItem = item2;
    discoverVC.tabBarItem = item3;
    meVC.tabBarItem = item4;
    //    item2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);//TabBar无文字调整位置;
    item3.badgeValue = @"99+";
    
    self.window.rootViewController = tabBarController;
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
