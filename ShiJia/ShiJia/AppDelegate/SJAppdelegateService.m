//
//  SJAppdelegateService.m
//  ShiJia
//
//  Created by yy on 16/4/20.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "SJAppdelegateService.h"

#import "SJAppDelegateStore.h"
#import "BIMSManager.h"

#import "SJLoginViewController.h"
#import "WatchListViewController.h"
#import "SJMyViewController.h"
#import "VideoHomeViewController.h"
#import "ChannelViewController.h"
#import "VideoHomeViewController.h"
#import "SJGuideViewController.h"
#import "SJConnectTVViewController.h"

#import "SJMultiVideoDetailViewController.h"
#import "SJMessageCenterViewController.h"
#import "SJMessageDetailViewController.h"

#import "UIWindow+PazLabs.h"

#import "TPMessageCenterDataModel.h"
#import "TPIMMessageModel.h"
#import "TPIMContentModel.h"
#import "TPIMUser.h"
#import "TPIMGroup.h"
#import "TPXmppRoomManager.h"
#import "TPIMAlertView.h"
#import "TPMessageRequest.h"

#import "WatchListEntity.h"
#import "HiTVVideo.h"
#import "VideoSource.h"
#import "UserEntity.h"
#import "WatchFocusVideoEntity.h"
#import "WatchFocusVideoProgramEntity.h"
#import "TVProgram.h"
#import "TVStation.h"
#import "TogetherManager.h"
#import "SJRemoteControlViewController.h"
#import "OrderingViewController.h"
#import "SJShareAlertView.h"
#import "TPShortVideoPlayerView.h"
#import "HiTVConstants.h"
#import "UIImage+GIF.h"
#import "MainViewController.h"
#import "HomePageViewController.h"
#import "HotspotViewController.h"
#import "WatchListViewController.h"
#import "SplashViewModel.h"
#import "DmsDataPovider.h"
#import "SJResumeVideoViewModel.h"

//#import "MiPushSDK.h"
#import <UserNotifications/UserNotifications.h>

@interface SJAppdelegateService ()<SJAppDelegateStoreDelegate,UITabBarControllerDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic, strong) UINavigationController *tabNav;
@property (nonatomic, strong) UIButton               *remoteBtn;
@property (nonatomic, strong) UIButton               *remoteBtn_Fan;

@property (nonatomic, strong) UIImageView               *remoteLoadingImg;
@property (nonatomic, strong) CMSCoinView               *cmsView;
//@property (nonatomic, strong) SJResumeVideoViewModel    *resumeViewModel;

@end

@implementation SJAppdelegateService

#pragma mark - Lifecycle
- (void)dealloc
{
    
//    @weakify(self);
    [[SJAppDelegateStore sharedInstance] unbind:self];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
//        @weakify(self);
        [[SJAppDelegateStore sharedInstance]bind:self];
        
        //监听xmpp消息
        [self startXmppMessageObserving];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessagePermission) name:TPIMNotification_MessagePermissionChanged object:nil];
        [[HiTVGlobals sharedInstance] addObserver:self
                                       forKeyPath:NSStringFromSelector(@selector(isLogin))
                                          options:NSKeyValueObservingOptionNew
                                          context:nil];
        
        [self networkReachabilityReceive];
        //_resumeViewModel = [[SJResumeVideoViewModel alloc] init];
        /* 小米推送
        // 同时启用APNs跟应用内长连接
        [MiPushSDK registerMiPush:self type:0 connect:YES];
        
         */
        // 注册远程通知
        double delayInSeconds = 1.0 * 5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self enablePush];
        });
    }
    return self;
}

#pragma mark -  ONEAppdelegateStoreDelegate
- (void)applicationDidEnterBackground
{
    self.isInBackground = YES;
}

- (void)applicationWillEnterForeground
{
    self.isInBackground = NO;
}

- (void)applicationDidBecomeActive
{
    //clear badge
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self runPushAction];
    
}

//网络改变监听
- (void)networkReachabilityReceive
{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSDictionary *userInfo = @{ AFNetworkingReachabilityNotificationStatusItem: @(status) };

        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_NetReachability object:self userInfo:userInfo];
        [[TogetherManager sharedInstance]setRemoteStatus];
        
        
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            //[mgServer stop];
            
        } else {
            //[HiTVGlobals sharedInstance].uid = [NSUserDefaultsManager getObjectForKey:P_UID];
            if ([HiTVGlobals sharedInstance].isLogin&&![HiTVGlobals sharedInstance].xmppConnected) {
                [[BIMSManager sharedInstance] getJidRequest];
            }
        }
    }];
    [reachabilityManager startMonitoring];
}

- (BOOL)application_delegate:(UIApplication *)application
                     openURL:(NSURL *)url
           sourceApplication:(NSString *)sourceApplication
                  annotation:(id)annotation
{
    return YES;
}

