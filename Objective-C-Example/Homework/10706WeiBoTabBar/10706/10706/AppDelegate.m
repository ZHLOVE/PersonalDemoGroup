//
//  AppDelegate.m
//  10706
//
//  Created by 马千里 on 16/2/22.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MessageCenterViewController.h"
#import "ComposeAddViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //程序窗体
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //创建5个页面的对象
    HomeViewController *home = [[HomeViewController alloc]init];
    MessageCenterViewController *messageCenter = [[MessageCenterViewController alloc]init];
    ComposeAddViewController *composeAdd = [[ComposeAddViewController alloc]init];
    DiscoverViewController *discover = [[DiscoverViewController alloc]init];
    ProfileViewController *profile = [[ProfileViewController alloc]init];
    
    home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home_highlighted"] tag:1];
    

    
//    [home.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_home_highlighted"]];
    
    messageCenter.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:[UIImage imageNamed:@"tabbar_message_center"] tag:2];
    composeAdd.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:[UIImage imageNamed:@"tabbar_compose_button"] tag:3];
    discover.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] tag:4];
    profile.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_profile"] tag:5];
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.viewControllers = @[home,messageCenter,composeAdd,discover,profile];//设置标签栏子视图控制器
    
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
