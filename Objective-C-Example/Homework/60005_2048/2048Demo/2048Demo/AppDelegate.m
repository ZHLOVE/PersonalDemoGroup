//
//  AppDelegate.m
//  2048Demo
//
//  Created by 马千里 on 16/3/18.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "AppDelegate.h"

#import "GuideViewController.h"
#import "GameViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [self defaultViewController];
    return YES;
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
        
        //每次都从新特新页面启动
        GuideViewController *guidVC = [[GuideViewController alloc] init];
        return guidVC;
        // 前次打开的版本，和当前版本一致，直接打开首页即可
//        GameViewController *gameVC = [[GameViewController alloc]init];
//        return gameVC;
        
    }
    else
    {
        // 之前没有打开, 打开新属性页面
        [userDefaults setObject:version forKey:@"lastOpenVersion"];
        [userDefaults synchronize];// 保存一下
        GuideViewController *guidVC = [[GuideViewController alloc] init];
        return guidVC;
    }
//    GuideViewController *guidVC = [[GuideViewController alloc] init];
    return nil;
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