- (void)application_delegate:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /*小米推送
    // 当同时启动APNs与内部长连接时, 把两处收到的消息合并. 通过miPushReceiveNotification返回
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
    
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    [MiPushSDK openAppNotify:messageId];
    */
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        self.pushInfo = userInfo;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DID_HANDLE_REMOTE_NOTIFICATION];
        [self runPushAction];
    }
     
}

- (void)application_delegate:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    /*小米推送
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:token];
    */
    
    __block NSString *deviceToken = [[token description] substringWithRange:NSMakeRange(1, 71)];
    if (deviceToken && deviceToken.length) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                DDLogInfo(@"deviceToken=%@", deviceToken);
                //TODO:submit token to server 5a6bc13a7213d0bef443111129c0431bd548a941c1b3771b0049d2ca7cfa85bf
                deviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                stringByReplacingOccurrencesOfString: @">" withString: @""]
                               stringByReplacingOccurrencesOfString: @" " withString: @""];
                [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:DEVICE_TOKEN];
                
                [TPMessageRequest uploadDeviceTokenWithCompletion:^(NSString *responseObject, NSError *error) {
                    if (error != nil) {
                        DDLogInfo(@"上传token失败");
                    }
                }];
                
            });
        });
    }
     
}

- (void)application_delegate:(UIApplication *)application
handleWatchKitExtensionRequest:(NSDictionary *)userInfo
                       reply:(void (^)(NSDictionary *))reply
{
    //complete in the future
}


