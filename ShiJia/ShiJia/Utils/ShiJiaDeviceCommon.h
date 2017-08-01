//
//  ShiJiaDeviceCommon.h
//  ShiJia
//
//  Created by yy on 16/3/10.
//  Copyright © 2016年 yy. All rights reserved.
//

#ifndef DidDriver_DidCommon_h
#define DidDriver_DidCommon_h

//#import "TKOSVersionMacros.h"



/**
 *  定义 子类方法必须调super的属性的宏
 */
#ifndef DID_REQUIRES_SUPER
#   if __has_attribute(objc_requires_super)
#       define DID_REQUIRES_SUPER __attribute__((objc_requires_super))
#   else
#       define DID_REQUIRES_SUPER
#   endif
#endif



#pragma mark - 版本判断宏
#define     IS_IOS6_OR_HIGHER   (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_1)
#define     IS_IOS7_OR_HIGHER   (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define     IS_IOS8_OR_HIGHER   (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)




#pragma mark - 区分不同代的iphone设备 主要区分屏幕大小
/**
 *  是否是iPhone4的大小 320*480
 */
#define IS_IPHONE_4         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                            CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否是iPhone5的大小 320*568
 */
#define IS_IPHONE_5         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                            CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否是iPhone6的大小 375*667
 */
#define IS_IPHONE_6         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                            CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否是iphone6 plus大小  414*736
 */
#define IS_IPHONE_6_PLUS    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                            CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否比iphone4大
 */
#define IS_BIGGER_THAN_IPHONE_4 (([[UIScreen mainScreen] bounds].size.height > 480.0f )? YES : NO)



#pragma mark - 屏幕大小的一些宏
/**
 *  屏幕的宽度
 */
#define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width)

/**
 *  屏幕的高度（如果为iOS7以前 则减屏幕高度减掉20）
 */
#define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height - (IS_IOS7_OR_HIGHER ? 0 : 20))

/**
 *  导航栏的高度
 */
#define NAVIGATION_BAR_HEIGHT   (IS_IOS7_OR_HIGHER ? 64 : 44)



#define STR(x) ((x) ? (x) : @"")


#define SAFE_RELEASE(X)  X = nil;

// 之前用的是 [[UIApplication sharedApplication] keyWindow]
// https://github.com/mflint/KIF/commit/31bdb0781b4f46b891c29ca0721ad98ecdf1bae2
#define kAppWindow [[[UIApplication sharedApplication] delegate] window]

#define APP_DELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)


#define ALERT(t,m)  \
do { \
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:t message:m delegate:nil \
    cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
    [alt show]; \
} while (0)



#pragma mark - 设备信息
#define kIOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define kDEVICE_MODEL [[UIDevice currentDevice] model]
#define kIS_IPAD \
([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define kisRetina                                                 \
([UIScreen instancesRespondToSelector:@selector(currentMode)] \
? CGSizeEqualToSize(CGSizeMake(640, 960),             \
[[UIScreen mainScreen] currentMode].size)       \
: NO)
#define kAPP_NAME \
[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kAPP_VERSION                        \
[[[NSBundle mainBundle] infoDictionary] \
objectForKey:@"CFBundleShortVersionString"]
#define kAPP_SUB_VERSION \
[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kUDeviceIdentifier [[UIDevice currentDevice] uniqueDeviceIdentifier]

#pragma mark - 常用宏定义
#define kWS(weakSelf) __weak __typeof(&*self) weakSelf = self;
#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kUSER_DEFAULT [NSUserDefaults standardUserDefaults]
#define kNOTIFICATION_DEFAULT [NSNotificationCenter defaultCenter]
#define kIMAGENAMED(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]
#define kLOADIMAGE(file, ext)                                               \
[UIImage                                                                \
imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file \
ofType:ext]]

#define kScreenWidthScaleSize (MIN(kSCREEN_WIDTH, kSCREEN_HEIGHT) / 320.0)
#define kScreenWidthScaleSizeByIphone6 \
(MIN(kSCREEN_WIDTH, kSCREEN_HEIGHT) / 375.0)

#define kDegreesToRadian(x) (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

#pragma mark - ios版本判断

#define kIOS5_OR_LATER \
([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending)
#define kIOS6_OR_LATER \
([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending)
#define kIOS7_OR_LATER \
([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define kIOS8_OR_LATER \
([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
#define kIOS10_OR_LATER \
([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending)

#pragma mark - 是否为空或是[NSNull null]

#define kNotNilAndNull(_ref) \
(((_ref) != nil) && (![(_ref)isEqual:[NSNull null]]))
#define kIsNilOrNull(_ref) (((_ref) == nil) || ([(_ref)isEqual:[NSNull null]]))


#pragma mark - 定义字号
#define kFONT_TITLE(X) [UIFont systemFontSize:X]
#define kFONT_CONTENT(X) [UIFont systemFontSize:X]

#pragma mark - 定义通知的key
#define kNotification_PayResult            @"kNotification_PayResult"
#define kNotification_AlipayResult         @"kNotification_AlipayResult"
#define TPIMNotification_ReloadUser        @"reloadUser"
#define TPIMNotification_Remote            @"kNotification_Remote"
#define TPIMNotification_NetReachability   @"kNotification_NetReachability"
#define TPIMNotification_UserInterested    @"kNotification_UserInterested"
#define TPIMNotification_BuyNow            @"kNotification_BuyNow"
#define TPIMNotification_FollowFriends            @"kNotification_FollowFriends"
#define TPIMNotification_FollowJoinRoom            @"kNotification_FollowJoinRoom"
#define TPIMNotification_MessagePermissionChanged  @"kNotification_MessagePermissionChanged"
#define TPIMNotification_GOREMOTE            @"kNotification_GOREMOTE "
#define TPIMNotification_VIPINFO            @"kNotification_VIPINFO"
#define TPIMNotification_NOTI21            @"kNotification_NOTI21"
#define TPIMNotification_vedioReadyToPlay @"vedioReadyToPlay"
#define TPIMNotification_LaunchAD           @"kNotification_LaunchAD"
#define kNotification_dlnaBroastcastCallbackImp @"kNotification_dlnaBroastcastCallbackImp"
#define kNotification_dlnaDevicesCallbackImp @"kNotification_dlnaDevicesCallbackImp"
#define kNotification_dlnaDoActionCallbackImp @"kNotification_dlnaDoActionCallbackImp"
#define kNotification_ShowMainViewController            @"kNotification_ShowMainViewController"
#define kNotification_WMPLAYERPAUSE            @"kNotification_WMPLAYERPAUSE"
#define kNotification_TVLOGIN            @"kNotification_TVLOGIN"
#define kNotification_REFRASHMAIN            @"kNotification_REFRASHMAIN"


#pragma mark - appkey等
#define kShareSDK_appKey                @"1e192a5d6658"
#define kWeChat_appKey                  @"wx7e8eef23216bade2"
#define kWeChat_appSeret                @"7d16050030094819299bc5c8382023e8"

#pragma mark - key 
#define kAddressListPermissionKey       @"AddressListPermissionKey" //通讯录权限
#define kProgramKuaiBaoPermissionKey    @"ProgramKuaiBaoPermissionKey" //节目快报通知
#define kProgramReminderPermissionKey   @"ProgramReminderPermissionKey" //节目提醒通知
#define kShowHeaderAdKey                @"ShowHeaderAdKey"//头部广告
#define kOfflineMessageKey              @"OfflineMessageKey" //离线消息通知
#define kResumeVideoSwitchKey           @"ResumeVideoSwitchKey" //离家/回家模式消息提醒开关

#define kPlayerError @"PlayerError"

#endif
