//
//  AppDelegate.m
//  ShiJia
//
//  Created by yy on 16/1/29.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "AppDelegate.h"
#import "SJAppDelegateStore.h"
#import "BIMSManager.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "IFlyFlowerCollector.h"
#import "iflyMSC/iflySetting.h"

#import <Bugly/Bugly.h>
#import "mgServer.h"
#import "HWOauthManager.h"
#import "TalkingData.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <LumberjackConsole/PTEDashboard.h>

#define APP_VERCODE_LIMIT 3

@interface AppDelegate ()
{
    dispatch_queue_t srvQueue;

    NSTimer *verTimer;              //验证码计时器
    NSUInteger verTimeLimit;        //验证码计数
}
@property (strong, nonatomic) UIView *ADView;
@property (strong, nonatomic) UIButton *passBtn;

@end

@implementation AppDelegate

#pragma mark - Lifecycle
- (void)dealloc
{
    _appdelegateService = nil;
}

+ (AppDelegate*)appDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[NSThread sleepForTimeInterval:2];
    [self setCocoaLumberjackLog];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainVC)
                                                 name:kNotification_ShowMainViewController
                                               object:nil];
    [self mainSandboxManager];

    if (srvQueue == nil) {
        srvQueue = dispatch_queue_create(class_getName([self class]), NULL);
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:k1StatusStyle];
    [application setApplicationIconBadgeNumber:0];

    [self firstLaunching];

    _appdelegateService = [[SJAppdelegateService alloc] init];
    if (launchOptions != nil) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DID_HANDLE_REMOTE_NOTIFICATION];
        _appdelegateService.pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    }
    self.isLockDevice = NO;
    [self lanuchSDKs];
    return YES;
}
-(void)lanuchSDKs{
    [Bugly startWithAppId:BuglyId];
    
    [self configShareData];
    
    [self MSCSDK];
    
    [self UMSDK];
#ifdef BeiJing
    [self hwCDN];
#else
#endif
    [TalkingData sessionStarted:@"55419483DB294EB6BFB6892EB103DC93" withChannelId:@"APP Store"];

}
//友盟统计
-(void)UMSDK{
    [UMengManager start];
}
//华为SDN
-(void)hwCDN{
    [[HWOauthManager sharedInstance] Authentication];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    dispatch_sync(srvQueue, ^{
        [mgServer stop];
    });
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    //检测升级
    [[BIMSManager sharedInstance]apkUpdateRequest];
#ifdef BeiJing
    [[HWOauthManager sharedInstance] toUpdateAccessToken];
#else
#endif
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[[SJAppDelegateStore sharedInstance] application_]
    dispatch_async(srvQueue, ^{
        [mgServer start];
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    
    
    [[SJAppDelegateStore sharedInstance] application_AppDelegateStore:application
                     didRegisterForRemoteNotificationsWithDeviceToken:token];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    // 注册APNS失败
    // 自行处理
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    [[SJAppDelegateStore sharedInstance] application_AppDelegateStore:application
                                         didReceiveRemoteNotification:userInfo];
     
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
}

#pragma mark -
- (BOOL)firstLaunching
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"first_launching"]){
        //第一次安装发起友盟统计
        //第一次安装向BIMS注册手机信息
        [[BIMSManager sharedInstance]registeredMobileInformation];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_launching"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kResumeVideoSwitchKey];
        return YES;
    }
    else{
        [self BIMSOperation];
        return NO;
    }
}

//第三方分享注册
- (void)configShareData{
    [WXApi registerApp:kWeChatAppID withDescription:CurrentAppName];
    [WeiboSDK registerApp:kSinaAppID];
}
// BIMS平台接入
- (void)BIMSOperation
{
    NSString *ystenId = [NSUserDefaultsManager getObjectForKey:YSTENID];
    if (!ystenId) {
        //未注册成功安装向BIMS注册手机信息
        [[BIMSManager sharedInstance]registeredMobileInformation];
    }
    else{
        [[BIMSManager sharedInstance] boot];
    }
}

// 科大讯飞语音
- (void)MSCSDK
{
    [IFlySetting setLogFile:LVL_ALL];

    //输出在console的log开关
    [IFlySetting showLogcat:YES];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];

    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"54cf10e3",@"20000"];

    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];


    [IFlyFlowerCollector SetDebugMode:YES];
    [IFlyFlowerCollector SetCaptureUncaughtException:YES];
    [IFlyFlowerCollector SetAppid:@"54cf10e3"];
    [IFlyFlowerCollector SetAutoLocation:YES];
}


/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        [WXApi handleOpenURL:url delegate:self];
    }else{

        [WeiboSDK handleOpenURL:url delegate:self];

    }

    return  YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WeiboSDK handleOpenURL:url delegate:self];
    [WXApi handleOpenURL:url delegate:self];

    return YES;
}


