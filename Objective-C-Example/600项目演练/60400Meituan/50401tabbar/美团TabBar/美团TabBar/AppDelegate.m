//
//  AppDelegate.m
//  美团TabBar
//
//  Created by qiang on 16/2/22.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "AppDelegate.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)     RGBA(r, g, b, 1.0f)

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
    vc1.title = @"团购";
    // =>
//    vc1.tabBarItem.title = @"团购";
//    vc1.navigationItem.title = @"团购";
    vc2.title = @"上门";
    vc3.title = @"商家";
    vc4.title = @"我的";
    vc5.title = @"更多";
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[vc1,vc2,vc3,vc4,vc5];
    
    self.window.rootViewController = tabBarController;
    
    UITabBar *tabbar = tabBarController.tabBar;
    UITabBarItem *item1 = tabbar.items[0];
    UITabBarItem *item2 = tabbar.items[1];
    UITabBarItem *item3 = tabbar.items[2];
    UITabBarItem *item4 = tabbar.items[3];
    UITabBarItem *item5 = tabbar.items[4];
    
    item1.selectedImage = [[UIImage imageNamed:@"icon_tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"icon_tabbar_homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"icon_tabbar_onsite_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"icon_tabbar_onsite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    item2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item3.selectedImage = [[UIImage imageNamed:@"icon_tabbar_merchant_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"icon_tabbar_merchant_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    item3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item4.selectedImage = [[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    item4.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item5.selectedImage = [[UIImage imageNamed:@"icon_tabbar_misc_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.image = [[UIImage imageNamed:@"icon_tabbar_misc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 改变选中的颜色
    tabBarController.tabBar.tintColor = RGB(54, 185,175);
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(54, 185,175),UITextAttributeTextColor, nil] forState:UIControlStateSelected];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(54, 185,175),UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    item1.badgeValue = @"10";
    
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
