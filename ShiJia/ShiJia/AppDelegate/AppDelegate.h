//
//  AppDelegate.h
//  ShiJia
//
//  Created by yy on 16/1/29.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJAppdelegateService.h"
#import <FWeiXinSDK/WXApi.h>
#import <WeiboSDK/WeiboSDK.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SJAppdelegateService *appdelegateService;
@property (nonatomic) BOOL isLockDevice;//(0--锁住 1--不锁)


+ (AppDelegate*)appDelegate;


@end