#pragma mark - template
// 注册远程通知
- (void)enablePush
{
    /*
     // 同时启用APNs跟应用内长连接
     //[MiPushSDK registerMiPush:self type:0 connect:YES];
     */
    
    if (kIOS10_OR_LATER) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                DDLogInfo(@"注册成功");
            }else{
                //用户点击不允许
                DDLogError(@"注册失败");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            DDLogInfo(@"========%@",settings);
        }];
    }else if (kIOS8_OR_LATER){
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        //iOS 8.0系统以下
        //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)runPushAction
{
    //处理远程消息
    BOOL didHandleNotification = [[NSUserDefaults standardUserDefaults] boolForKey:DID_HANDLE_REMOTE_NOTIFICATION];

    if (self.pushInfo && !didHandleNotification) {
        
        //消息类型暂不处理 2017/5/10
        //[[TPXmppRoomManager defaultManager] handleRemoteNotification:self.pushInfo];
        //统计消息打开数量
        NSString *msgid = [self.pushInfo objectForKey:@"msgId"];
        [TPMessageRequest reportMessageArrivalCountWithMsgId:msgid handler:^(NSString *responseString, NSError *error) {
            
        }];
        self.pushInfo = nil;
        
        /* 小米推送
        NSString *messageId = [self.pushInfo objectForKey:@"_id_"];
        if (messageId!=nil) {
            [MiPushSDK openAppNotify:messageId];
        }
         */
    }
}

- (void)showDefaultTemplate
{
   
    if ([self firstLogin]) {
        
        SJLoginViewController *loginVC = [[SJLoginViewController alloc] init];
        loginVC.firstLaunch = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [AppDelegate appDelegate].window.rootViewController = nav;
    }
    else{
        [HiTVGlobals sharedInstance].isLogin = [NSUserDefaultsManager getObjectForKey:ISLOGIN];
        if ([HiTVGlobals sharedInstance].isLogin && !self.hasMainVC) {
            [self showMainViewController];
        }
        else{
            SJLoginViewController *loginVC = [[SJLoginViewController alloc] init];
            loginVC.firstLaunch = NO;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [AppDelegate appDelegate].window.rootViewController = nav;
        }
    }
}

#pragma mark- UIWindow切换rootViewController
- (void)switchMainWindowRootViewController:(UIViewController*)toViewController
{
    if (![AppDelegate appDelegate].window.rootViewController) {
        
        [AppDelegate appDelegate].window.rootViewController = toViewController;
        
    }else{
        //返回主界面
        [UIView transitionFromView:[AppDelegate appDelegate].window.rootViewController.view
                            toView:toViewController.view
                          duration:0.3f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        completion:^(BOOL finished) {
                            [AppDelegate appDelegate].window.rootViewController = toViewController;
                        }];
        [AppDelegate appDelegate].window.rootViewController = toViewController;
    }
}


- (void)showMainViewController{

    //[_resumeViewModel start];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorHex(333333), NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColorBlueTheme, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];

    MainViewController *mainVC = [[MainViewController alloc] init];
    //watchVC.title = @"节目单";
    mainVC.tabBarItem.image = [[UIImage imageNamed:@"tab1_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab1_high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    mainVC.tabBarItem.title = @"首页";



    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    WatchListViewController *watchVC = [[WatchListViewController alloc] init];
    //watchVC.title = @"节目单";
    watchVC.tabBarItem.image = [[UIImage imageNamed:@"tab2_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    watchVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab2_high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    watchVC.tabBarItem.title = @"看单";
    UINavigationController *watchNav = [[UINavigationController alloc] initWithRootViewController:watchVC];


    
    /*VideoHomeViewController *searchVC = [[VideoHomeViewController alloc] init];
    searchVC.title = @"影视";
    searchVC.tabBarItem.image = [UIImage imageNamed:@"点播"];
    searchVC.tabBarItem.selectedImage = [UIImage imageNamed:@"mdianbo"];
    searchVC.tabBarItem.title = @"影视";
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:searchVC];*/
    
    
    
    
    HotspotViewController *hotVC = [[HotspotViewController alloc] init];
    hotVC.tabBarItem.image = [[UIImage imageNamed:@"tab5_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hotVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab5_high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hotVC.tabBarItem.title = @"有料";
    UINavigationController *hotNav = [[UINavigationController alloc] initWithRootViewController:hotVC];
    
    ChannelViewController *liveVC = [[ChannelViewController alloc] init];
    liveVC.title = @"电视";
    liveVC.tabBarItem.image = [[UIImage imageNamed:@"tab3_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    liveVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab3_high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    liveVC.tabBarItem.title = @"电视";
    UINavigationController *liveNav = [[UINavigationController alloc] initWithRootViewController:liveVC];
    liveVC.hidesBottomBarWhenPushed = NO;
    
    OrderingViewController *orderingVC = [[OrderingViewController alloc] init];
    orderingVC.title = @"流量";
    orderingVC.tabBarItem.image = [UIImage imageNamed:@"流量图标(灰色)"];
    orderingVC.tabBarItem.title = @"流量";
    
    
   // UINavigationController *orderingNav = [[UINavigationController alloc] initWithRootViewController:orderingVC];
    
    SJMyViewController *myVC = [[SJMyViewController alloc] init];
    myVC.tabBarItem.image = [[UIImage imageNamed:@"tab4_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab4_high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem.title = @"我的";
    UINavigationController *myNav = [[UINavigationController alloc] initWithRootViewController:myVC];
    
    [[UITabBar appearance] setTintColor:RGB(0, 134, 207, 1)];
    
    //NSDictionary* textTitleOpt = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    //[[UINavigationBar appearance] setTitleTextAttributes:textTitleOpt];
    
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.delegate = self;
    _tabNav = [[UINavigationController alloc] initWithRootViewController:tabVC];
    _tabNav.navigationBarHidden = YES;
    tabVC.tabBar.barTintColor = [UIColor whiteColor];
#ifdef BeiJing
    tabVC.viewControllers = @[mainNav,watchNav,liveNav,myNav];
#else
    tabVC.viewControllers = @[mainNav,watchNav,hotNav,liveNav,myNav];
#endif

    [AppDelegate appDelegate].window.rootViewController = _tabNav;
    self.hasMainVC = YES;
    [self performSelectorInBackground:@selector(BackGroundLoadAD) withObject:nil];
}
-(void)BackGroundLoadAD{
    SplashViewModel *ViewModel = [[SplashViewModel alloc]init];
    [DmsDataPovider getBootAdRequestCompletion:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *string = [dict[@"resourceUrl"] md5String];
        NSString *cacheString = [[NSUserDefaults standardUserDefaults]objectForKey:kCacheMD5];
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:kCacheMD5];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kCacheObject];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (![string isEqualToString:cacheString]) {
            [ViewModel setSourceURL:dict[@"resourceUrl"]];
        }
    }failure:^(NSString *message) {

    }];
}
- (BOOL)firstLogin
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"first_login"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_login"];
        return YES;
    }
    else{
        return NO;
    }
}

//BIMS平台接入
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

- (void)loadRemoteLogo
{
    _coinView = [[UIView alloc]initWithFrame:CGRectMake(10, 25, 35, 35)];
    _coinView.backgroundColor = [UIColor clearColor];
    [_tabNav.view addSubview:_coinView];
    //[[AppDelegate appDelegate].window insertSubview:_coinView atIndex:1];
    _remoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _remoteBtn.backgroundColor = [UIColor clearColor];
    _remoteBtn.frame = CGRectMake(10, 25, 35, 35);
    [_remoteBtn setImage:[UIImage imageNamed:@"ykq_l"] forState:UIControlStateNormal];
    _remoteBtn.userInteractionEnabled = NO;
    
    
    _remoteBtn_Fan = [UIButton buttonWithType:UIButtonTypeCustom];
    _remoteBtn_Fan.backgroundColor = [UIColor clearColor];
    _remoteBtn_Fan.frame = CGRectMake(10, 25, 35, 35);
    [_remoteBtn_Fan setImage:[UIImage imageNamed:@"no_ykq_l"] forState:UIControlStateNormal];
    _remoteBtn_Fan.userInteractionEnabled = NO;
    
    _cmsView = [[CMSCoinView alloc]init];
    _cmsView.frame = CGRectMake(0, 0, 35, 35);
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteBtnClick:)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    
    [_coinView addGestureRecognizer:gesture];
    //_coinView.userInteractionEnabled = NO;
    
    [_cmsView setPrimaryView: _remoteBtn];
    [_cmsView setSecondaryView: _remoteBtn_Fan];
    [_cmsView setSpinTime:1.0];
    
    [self.coinView addSubview:_cmsView];

}

-(UIImageView *)remoteLoadingImg{
    if (!_remoteLoadingImg) {
        _remoteLoadingImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        _remoteLoadingImg.backgroundColor = [UIColor clearColor];
        NSString  *name = @"loading.gif";
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *img = [UIImage sd_animatedGIFWithData:imageData];
        
        _remoteLoadingImg.image = img;
        [self.coinView addSubview:_remoteLoadingImg];
    }
    return _remoteLoadingImg;
}
- (void)setIsConnect:(BOOL)isConnect

{
    //self.remoteLoadingImg.hidden = YES;
    self.cmsView.hidden = NO;

    _isConnect = isConnect;
    if (isConnect) {
        
        // add log begin
        
        NSString* content = [NSString stringWithFormat:@"starttime=%@&reldevice=%@",[Utils getCurrentTime], [TogetherManager sharedInstance].connectedDevice.deviceID];
        
        [Utils BDLog:1 module:@"605" action:@"AppControl" content:content];
        // add log end

        [self.remoteBtn setImage:[UIImage imageNamed:@"ykq_h"] forState:UIControlStateNormal];
        [self.remoteBtn_Fan setImage:[UIImage imageNamed:@"yes_ykq_l"] forState:UIControlStateNormal];
     //   _coinView.userInteractionEnabled = YES;
    }
    else{
        [self.remoteBtn setImage:[UIImage imageNamed:@"ykq_l"] forState:UIControlStateNormal];
        [self.remoteBtn_Fan setImage:[UIImage imageNamed:@"no_ykq_l"] forState:UIControlStateNormal];
       // _coinView.userInteractionEnabled = NO;
    }
}
//xmpp登录失败 遥控器显示loading状态
-(void)setRemoteLogoToLoading:(BOOL)isLoading{
   // self.remoteLoadingImg.hidden = YES;
    self.cmsView.hidden = NO;
}
- (void)remoteBtnClick:(UITapGestureRecognizer *)sender{
   /* NSData *data1 = UIImageJPEGRepresentation(sender.imageView.image, 1);
    NSData *data2 = UIImageJPEGRepresentation([ UIImage imageNamed : @"ykq_h" ], 1);
    if ([data1 isEqual:data2]) {
        SJRemoteControlViewController *remoteVC = [[SJRemoteControlViewController alloc] init];
        [_tabNav pushViewController:remoteVC animated:YES];
    }*/
   // if (self.isConnect) {
        SJRemoteControlViewController *remoteVC = [[SJRemoteControlViewController alloc] init];
        [_tabNav pushViewController:remoteVC animated:YES];
    //}
    [UMengManager event:@"U_AppControl"];

}

#pragma mark - XMPP
//开始监听xmpp消息
- (void)startXmppMessageObserving
{
    //监听分享影片消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveXmppMessage:) name:TPIMNotification_ReceiveMessage_Type6 object:nil];
    
    NSString *a = [NSUserDefaultsManager getObjectForKey:kProgramKuaiBaoPermissionKey];
    NSString *b = [NSUserDefaultsManager getObjectForKey:kProgramReminderPermissionKey];
    
    
    if ([a isEqualToString:@"1"]) {
        //监听手机快报消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveXmppMessage:) name:TPIMNotification_ReceiveMessage_Type8 object:nil];
    }
    else{
        //删除手机快报消息监听
        [self removeProgramKuaiBaoNotification];
    }
    
    if ([b isEqualToString:@"1"]) {
        //监听看单消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveXmppMessage:) name:TPIMNotification_ReceiveMessage_Type5 object:nil];
    }
    else{
        //删除看单消息监听
        [self removeProgramReminderNotification];
    }
    
    //监听赠片消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveXmppMessage:) name:TPIMNotification_ReceiveMessage_Type12 object:nil];
    
    //监听分享短视频消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShortVideoMessage:) name:TPIMNotification_ReceiveMessage_Type11 object:nil];
    
    //监听分享图片消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShortVideoMessage:) name:TPIMNotification_ReceiveMessage_Type26 object:nil];
    
    //监听被下线消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAccountAndXmpp:) name:TPXMPPOfflineNotification object:nil];
    
    //监听被下线后重新登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloginXmpp:) name:TPXMPPOnlineNotification object:nil];
    
    //监听有料短视频消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShortVideoMessage:) name:TPIMNotification_ReceiveMessage_Type28 object:nil];
}

- (void)receiveShortVideoMessage:(NSNotification *)notification
{

    TPIMMessageModel *msgmodel = [notification.userInfo valueForKey:TPIMNotification_MessageKey];
    // 更改消息状态
    [self modifyMessageStateWithMsgId:msgmodel.msgId];
    
    TPIMAlertView *alert = [[TPIMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName] message:msgmodel.title leftButtonTitle:@"一会再看" rightButtonTitle:@"去看看"];
    //alert.image = [HiTVConstants thumbnailFromVideoUrl:msgmodel.contentModel.url];
    if ([msgmodel.type isEqualToString:@"11"]||[msgmodel.type isEqualToString:@"28"]) {
       alert.imageUrl = msgmodel.contentModel.filesdpath;
    }
    else{
        alert.imageUrl = [NSString stringWithFormat:@"%@!/fw/40/fh/40",msgmodel.contentModel.path];
    }
    
    [alert setRightButtonClickBlock:^{
        
        [self pushToMessageDetailController:msgmodel];
        
    }];
    
    [alert show];
}

//收到xmpp消息
- (void)receiveXmppMessage:(NSNotification *)notification
{
    
    TPIMMessageModel *msgmodel = [notification.userInfo valueForKey:TPIMNotification_MessageKey];
    //[[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessages object:self userInfo:nil];
    
    // 更改消息状态
    [self modifyMessageStateWithMsgId:msgmodel.msgId];
    
    if (msgmodel.title.length == 0) {
        msgmodel.title = msgmodel.contentModel.content;
    }
    
    TPIMAlertView *alert = [[TPIMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName] message:msgmodel.title leftButtonTitle:@"稍后再看" rightButtonTitle:@"立即观看"];
    
    
    [alert setRightButtonClickBlock:^{
        
        
        
        switch ([msgmodel.type integerValue]) {
            case 5:
            {
                // 节目提醒
                  [self pushToLiveTVDetail:msgmodel.contentModel];

            }
                break;
            case 8:
            {
                // 手机快报
                [self showMainViewController];
        
            }
                break;
            case 6:
            case 12:
            {
                // 观看好友分享/赠送的影片
                [self pushToVideoDetailController:msgmodel.contentModel];
                
            }
                break;
            case 11:
            {
                // 观看好友分享的短视频
                
                
            }
                break;
                
            default:
                break;
        }
        
        
        
    }];
    
    [alert show];
    
    
}
/*
 * 收到被下线通知
 * 退出登录后清除用户缓存信息
 * 若修改在MyDetailViewController.m的sureloginOut方法中也要修改
 */
- (void)logoutAccountAndXmpp:(NSNotification *)notification
{
    [HiTVGlobals sharedInstance].isLogin = NO;
    [HiTVGlobals sharedInstance].uid = [HiTVGlobals sharedInstance].anonymousUid;
    [HiTVGlobals sharedInstance].nickName = @"游客";
    [HiTVGlobals sharedInstance].phoneNo = @"";
    [HiTVGlobals sharedInstance].faceImg = @"";
    [[BIMSManager sharedInstance].verTimer invalidate];
    [BIMSManager sharedInstance].verTimer = nil;
    
    [AppDelegate appDelegate].appdelegateService.isConnect = NO;
    [TogetherManager sharedInstance].connectedDevice = nil;
    [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
    }];

    //xmpp断开连接
    [TPIMUser logoutWithCompletionHandler:^(id responseObject, NSError *error) {

    }];
    [HiTVGlobals sharedInstance].VIP = NO;
    [HiTVGlobals sharedInstance].expireDate = nil;
    
    [NSUserDefaultsManager deleteObjectForKey:ISLOGIN];
    [NSUserDefaultsManager deleteObjectForKey:P_UID];
    [NSUserDefaultsManager deleteObjectForKey:USERINFO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadUser" object:@"loginOut"];
    [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_Remote object:@"ykq_l"];

    UIViewController *vc = [AppDelegate appDelegate].window.visibleViewController;
    if (![vc isKindOfClass:[SJMultiVideoDetailViewController class]]) {
        [vc.navigationController popToRootViewControllerAnimated:YES];
    }
    
    SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
    [vc.navigationController presentViewController:sjVC animated:YES completion:^{
        [vc.navigationController popViewControllerAnimated:NO];
    }];
}

//收到被下线后重新登录通知
- (void)reloginXmpp:(NSNotification *)notification
{
    NSString *jid = [HiTVGlobals sharedInstance].xmppUserId;
    
    //登录xmpp
    [TPIMUser loginWithUsername:jid password:[HiTVGlobals sharedInstance].xmppCode complecationHandler:^(id responseObject, NSError *error) {
        
    }];
}

- (void)removeProgramKuaiBaoNotification
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:TPIMNotification_ReceiveMessage_Type8 object:nil];
}

- (void)removeProgramReminderNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TPIMNotification_ReceiveMessage_Type5 object:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isLogin))]) {
        if ([HiTVGlobals sharedInstance].isLogin) {
            
            //推送消息暂不处理
            //[self runPushAction];
            
        }
    }
}

