//
//  SJAppDelegateStore.h
//  ShiJia
//
//  Created by yy on 16/6/16.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJAppDelegateStoreDelegate.h"

@interface SJAppDelegateStore : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (SJAppDelegateStore*)sharedInstance;

- (void)listenApplicationStatus:(NSObject *)delegate;

#pragma mark bind && unbind
- (void)bind:(id<SJAppDelegateStoreDelegate>)obj;
- (void)unbind:(id<SJAppDelegateStoreDelegate>)obj;

#pragma mark -  custom methods for UIApplicationDelegate
- (BOOL)application_AppDelegateStore:(UIApplication *)application
                                openURL:(NSURL *)url
                      sourceApplication:(NSString *)sourceApplication
                             annotation:(id)annotation;

- (void)application_AppDelegateStore:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token;

- (void)application_AppDelegateStore:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;


@end
