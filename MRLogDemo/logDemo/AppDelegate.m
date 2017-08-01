//
//  AppDelegate.m
//  logDemo
//
//  Created by MccRee on 2017/7/18.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "AppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <LumberjackConsole/PTEDashboard.h>
#import "MRLog.h"

@interface AppDelegate ()

extern CFAbsoluteTime StartTime;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self handleLog];
    DDLogInfo(@"appDelegate did Finish Launch");
    return YES;
}

- (void)handleLog{
    [PTEDashboard.sharedDashboard hide];
    MRLog *mr = [MRLog sharedMRLog];
    [mr appStartHandleLog];
    AppStart *as = [[AppStart alloc]init];
    as.duration =(CFAbsoluteTimeGetCurrent()-StartTime) * 1000;
    as.time = [self getCurrentTime];
    [mr logEventWithEventModel:as];
    
}

- (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    DDLogInfo(@"applicationWillResignActive");

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    DDLogInfo(@"applicationDidEnterBackground");

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    DDLogInfo(@"applicationWillEnterForeground");
    [self handleLog];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    DDLogInfo(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    DDLogInfo(@"applicationWillTerminate");
}


@end
