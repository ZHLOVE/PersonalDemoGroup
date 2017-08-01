//
//  SJAppDelegateStoreDelegate.h
//  ShiJia
//
//  Created by yy on 16/6/16.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

/**
 *  i don't think each method need instruction...
 */
@protocol SJAppDelegateStoreDelegate <NSObject>

@optional

#pragma mark - notification

- (void)applicationDidEnterBackground;

- (void)applicationWillEnterForeground;

- (void)applicationDidBecomeActive;

- (void)applicationWillResignActive;

- (void)applicationWillTerminate;

- (void)applicationDidReceiveMemoryWarning;

- (void)applicationDidChangeStatusBarOrientation;

- (void)applicationWillChangeStatusBarOrientation;

- (void)applicationBackgroundRefreshStatusDidChange;


#pragma mark - delegate

- (BOOL)application_delegate:(UIApplication *)application
                     openURL:(NSURL *)url
           sourceApplication:(NSString *)sourceApplication
                  annotation:(id)annotation;

- (void)application_delegate:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)application_delegate:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token;

- (void)application_delegate:(UIApplication *)application
handleWatchKitExtensionRequest:(NSDictionary *)userInfo
                       reply:(void (^)(NSDictionary *))reply;
@end

