//
//  AppDelegate.m
//  土豆TabBar
//
//  Created by student on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "ClassifyViewController.h"
#import "FindViewController.h"
#import "MineViewController.h"
#import "SubscribeViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    HomePageViewController *homePageVC = [[HomePageViewController alloc]init];
    ClassifyViewController *classifyVC = [[ClassifyViewController alloc]init];
    FindViewController *findVC = [[FindViewController alloc]init];
    SubscribeViewController *subscribeVC = [[SubscribeViewController alloc]init];
    MineViewController *mineVC = [[MineViewController alloc]init];
    
    tabBarController.viewControllers = @[homePageVC,classifyVC,findVC,subscribeVC,mineVC];
    
    homePageVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"home_homepage_notselected"] selectedImage:[UIImage imageNamed:@"home_homepage_selected"]];
    homePageVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UITabBarItem *item2 = [[UITabBarItem alloc]init];
    UITabBarItem *item3 = [[UITabBarItem alloc]init];
    UITabBarItem *item4 = [[UITabBarItem alloc]init];
    UITabBarItem *item5 = [[UITabBarItem alloc]init];
    
    item2.image = [UIImage imageNamed:@"home_classify_notselected"];
    item2.selectedImage = [UIImage imageNamed:@"home_classify_selected"];
    item3.image = [UIImage imageNamed:@"home_classify_notselected"];
    item3.selectedImage = [UIImage imageNamed:@"home_classify_selected"];
    item4.image = [UIImage imageNamed:@"home_classify_notselected"];
    item4.selectedImage = [UIImage imageNamed:@"home_classify_selected"];
    item5.image = [UIImage imageNamed:@"home_classify_notselected"];
    item5.selectedImage = [UIImage imageNamed:@"home_classify_selected"];
    
    self.window.rootViewController = tabBarController;
    //    item2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);//TabBar无文字调整位置;
    
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
