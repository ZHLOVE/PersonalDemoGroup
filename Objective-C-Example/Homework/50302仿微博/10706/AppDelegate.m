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
#import "NewFeatureUIScrollView.h"


@interface AppDelegate ()

@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //程序窗体
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
     //判断是否是第一次启动，第一次启动从新特性启动，否则从主页启动
    self.window.rootViewController = [self defaultViewController];
    return YES;
}

- (void)loadMainTabBar
{
    // 根视图替换成
    self.window.rootViewController = [self mainTabBarController];
}

- (UITabBarController *)mainTabBarController
{
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    //创建5个页面的对象
    HomeViewController *home = [[HomeViewController alloc]init];
    MessageCenterViewController *messageCenter = [[MessageCenterViewController alloc]init];
    ComposeAddViewController *composeAdd = [[ComposeAddViewController alloc]init];
    DiscoverViewController *discover = [[DiscoverViewController alloc]init];
    ProfileViewController *profile = [[ProfileViewController alloc]init];
//    NewFeatureUIScrollView *newFeatrueSV = [[NewFeatureUIScrollView alloc]init];
    
    home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home"] tag:1];
    [home.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_home_highlighted"]];
    messageCenter.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:[UIImage imageNamed:@"tabbar_message_center"] tag:2];
    [messageCenter.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_message_center_highlighted"]];
    composeAdd.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil  image:[UIImage imageNamed:@"tabbar_compose_button"] tag:3];
    [composeAdd.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"]];
    composeAdd.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    discover.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] tag:4];
    [discover.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_discover_highlighted"]];
    profile.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_profile"] tag:5];
    [profile.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_profile_highlighted"]];
    
    tabBarController.viewControllers = @[home,messageCenter,composeAdd,discover,profile];//设置标签栏子视图控制器
    tabBarController.tabBar.tintColor = [UIColor colorWithRed:1.00 green:0.51 blue:0.00 alpha:1.00];
    self.tabBarController = tabBarController;
    return  tabBarController;

}

- (UIViewController *)defaultViewController{
    // 得判断是不是第一启动或者是新版本，如果第一次启动，从新特性页面启动，否则就从主页启动
    // 1. 得到app版本信息
    // [NSBundle mainBundle].infoDictionary 直接可以读项目设置文件info.plist
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    // 2. 得到之前打开时的版本
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];// 保存一些简单的信息
    NSString *lastVersion = [userDefaults objectForKey:@"lastOpenVersion"];
    if([lastVersion isEqualToString:version])
    {
        // 前次打开的版本，和当前版本一致，直接打开首页即可
//        return [sb instantiateViewControllerWithIdentifier:@"main"];
        // 2) xib方式
//        HomeViewController *home = [[HomeViewController alloc]init];
        return [self mainTabBarController];
    }
    else
    {
        // 之前没有打开, 打开新属性页面
        [userDefaults setObject:version forKey:@"lastOpenVersion"];
        [userDefaults synchronize];// 保存一下
        NewFeatureUIScrollView *newFeatureSV = [[NewFeatureUIScrollView alloc] init];
//        newFeatureSV.tabBarController = self.tabBarController;
        return newFeatureSV;
    }
     NewFeatureUIScrollView *newFeatureSV = [[NewFeatureUIScrollView alloc] init];
    return newFeatureSV; 
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