- (void)changeMessagePermission
{
    NSString *a = [NSUserDefaultsManager getObjectForKey:kProgramKuaiBaoPermissionKey];
    NSString *b = [NSUserDefaultsManager getObjectForKey:kProgramReminderPermissionKey];
    
    //删除手机快报消息监听
    [self removeProgramKuaiBaoNotification];
    if ([a isEqualToString:@"1"]) {
        //监听手机快报消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveXmppMessage:) name:TPIMNotification_ReceiveMessage_Type8 object:nil];
    }
    
    
    //删除看单消息监听
    [self removeProgramReminderNotification];
    if ([b isEqualToString:@"1"]) {
        //监听看单消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveXmppMessage:) name:TPIMNotification_ReceiveMessage_Type5 object:nil];
    }    
    
}

//#pragma mark - MiPushSDKDelegate
//- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
//{
//    // 请求成功
//    // 可在此获取regId
//    if ([selector isEqualToString:@"bindDeviceToken:"]) {
//        DDLogInfo(@"regid = %@", data[@"regid"]);
//    }
//}
//
//- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
//{
//    // 请求失败
//}

#pragma mark - UNUserNotificationCenterDelegate
// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [MiPushSDK handleReceiveRemoteNotification:userInfo];
//    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        self.pushInfo = userInfo;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DID_HANDLE_REMOTE_NOTIFICATION];
        [self runPushAction];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

