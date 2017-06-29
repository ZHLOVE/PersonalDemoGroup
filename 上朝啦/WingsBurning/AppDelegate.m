//
//  AppDelegate.m
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import "OpenShareHeader.h"
#import "LCGetWiFiSSID.h"
#import "Verify.h"
#import "MainVC.h"
#import "MainLeftVC.h"
#import "Record.h"
#import "GetPhoneType.h"
#import "BaseNavigationCongroller.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AppDelegate () <JPUSHRegisterDelegate,AMapLocationManagerDelegate>

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic, strong) AMapLocationManager *locationManager;


@end


@implementation AppDelegate

#ifdef DEBUG
static NSString *UMAppKey = @"12345678901234567890abcd";
#else
static NSString *UMAppKey = @"582e7012717c19402b000bab";
#endif
static NSString *JPushappKey = @"e4c9c133fd9c77870108142b";
static NSString *GaoDeKey = @"9e11ae27ff941640aa06d454f026d7e3";
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
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
         [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
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
    [JPUSHService setupWithOption:launchOptions appKey:JPushappKey channel:channel apsForProduction:isProduction];
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
    [self getPhoneType];
    [self setGaoDeMap];
    [self getLocation];
    [self createItemsWithIcons];
}

#pragma mark 配置高德地图appKey
- (void)setGaoDeMap{
    [AMapServices sharedServices].apiKey = GaoDeKey;
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setLocationTimeout:6];
    [self.locationManager setReGeocodeTimeout:2];
}




#pragma mark 配置友盟统计和友盟分享
/*
 *  友盟统计配置
 */
- (void)setUMengConfig{
    //设置友盟appkey
    UMConfigInstance.appKey = UMAppKey;
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
    //QQ
    [OpenShare connectQQWithAppId:@"1105809427"];
    //weiXin
    [OpenShare connectWeixinWithAppId:@"wx3b2ea37d15170309"];

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    return NO;
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
 * 获取当前坐标
 */
- (void)getLocation{
     [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
         if (error){
             DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
             if (error.code == AMapLocationErrorLocateFailed){
                 return;
             }
         }else{
             DLog(@"location:经度%f,纬度%f", location.coordinate.latitude, location.coordinate.longitude);
             [Verify setLatitude:@(location.coordinate.latitude)];
             [Verify setLongitude:@(location.coordinate.longitude)];
         }
     }];
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

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
}

/**
 *  设定本地通知提醒打卡everyDay
 */
- (void)setLocalNotificationWithHour:(NSString *)hour andMin:(NSString *)minute{
    JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
    content.body = @"上朝啦提醒您打卡";
    content.badge = @(-1);
    content.sound = @"sms-received1.caf";
    JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
    trigger.repeat = YES;
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.hour = [hour intValue];
    component.minute = [minute intValue];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        trigger.dateComponents = component; // iOS10以下有效
    }
    else {
        trigger.fireDate = [greCalendar dateFromComponents:component]; // iOS10以下有效
    }
    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
    request.content = content;
    request.trigger = trigger;
    request.requestIdentifier = [NSString stringWithFormat:@"打卡时间%@,%@",hour,minute];
    request.completionHandler = ^(id result) {
        DLog(@"%@", result); // iOS10以上成功则result为UNNotificationRequest对象，失败则result为nil;iOS10以下成功result为UILocalNotification对象，失败则result为nil
    };
    
    JPushNotificationIdentifier *findId = [[JPushNotificationIdentifier alloc]init];
    findId.identifiers = @[request.requestIdentifier];
    findId.findCompletionHandler = ^(NSArray *findResults){
        DLog(@"%@",findResults);
        if (findResults.count == 0) {
            /*
             * 查询通知不存在时添加
             */
            [JPUSHService addNotification:request];
        }
    };
    /*
     * 查询通知是否存在
     */
    [JPUSHService findNotification:findId];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [JPUSHService setBadge:0];//重置JPush服务器上面的badge值。如果下次服务端推送badge传"+1",则会在你当时JPush服务器上该设备的badge值的基础上＋1；
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//apple自己的接口，变更应用本地（icon）的badge值；

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self getLocation];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
