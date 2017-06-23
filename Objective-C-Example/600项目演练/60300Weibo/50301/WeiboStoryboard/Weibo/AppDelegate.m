//
//  AppDelegate.m
//  Weibo
//
//  Created by niit on 16/3/1.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"

#import "NewFeatureViewController.h"


// 代码创建的TabBarController对象,处理方法:
//

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    self.window.rootViewController = [self defaultViewController];
    
    return YES;
}


- (UIViewController *)defaultViewController
{
    // 得判断是不是第一启动或者是新版本，如果第一次启动，从新特性页面启动，否则就从主页启动
    
    
    // 1. 得到app版本信息
    // [NSBundle mainBundle].infoDictionary 直接可以读项目设置文件info.plist
    // 打开info.plist 右键点show row key,可看到设置对应的key
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSLog(@"%@",version);
    
    
    // 2. 得到之前打开时的版本
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];// 保存一些简单的信息
    NSString *lastVersion = [userDefault objectForKey:@"lastOpenVersion"];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if([lastVersion isEqualToString:version])
    {
        // 前次打开的版本，和当前版本一致，直接打开首页即可
        // 1) storybodard方式
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"main"];// 通过storyboard里的场景创建视图控制器对象
        
//        // 2) xib方式
//        NewFeatureViewController *vc = [[NewFeatureViewController alloc] init];
        return vc;
    }
    else
    {
        // 之前没有打开过，或是新版本, 打开新属性页面
        [userDefault setObject:version forKey:@"lastOpenVersion"];
        [userDefault synchronize];// 保存一下
        
        return [sb instantiateViewControllerWithIdentifier:@"newFeature"];
    }
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
