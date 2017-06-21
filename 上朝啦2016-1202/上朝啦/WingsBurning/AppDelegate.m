//
//  AppDelegate.m
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import "LCGetWiFiSSID.h"
#import "Verify.h"
#import "MainVC.h"
#import "MainLeftVC.h"
#import "Record.h"
#import "JZLocationConverter.h"
#import "GetPhoneType.h"
#import "BaseNavigationCongroller.h"


#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <JPUSHRegisterDelegate>

@end


@implementation AppDelegate

static NSString *appKey = @"e4c9c133fd9c77870108142b";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self goToMainViewController];
    [self getDevideInfo];
    [self setUMengConfig];

    [self initAPNs];
    [self initJPush:launchOptions];
    return YES;
}

#pragma mark配置JPush
- (void)initAPNs{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)categories:nil];
    }
}

- (void)initJPush:(NSDictionary *)launchOptions{
    /* Optional
     * 获取IDFA
     * 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值*/
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    /* Required
     * init Push
     * notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
     * 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。*/
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction];
}

#pragma mark-注册APNs成功并上报DeviceToken

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}



- (void)getDevideInfo{
    [self getWifiInfo];
    [self getPhoneType];
    [self getLocation];
    [self createItemsWithIcons];
}




#pragma mark 配置友盟统计
/*
 *  友盟统计配置
 */
- (void)setUMengConfig{
    UMConfigInstance.appKey = @"582e7012717c19402b000bab";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}

/*
 *  3DTouch配置
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    BOOL state = [[Verify getContractStateToSandBox] isEqualToString:@"已经签约"];
    TokensM *token = [Verify getTokenFromSanBox];
    if ( state && token.access_token ) {
        if ([shortcutItem.type isEqualToString:@"punch"]) {
            DLog(@"punch");
            MMDrawerController *mmdController = (MMDrawerController *)self.window.rootViewController;
            [mmdController closeDrawerAnimated:NO completion:^(BOOL finished) {
                BaseNavigationCongroller *baseVC = (BaseNavigationCongroller *)mmdController.centerViewController;
                MainVC *main = baseVC.viewControllers[0];
                [main judgeLocationEnable];
            }];
        }
        if ([shortcutItem.type isEqualToString:@"punchRecord"]) {
            DLog(@"punchRecord");
            Record *recordVC = [[Record alloc]init];
            MMDrawerController *mmdController = (MMDrawerController *)self.window.rootViewController;
            [mmdController closeDrawerAnimated:NO completion:^(BOOL finished) {
                BaseNavigationCongroller *baseVC = (BaseNavigationCongroller *)mmdController.centerViewController;
                if ([baseVC.topViewController isKindOfClass:[Record class]]) {
                    DLog(@"已经在打卡记录页面");
                }else{
                    [baseVC pushViewController:recordVC animated:NO];
                    [mmdController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                }
            }];
        }
    }else{
        DLog(@"无token或者未登录");
    }
}

/**
 locationCorrrdinate 国测局标准
 wgsLocation WGS国际标准
 */
- (void)getLocation{
    CCLocationManager *manager = [CCLocationManager shareLocation];
    [manager getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        CLLocationCoordinate2D wgsLocation =  [JZLocationConverter gcj02ToWgs84:locationCorrrdinate];
        DLog(@"WGS84经度%f",wgsLocation.longitude);
        DLog(@"WGS84纬度%f",wgsLocation.latitude);
        [Verify setLongitude:@(wgsLocation.longitude)];
        [Verify setLatitude:@(wgsLocation.latitude)];
    }];
}

/*
 *  wifi信息
 */
- (void)getWifiInfo{
    NSString *SSID = [LCGetWiFiSSID getSSID];
    DLog(@"SSID:%@",SSID);
    NSString *BSSID = [LCGetWiFiSSID getBSSID];
    DLog(@"BSSID:%@",BSSID);
    NSString *locationIP = [LCGetWiFiSSID localIPAddress];
    DLog(@"locationIP:%@",locationIP);
}

/*
 *  手机型号
 */
- (void)getPhoneType{
    NSString *phoneModelStr = [GetPhoneType getPhoneModel];
    [Verify savePhoneType:phoneModelStr];
    DLog(@"机器型号:%@",phoneModelStr);
}


/**
 *  进入主页面
 */
- (void)goToMainViewController{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    MainVC *mainVC = [[MainVC alloc]init];
    MainLeftVC *leftVC = [[MainLeftVC alloc]init];
    BaseNavigationCongroller *naviCenter = [[BaseNavigationCongroller alloc]initWithRootViewController:mainVC];
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:naviCenter leftDrawerViewController:leftVC];
    self.drawerController.showsShadow = NO;
    [self.drawerController setMaximumLeftDrawerWidth:screenWidth * 0.7];
    [self.drawerController setMaximumRightDrawerWidth:screenWidth];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    self.window.rootViewController = self.drawerController;
}

/**
 *  3D Touch Icons创建
 */
- (void)createItemsWithIcons {
    if ([[Verify getContractStateToSandBox] isEqualToString:@"已经签约"]) {
        UIMutableApplicationShortcutItem *shortItem1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"punch" localizedTitle:@"打卡"];
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"打卡3DT"];
        shortItem1.icon = icon1;
        UIMutableApplicationShortcutItem *shortItem2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"punchRecord" localizedTitle:@"打卡记录"];
        UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"打卡记录3DT"];
        shortItem2.icon = icon2;
        NSArray *shortItems = [[NSArray alloc] initWithObjects:shortItem1, shortItem2,nil];
        [[UIApplication sharedApplication] setShortcutItems:shortItems];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [JPUSHService setBadge:0];//重置JPush服务器上面的badge值。如果下次服务端推送badge传"+1",则会在你当时JPush服务器上该设备的badge值的基础上＋1；
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//apple自己的接口，变更应用本地（icon）的badge值；
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self getLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
