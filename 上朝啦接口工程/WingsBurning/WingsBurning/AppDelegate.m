//
//  AppDelegate.m
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "AppDelegate.h"
#import "LCGetWiFiSSID.h"
#import "OutLog.h"
#import "ViewController.h"
#import "Verify.h"
#import "MainVC.h"
#import "MainLeftVC.h"
@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self defaultViewController];
    [self getWifiInfo];

    return YES;
}


- (void)getWifiInfo{
    NSString *SSID = [LCGetWiFiSSID getSSID];
    NSLog(@"SSID:%@",SSID);
    NSString *BSSID = [LCGetWiFiSSID getBSSID];
    NSLog(@"BSSID:%@",BSSID);
    NSString *locationIP = [LCGetWiFiSSID localIPAddress];
    NSLog(@"locationIP:%@",locationIP);
}

- (void)defaultViewController{
    BOOL accessToken = [Verify checkAccessToken];
    if (accessToken) {
        [self goToMainViewController];
    }else{
        UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *testVC = [main instantiateInitialViewController];
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        OutLog *vc = [[OutLog alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController = navi;
    }
}

/**
 *  判断主页面
 */
- (void)goToMainViewController{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    MainVC *mainVC = [[MainVC alloc]init];
    MainLeftVC *leftVC = [[MainLeftVC alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mainVC];
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:navi leftDrawerViewController:leftVC];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    self.window.rootViewController = self.drawerController;
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