-(void)onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]]){

        NSString* log_push_moment = [NSUserDefaultsManager getObjectForKey:LOG_PUSH_MOMENT];

        NSString* log_push_wechat = [NSUserDefaultsManager getObjectForKey:LOG_PUSH_WECHAT];

        NSString* str = [NSUserDefaultsManager getObjectForKey:LOG_SHARE_CONTENT];
        if (resp.errCode==0) {

            if (log_push_wechat) {
                [Utils BDLog:1 module:@"605" action:@"Push" content:[NSString stringWithFormat:log_push_wechat, 0] delay:5];
                [NSUserDefaultsManager saveObject:nil forKey:LOG_PUSH_WECHAT];
                [UMengManager event:@"U_Push"];
            }

            if (log_push_moment) {
                [Utils BDLog:1 module:@"605" action:@"Push" content:[NSString stringWithFormat:log_push_moment, 0]delay:5];
                [NSUserDefaultsManager saveObject:nil forKey:LOG_PUSH_MOMENT];
                [UMengManager event:@"U_Push"];
            }

            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str, 0]delay:5];
                [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                /*if (resp.type == WXSceneSession) {
                 [dic setValue:@"微信" forKey:@"share_way"];
                 }
                 else{
                 [dic setValue:@"朋友圈" forKey:@"share_way"];
                 }*/
                [dic setValue:[HiTVGlobals sharedInstance].shareWay forKey:@"share_way"];
                
                [dic setValue:[HiTVGlobals sharedInstance].shareType forKey:@"type"];
                
                [UMengManager event:@"U_Share" attributes:dic];
                [HiTVGlobals sharedInstance].shareType = nil;
                [HiTVGlobals sharedInstance].shareWay = nil;
            }

            UIView *subView=[UIApplication sharedApplication].keyWindow;
            [MBProgressHUD showSuccess:@"分享成功" toView:subView];
        }else{

            if (log_push_wechat) {
                [Utils BDLog:1 module:@"605" action:@"Push" content:[NSString stringWithFormat:log_push_wechat, -1] delay:5];
                [NSUserDefaultsManager saveObject:nil forKey:LOG_PUSH_WECHAT];
            }

            if (log_push_moment) {
                [Utils BDLog:1 module:@"605" action:@"Push" content:[NSString stringWithFormat:log_push_moment, -1]delay:5];
                [NSUserDefaultsManager saveObject:nil forKey:LOG_PUSH_MOMENT];
            }

            if (str != nil) {
                [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,-1]delay:5];
                [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
            }
            [MBProgressHUD showError:StringNotEmpty(resp.errStr)?resp.errStr:@"取消分享" toView:nil];
        }
    }
}


- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{

    NSString* str = [NSUserDefaultsManager getObjectForKey:LOG_SHARE_CONTENT];
    if ((int)response.statusCode==0) {
        if (str != nil) {
            [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,0]delay:5];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //[dic setValue:@"" forKey:@"type"];
        [dic setValue:@"微博" forKey:@"share_way"];
        [dic setValue:[HiTVGlobals sharedInstance].shareType forKey:@"type"];
        [UMengManager event:@"U_Share" attributes:dic];
        [HiTVGlobals sharedInstance].shareType = nil;
        [MBProgressHUD showSuccess:@"分享成功" toView:nil];
        
    }else{
        if (str != nil) {
            [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,-1]delay:5];
        }
                [MBProgressHUD showError:@"取消分享" toView:nil];
    }
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{

}

#pragma mark -  主页
- (void)showMainVC{
    [_appdelegateService showDefaultTemplate];
    [self.window makeKeyAndVisible];

}

#pragma mark - 设置日志

- (void)setCocoaLumberjackLog{
    [PTEDashboard.sharedDashboard hide];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 刷新频率为24小时
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7; // 保存一周的日志，即7天
    [DDLog addLogger:fileLogger];
    NSString *logPath = [fileLogger currentLogFileInfo].filePath;
    DDLogInfo(@"日志路径:%@",logPath);
    NSLog(@"日志路径:%@",logPath);
    
}

#pragma mark -  首页标签沙盒缓存管理
- (void)mainSandboxManager{

    NSString *sandboxVer = [NSUserDefaultsManager getObjectForKey:CFBundleVersion];
    NSString *currentVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

    if ([currentVer intValue]>[sandboxVer intValue]) {
        [NSUserDefaultsManager deleteObjectForKey:NAV_TOPS];
        [NSUserDefaultsManager deleteObjectForKey:NAV_BOTTONS];
        
        [NSUserDefaultsManager saveObject:currentVer forKey:CFBundleVersion];
    }
#ifdef JiangSu
    if ([sandboxVer intValue]<1098) {
        //清除用户信息
        [NSUserDefaultsManager deleteObjectForKey:ISLOGIN];
        [NSUserDefaultsManager deleteObjectForKey:P_UID];
        [NSUserDefaultsManager deleteObjectForKey:USERINFO];
    }
#else
#endif

}

@end