// 点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [MiPushSDK handleReceiveRemoteNotification:userInfo];
//        NSString *messageId = [userInfo objectForKey:@"_id_"];
//        [MiPushSDK openAppNotify:messageId];
//    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        self.pushInfo = userInfo;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DID_HANDLE_REMOTE_NOTIFICATION];
        [self runPushAction];
    }
    completionHandler();
}

#pragma mark - 页面跳转
- (void)pushToVideoDetailController:(TPIMContentModel *)contentModel
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *activecontroller = [delegate.window visibleViewController];
    if ([activecontroller isKindOfClass:[SJMultiVideoDetailViewController class]]) {
        
        // 当前活动controller为详情页
        SJMultiVideoDetailViewController *videoDetailVC = (SJMultiVideoDetailViewController *)activecontroller;
        if ([contentModel.videoType isEqualToString:@"vod"]||[contentModel.videoType isEqualToString:@"watchtv"]) {
            
            // 点播
            videoDetailVC.videoType = SJVideoTypeVOD;
            videoDetailVC.videoID = contentModel.programSeriesId;
            videoDetailVC.programId = contentModel.programId;
            
        }
        else if ([contentModel.videoType isEqualToString:@"watchtv"]){
            
            // 看点
            videoDetailVC.videoType = SJVideoTypeWatchTV;
            videoDetailVC.categoryID = contentModel.programSeriesId;
            videoDetailVC.videoID = contentModel.catgId;
            videoDetailVC.programId = contentModel.programId;
            
            WatchListEntity *entity = [[WatchListEntity alloc]init];
            entity.programSeriesId = contentModel.programSeriesId;
            entity.contentId = contentModel.programId;
            videoDetailVC.watchEntity = entity;
            
        }
        else if ([contentModel.videoType isEqualToString:@"live"] ){
            
            // 直播
            videoDetailVC.videoType = SJVideoTypeLive;
            
            TVProgram *program = [[TVProgram alloc] init];
            program.programId = [contentModel.programId doubleValue];
            program.programUrl = contentModel.url;
            program.programName = contentModel.programName;
            program.uuid = contentModel.channelUuid;
            program.startTime = contentModel.startTime;
            program.endTime = contentModel.endTime;
            
            TVStation *station = [[TVStation alloc] init];
            station.uuid = contentModel.channelUuid;
            station.channelName = contentModel.channelName;
            station.logo = contentModel.channelLogo;
            
            videoDetailVC.tvProgram = program;
            videoDetailVC.tvStation = station;
            
        }
        else{
            
            // 直播
            videoDetailVC.videoType = SJVideoTypeReplay;
            
            TVProgram *program = [[TVProgram alloc] init];
            program.programId = [contentModel.programId doubleValue];
            program.programUrl = contentModel.url;
            program.programName = contentModel.programName;
            program.uuid = contentModel.channelUuid;
            program.startTime = contentModel.startTime;
            program.endTime = contentModel.endTime;
            
            TVStation *station = [[TVStation alloc] init];
            station.uuid = contentModel.channelUuid;
            station.channelName = contentModel.channelName;
            station.logo = contentModel.channelLogo;
            
            videoDetailVC.tvProgram = program;
            videoDetailVC.tvStation = station;
            
        }
        
        [videoDetailVC setupChildController];
        
    }
    else{
        UIViewController *viewcontroller;
        
        if ([contentModel.videoType isEqualToString:@"vod"]||[contentModel.videoType isEqualToString:@"watchtv"]) {
            
            // 点播
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
            detailVC.videoID = contentModel.programSeriesId;
            detailVC.programId = contentModel.programId;
            viewcontroller = detailVC;
            
        }
        else if ([contentModel.videoType isEqualToString:@"watchtv"]){
            
            // 看点
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeWatchTV];
            detailVC.categoryID = contentModel.programSeriesId;
            detailVC.videoID = contentModel.catgId;
            detailVC.programId = contentModel.programId;
            
            WatchListEntity *entity = [[WatchListEntity alloc]init];
            entity.programSeriesId = contentModel.programSeriesId;
            entity.contentId = contentModel.programId;
            detailVC.watchEntity = entity;
            
            viewcontroller = detailVC;
            
        }
        else if ([contentModel.videoType isEqualToString:@"live"]){
            
            // 直播
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeLive];
            
            TVProgram *program = [[TVProgram alloc] init];
            program.programId = [contentModel.programId doubleValue];
            program.programUrl = contentModel.url;
            program.programName = contentModel.programName;
            program.uuid = contentModel.channelUuid;
            program.startTime = contentModel.startTime;
            program.endTime = contentModel.endTime;
        
            TVStation *station = [[TVStation alloc] init];
            station.uuid = contentModel.channelUuid;
            station.channelName = contentModel.channelName;
            station.logo = contentModel.channelLogo;
            
            detailVC.tvProgram = program;
            detailVC.tvStation = station;
            
            viewcontroller = detailVC;
        }
        else{
            // 回看
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeReplay];
            
            TVProgram *program = [[TVProgram alloc] init];
            program.programId = [contentModel.programId doubleValue];
            program.programUrl = contentModel.url;
            program.programName = contentModel.programName;
            program.uuid = contentModel.channelUuid;
            program.startTime = contentModel.startTime;
            program.endTime = contentModel.endTime;
            
            TVStation *station = [[TVStation alloc] init];
            station.uuid = contentModel.channelUuid;
            station.channelName = contentModel.channelName;
            station.logo = contentModel.channelLogo;
            
            detailVC.tvProgram = program;
            detailVC.tvStation = station;
            
            viewcontroller = detailVC;
        }
        
        if ([activecontroller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)activecontroller;
            [nav pushViewController:viewcontroller animated:YES];
        }
        else{
            activecontroller.hidesBottomBarWhenPushed = YES;
            if (activecontroller.navigationController != nil) {
                
                [activecontroller.navigationController pushViewController:viewcontroller animated:YES];
            }
            else{
                [activecontroller presentViewController:viewcontroller animated:YES completion:nil];
            }
            
//            if ([activecontroller isKindOfClass:[SJMultiVideoDetailViewController class]]) {
//                
//                activecontroller.hidesBottomBarWhenPushed = NO;
//            }MainViewController
            
            if ([activecontroller isKindOfClass:[WatchListViewController class]] ||
                [activecontroller isKindOfClass:[VideoHomeViewController class]] ||
                [activecontroller isKindOfClass:[ChannelViewController class]] ||
                [activecontroller isKindOfClass:[SJMyViewController class]]||
                [activecontroller isKindOfClass:[HotspotViewController class]]||[activecontroller isKindOfClass:[MainViewController class]]) {
                
                activecontroller.hidesBottomBarWhenPushed = NO;
                
            }
            else{
                activecontroller.hidesBottomBarWhenPushed = YES;
            }
        }
    }
}

