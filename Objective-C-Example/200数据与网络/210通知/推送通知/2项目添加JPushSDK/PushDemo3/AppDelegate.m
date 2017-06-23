//
//  AppDelegate.m
//  PushDemo3
//
//  Created by niit on 16/4/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"

#import "JPUSHService.h"

static NSString *appKey = @"89fc6324411be018ecfeb9b0";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate ()

@end

@implementation AppDelegate

// 1. 添加SDK
// 2. 设置appKey
// 3. 添加以下代码
// 4. 加入framework

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 注册远程推送通知
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    
    // 设置极光推送, 1. 并向苹果APNS服务器注册TOKEN
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey
                          channel:channel
                 apsForProduction:isProduction];

    return YES;
}


// 2. 当接收到TOKEN的时候
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required -    DeviceToken
    NSLog(@"%@",deviceToken);
    // 3. 将TOKEN 提交给服务器
    [JPUSHService registerDeviceToken:deviceToken];
}

// 5. 接收到通知的时候
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:
//(NSDictionary *)userInfo {
//    NSLog(@"%s",__func__);
//    // Required,For systems with less than or equal to iOS6
//    [JPUSHService handleRemoteNotification:userInfo];
//}

// 5. 接收到通知的时候(>=iOS7)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    NSLog(@"%s",__func__);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// 2. 注册远程通知失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error
          );
}

@end