- (void)pushToLiveTVDetail:(TPIMContentModel *)contentModel
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *activecontroller = [delegate.window visibleViewController];
    if ([activecontroller isKindOfClass:[SJMultiVideoDetailViewController class]]) {
        
        // 当前活动controller为详情页
        SJMultiVideoDetailViewController *videoDetailVC = (SJMultiVideoDetailViewController *)activecontroller;
        
        // 直播
        videoDetailVC.videoType = SJVideoTypeWatchTV;
        WatchListEntity *entity = [[WatchListEntity alloc] init];
        entity.channelUuid = contentModel.uuId;
        entity.contentId = contentModel.catgId;
        entity.posterAddr = contentModel.pImg;
        entity.startTime = [contentModel.startTime floatValue];
        entity.endTime = [contentModel.endTime floatValue];
        videoDetailVC.watchEntity = entity;
        videoDetailVC.categoryID = contentModel.catgId;
        
//        videoDetailVC.videoType = SJVideoTypeLive;
//        TVProgram *program = [[TVProgram alloc] init];
//        program.programId = [contentModel.catgId doubleValue];
////        program.programId = [contentModel.programId doubleValue];
////        program.programUrl = contentModel.url;
////        program.programName = contentModel.programName;
//        program.uuid = contentModel.uuId;
////        program.startTime = contentModel.startTime;
////        program.endTime = contentModel.endTime;
//        
//        TVStation *station = [[TVStation alloc] init];
//        station.uuid = contentModel.uuId;
//        station.channelName = contentModel.uuId;
//        //station.logo = contentModel.channelLogo;
//        
//        videoDetailVC.tvProgram = program;
//        videoDetailVC.tvStation = station;
        
        [videoDetailVC setupChildController];
        
    }
    else{
        UIViewController *viewcontroller;
        
        
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeWatchTV];
        WatchListEntity *entity = [[WatchListEntity alloc] init];
        entity.channelUuid = contentModel.uuId;
        entity.contentId = contentModel.catgId;
        entity.posterAddr = contentModel.pImg;
        entity.startTime = [contentModel.startTime floatValue];
        entity.endTime = [contentModel.endTime floatValue];
        detailVC.watchEntity = entity;
        detailVC.categoryID = contentModel.catgId;
        
//        TVProgram *program = [[TVProgram alloc] init];
//        program.programId = [contentModel.catgId doubleValue];
////        program.programUrl = contentModel.url;
////        program.programName = contentModel.programName;
//        program.uuid = contentModel.uuId;
////        program.startTime = contentModel.startTime;
////        program.endTime = contentModel.endTime;
//        
//        TVStation *station = [[TVStation alloc] init];
//        station.uuid = contentModel.uuId;
//        station.channelName = contentModel.uuId;
//        //station.logo = contentModel.channelLogo;
//        
//        detailVC.tvProgram = program;
//        detailVC.tvStation = station;
        
        viewcontroller = detailVC;
        
        if ([activecontroller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)activecontroller;
            [nav pushViewController:viewcontroller animated:YES];
        }
        else{
            activecontroller.hidesBottomBarWhenPushed = YES;
            if (activecontroller.navigationController != nil) {
                
                [activecontroller.navigationController pushViewController:viewcontroller animated:YES];
            }
            else{
                [activecontroller presentViewController:viewcontroller animated:YES completion:nil];
            }
            
            if ([activecontroller isKindOfClass:[WatchListViewController class]] ||
                [activecontroller isKindOfClass:[VideoHomeViewController class]] ||
                [activecontroller isKindOfClass:[ChannelViewController class]] ||
                [activecontroller isKindOfClass:[SJMyViewController class]]||[activecontroller isKindOfClass:[HotspotViewController class]]||[activecontroller isKindOfClass:[MainViewController class]]) {
                activecontroller.hidesBottomBarWhenPushed = NO;
                
            }
            else{
                activecontroller.hidesBottomBarWhenPushed = YES;
            }
        }
    }
}

- (void)pushToMessageDetailController:(TPIMMessageModel *)msgModel
{
    
    TPMessageCenterDataModel *centerMsgModel = [[TPMessageCenterDataModel alloc] init];
    centerMsgModel.type = msgModel.type;
    centerMsgModel.title = msgModel.title;
    centerMsgModel.from = msgModel.from;
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *activecontroller = [delegate.window visibleViewController];
    if ([activecontroller isKindOfClass:[SJMessageDetailViewController class]]) {
        
        SJMessageDetailViewController *controller = (SJMessageDetailViewController *)activecontroller;
        
        [controller refreshDataWithMsgId:msgModel.msgId messageModel:centerMsgModel];
        
    }
    else{
        
        UIViewController *viewcontroller;
        
        SJMessageDetailViewController *controller = [[SJMessageDetailViewController alloc] init];
        controller.msgId = msgModel.msgId;
        controller.msgModel = centerMsgModel;
        viewcontroller = controller;
        
        
        if ([activecontroller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)activecontroller;
            [nav pushViewController:viewcontroller animated:YES];
        }
        else{
            activecontroller.hidesBottomBarWhenPushed = YES;
            if (activecontroller.navigationController != nil) {
                
                [activecontroller.navigationController pushViewController:viewcontroller animated:YES];
            }
            else{
                [activecontroller presentViewController:viewcontroller animated:YES completion:nil];
            }
            
            if ([activecontroller isKindOfClass:[WatchListViewController class]] ||
                [activecontroller isKindOfClass:[VideoHomeViewController class]] ||
                [activecontroller isKindOfClass:[ChannelViewController class]] ||
                [activecontroller isKindOfClass:[SJMyViewController class]]||[activecontroller isKindOfClass:[HotspotViewController class]]||[activecontroller isKindOfClass:[MainViewController class]]) {
                activecontroller.hidesBottomBarWhenPushed = NO;
                
            }
            else{
                activecontroller.hidesBottomBarWhenPushed = YES;
            }
        }
    }
}

#pragma mark - Request
- (void)modifyMessageStateWithMsgId:(NSString *)msgid
{
    if (msgid.length == 0) {
        return;
    }
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:msgid forKey:@"msgId"];
    [parameters setValue:@"1" forKey:@"readed"];
    
    //获取消息列表
    [BaseAFHTTPManager postRequestOperationForHost:MSGCENTERHOST forParam:@"/message/modifyReadState" forParameters:parameters completion:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReceiveMessages object:self userInfo:nil];
        
    } failure:^(NSString *error) {
        
    }];
    
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UINavigationController *vc = (UINavigationController *)viewController;
    if ([vc.viewControllers.firstObject isKindOfClass:[MainViewController class]]) {
        [UMengManager event:@"U_HomePage"];
    }
    else if ([vc.viewControllers.firstObject isKindOfClass:[WatchListViewController class]]) {
        [UMengManager event:@"U_ProgramListClick"];
    }
    else if ([vc.viewControllers.firstObject isKindOfClass:[HotspotViewController class]]) {
        [UMengManager event:@"U_YouLiao"];
    }
    else if ([vc.viewControllers.firstObject isKindOfClass:[ChannelViewController class]]) {
        [UMengManager event:@"U_Live"];
    }
    else if ([vc.viewControllers.firstObject isKindOfClass:[SJMyViewController class]]) {
        [UMengManager event:@"U_PerCenter"];
    }
}
@end
