//
//  BIMSManager.m
//  HiTV
//
//  Created by 蒋海量 on 15/2/28.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "BIMSManager.h"

#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <AddressBook/AddressBook.h>
#import "AddressBook.h"

#import "AFHTTPRequestOperationManager.h"

#import "CHKeychain.h"

#import "BaseAFHTTPManager.h"
#import "NSUserDefaultsManager.h"
#import "TogetherManager.h"
#import "DefNSUserDefaults.h"
#import "HiTVGlobals.h"
#import "TPIMUser.h"

#define UUIDKEY    @"IMEI"

static NSString* const PublicHost = BOOTHOST;


@interface BIMSManager ()
{
    BOOL isForce;
    NSString *packageLocationUrl;
    NSString *upgradeContent;
}
@end


@implementation BIMSManager

+ (instancetype)sharedInstance{
    static BIMSManager *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}
- (NSString*)p_getURLWithParameters:(NSString*)param forHost:(NSString*)host{
    return [[NSString stringWithFormat:@"%@%@", host, param] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
/**
 *  向BIMS注册手机信息
 */
-(void)registeredMobileInformation
{
    //IMEI,IMSI
    NSString *imei = [self imei];
    [[NSUserDefaults standardUserDefaults] setObject:imei forKey:IMEI];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //手机型号
    NSString* model = [[UIDevice currentDevice] model];
    
    //生产商
    NSString* manufacturer = @"Apple";
    
    //board
    NSString* board = [[UIDevice currentDevice] model];
    
    //品牌
    NSString* brand = @"Apple";
    
    //device
    NSString* device = @"ios";
    
    //fingerprint
    NSString* fingerprint = @"";
    
    //hardware
    NSString* hardware = @"";
    
    //id
    NSString* Id = @"";
    
    //手机版本号
    NSString* release = [[UIDevice currentDevice] systemVersion];
   
    //广电号
    NSString* code = @"000000000000000";
    
    //MAC地址
    NSString* mac = [self getMacAddress];
    
    //手机号码
   // NSString* phoneNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"SBFormattedPhoneNumber"];
   
    //当前版本号
    NSString* version = APPVersion;
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:imei forKey:@"imei"];
    [parameters setValue:imei forKey:@"imsi"];
    [parameters setValue:model forKey:@"model"];
    [parameters setValue:manufacturer forKey:@"manufacturer"];
    [parameters setValue:board forKey:@"board"];
    [parameters setValue:brand forKey:@"brand"];
    [parameters setValue:device forKey:@"device"];
    [parameters setValue:fingerprint forKey:@"fingerprint"];
    [parameters setValue:hardware forKey:@"hardware"];
    [parameters setValue:Id forKey:@"id"];
    [parameters setValue:release forKey:@"release"];
    [parameters setValue:code forKey:@"code"];
    [parameters setValue:mac forKey:@"mac"];
    [parameters setValue:@"" forKey:@"phoneNum"];
    [parameters setValue:version forKey:@"version"];

    NSString *bimsHost = PublicHost;
    /*if ([CHANNELID isEqualToString:X2GWTP]) {
        bimsHost = PublicHost;
    }*/
    NSString *url = [self p_getURLWithParameters:@"/yst-bims-mobile-api/mobile/register.json" forHost:bimsHost];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:[parameters objectForKey:@"authkey"] forHTTPHeaderField:@"authkey"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"111"]||[code isEqualToString:@"112"]) {
            [NSUserDefaultsManager saveObject:[responseDic objectForKey:@"ystenId"] forKey:YSTENID];
        }
        [self boot];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showRegisterErrorView];
    }];
    
}

/**
 *  手机开机引导
 */
-(void)boot
{
    //NSDictionary *bimsResultDic = [NSUserDefaultsManager getObjectForKey:BIMSRESULT];
    //[self setGlobalVariableDic:bimsResultDic];

    //IMEI,IMSI
    NSString *imei = [self imei];
  //  [NSUserDefaultsManager saveObject:imei forKey:IMEI];
    [HiTVGlobals sharedInstance].imei = imei;
    NSString *deviceCode = @"000000000000000";
    NSString *ystenId = [NSUserDefaultsManager getObjectForKey:YSTENID];
    if (!ystenId) {
        ystenId = @"00000000000000000000000000000000";
    }
    NSString *mac = [self getMacAddress];
    NSString *phoneNumber = @"";
    NSString *version = APPVersion;

    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:imei forKey:@"imei"];
    [parameters setValue:imei forKey:@"imsi"];
    [parameters setValue:deviceCode forKey:@"deviceCode"];
    [parameters setValue:ystenId forKey:@"ystenId"];
    [parameters setValue:mac forKey:@"mac"];
    [parameters setValue:phoneNumber forKey:@"phoneNumber"];
    [parameters setValue:version forKey:@"version"];
    [parameters setValue:@"" forKey:@"appType"];

    NSString *channelId = CHANNELID;

    [parameters setValue:channelId forKey:@"channelId"];
    //是否正式环境
    if ([channelId isEqualToString:@"taipanTest"]) {
        [HiTVGlobals sharedInstance].formal = NO;
    }
    else{
        [HiTVGlobals sharedInstance].formal = YES;
    }
    NSString *bimsHost = PublicHost;
//    if ([CHANNELID isEqualToString:X2GWTP]) {
//        bimsHost = PublicHost;
//    }
    [BaseAFHTTPManager postJsonRequestOperationForHost:bimsHost forParam:@"/yst-bims-mobile-api/mobile/boot.json" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"resultcode"];
        if ([code isEqualToString:@"111"]) {
            //成功
            NSArray *bimsArray = [responseDic objectForKey:@"sysconfig"];
            NSMutableDictionary *sysconfigDic = [NSMutableDictionary dictionary];
            for (int i = 0; i<bimsArray.count; i++) {
                NSDictionary *dic = [bimsArray objectAtIndex:i];
                [sysconfigDic setObject:[dic objectForKey:@"text"] forKey:[dic objectForKey:@"key"]];
            }
            
            [NSUserDefaultsManager saveObject:[responseDic objectForKey:@"screenId"] forKey:SCREENID];
            [NSUserDefaultsManager saveObject:[responseDic objectForKey:@"ystenId"] forKey:YSTENID];
            
            [self setGlobalVariableDic:sysconfigDic];

            [NSUserDefaultsManager saveObject:sysconfigDic forKey:BIMSRESULT];
        }
        else{
            [self setGlobalVariableDic:nil];
        }

    }failure:^(NSString *error) {
        
         NSDictionary *bimsResultDic = [NSUserDefaultsManager getObjectForKey:BIMSRESULT];
        [self setGlobalVariableDic:bimsResultDic];
    }];
}
-(void)setGlobalVariableDic:(NSDictionary *)sysconfigDic{
    if (!sysconfigDic) {
        [self showBootErrorView];
        return;
    }
    [HiTVGlobals sharedInstance].epg_30 = [sysconfigDic objectForKey:@"BIMS_EPGVIPER"];
    [HiTVGlobals sharedInstance].epg_groupId = [sysconfigDic objectForKey:@"BIMS_MOBILE_EPG_GROUPID"];
    [HiTVGlobals sharedInstance].liveepg = [sysconfigDic objectForKey:@"BIMS_LIVE_EPG"];
    [HiTVGlobals sharedInstance].liveepg_groupId = [sysconfigDic objectForKey:@"BIMS_MOBILE_LIVE_LOOK_GROUPID"];
    [HiTVGlobals sharedInstance].uic = [sysconfigDic objectForKey:@"BIMS_SEEN"];
    [HiTVGlobals sharedInstance].projection_low_domain = [sysconfigDic objectForKey:@"BIMS_MOBILE_PROJECTION_LOW_DOMAIN"];
    [HiTVGlobals sharedInstance].projection_domain = [sysconfigDic objectForKey:@"BIMS_MOBILE_PROJECTION_DOMAIN"];
    [HiTVGlobals sharedInstance].projection_live_domain = [sysconfigDic objectForKey:@"BIMS_MOBILE_PROJECTION_LIVE_DOMAIN"];
    [HiTVGlobals sharedInstance].recommend = [sysconfigDic objectForKey:@"BIMS_MOBILE_RECOMMEND"];
    [HiTVGlobals sharedInstance].loading = [sysconfigDic objectForKey:@"BIMS_MOBILE_LOADING"];
    [HiTVGlobals sharedInstance].bims_search = [sysconfigDic objectForKey:@"BIMS_SEARCH"];
    [HiTVGlobals sharedInstance].bims_mylook = [sysconfigDic objectForKey:@"BIMS_MYLOOK"];
    [HiTVGlobals sharedInstance].live_epg = [sysconfigDic objectForKey:@"BIMS_LIVE_EPG"];
    [HiTVGlobals sharedInstance].live_templateId = [sysconfigDic objectForKey:@"BIMS_LIVE_TEMPLATEID"];
    [HiTVGlobals sharedInstance].bims_multiscreen = [sysconfigDic objectForKey:@"BIMS_MULTISCREEN"];
    [HiTVGlobals sharedInstance].bims_msg = [sysconfigDic objectForKey:@"BIMS_MOBILE_MSG"];
    [HiTVGlobals sharedInstance].bims_mylookcenter = [sysconfigDic objectForKey:@"BIMS_MOBILE_MYLOOKCENTER"];
    [HiTVGlobals sharedInstance].bims_mylook = [sysconfigDic objectForKey:@"BIMS_MYLOOK_NEW"];
    [HiTVGlobals sharedInstance].xmpp_host = [sysconfigDic objectForKey:@"BIMS_XMPP_REGION"];
    [HiTVGlobals sharedInstance].social_host = [sysconfigDic objectForKey:@"BIMS_SOCIAL_ADDR"];
    [HiTVGlobals sharedInstance].cloud_server = [sysconfigDic objectForKey:@"BIMS_CLOUD_SERVICE"];
    [HiTVGlobals sharedInstance].share_server = [sysconfigDic objectForKey:@"BIMS_VIDEO_SHARE_SERVICE"];
    [HiTVGlobals sharedInstance].STBext = [sysconfigDic objectForKey:@"STBext"];
    [HiTVGlobals sharedInstance].open_flag = [sysconfigDic objectForKey:@"BIMS_LIVE_OPEN_FLAG"];
    [HiTVGlobals sharedInstance].library_url = [sysconfigDic objectForKey:@"BIMS_FILTER_LIBRARY_URL"];
    [HiTVGlobals sharedInstance].dingxiangIP = [sysconfigDic objectForKey:@"BIMS_IP_DINGXIANG"];
    [HiTVGlobals sharedInstance].domain = [sysconfigDic objectForKey:@"BIMS_DOMAIN"];
    [HiTVGlobals sharedInstance].clouduploadUrl = [sysconfigDic objectForKey:@"BIMS_CLOUD_ALBUMS_UPLOAD_URL"];
    [HiTVGlobals sharedInstance].cloudalbumsUrl = [sysconfigDic objectForKey:@"BIMS_CLOUD_ALBUMS"];
    [HiTVGlobals sharedInstance].ystenapyUrl = [sysconfigDic objectForKey:@"BIMS_YSTEN_PAY"];
    [HiTVGlobals sharedInstance].thumbSuffix = [sysconfigDic objectForKey:@"BIMS_THUMB_SUFFIX"];
    [HiTVGlobals sharedInstance].facadeUrl = [sysconfigDic objectForKey:@"BIMS_FACADE"];
    [HiTVGlobals sharedInstance].disable_moudles = [sysconfigDic objectForKey:@"BIMS_DISABLE_MOUDLE"];
    [HiTVGlobals sharedInstance].offline_COLUMN = [sysconfigDic objectForKey:@"BIMS_OFFLINE_COLUMN"];
    [HiTVGlobals sharedInstance].offline_CHANNEL = [sysconfigDic objectForKey:@"BIMS_OFFLINE_CHANNEL"];
    [HiTVGlobals sharedInstance].shareServiceHost = [sysconfigDic objectForKey:@"BIMS_HOT_VIDEO_SHARE_SERVICE"];

    [HiTVGlobals sharedInstance].loggerAddr = [sysconfigDic objectForKey:@"BIMS_BIGDATA_LOGGER"];
    [HiTVGlobals sharedInstance].cos_epg = [sysconfigDic objectForKey:@"BIMS_EPGVIPER"];
    
    [HiTVGlobals sharedInstance].apkUpdateHost = [sysconfigDic objectForKey:@"BIMS_APK_UPDATE"];
    [HiTVGlobals sharedInstance].softCode = [sysconfigDic objectForKey:@"BIMS_UPDATE_SOFT_CODE_IOS"];
    [HiTVGlobals sharedInstance].delaySecond = [[sysconfigDic objectForKey:@"BIMS_LIVE_DELAY_SECOND"] intValue];
    [HiTVGlobals sharedInstance].phoneApk = [sysconfigDic objectForKey:@"BIMS_PHONEAPK"];
    [HiTVGlobals sharedInstance].bssUserHost = [sysconfigDic objectForKey:@"BIMS_BSS_USER_URL"];
    [HiTVGlobals sharedInstance].shareUrl = [sysconfigDic objectForKey:@"BIMS_SHARE_UPLOAD_URL"];
    [HiTVGlobals sharedInstance].dmsHost = [sysconfigDic objectForKey:@"BIMS_MOBILE_DMS"];
    [HiTVGlobals sharedInstance].productHost = [sysconfigDic objectForKey:@"BIMS_HOT_VIDEO_PRODUCT"];
    [HiTVGlobals sharedInstance].shareServiceHost = [sysconfigDic objectForKey:@"BIMS_HOT_VIDEO_SHARE_SERVICE"];
    [HiTVGlobals sharedInstance].interested = [sysconfigDic objectForKey:@"BIMS_DEFAULT_INTERESTED_TAG"];

    [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_LaunchAD object:nil];

    //保存又拍云地址
    [NSUserDefaultsManager saveObject:[HiTVGlobals sharedInstance].cloud_server forKey:CLOUDSERVER];
    
    //匿名用户登录
    [[BIMSManager sharedInstance]anonymousUserLogin_Mobile];
    
    [self apkUpdateRequest];
}
/**
 *  上传手机通讯录
 */
-(void)uploadLocalAddrBook{
    if (&ABAddressBookRequestAccessWithCompletion != NULL) {    //检查是否是iOS6
        
        ABAddressBookRef abRef = ABAddressBookCreateWithOptions(NULL, NULL);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:kAddressListPermissionKey];
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            //如果该应用从未申请过权限，申请权限
            [self uploading];
            [defaults setBool:YES forKey:kAddressListPermissionKey];

            
            /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"程序需要访问您的通讯录，打开通讯录后程序将保存您的通讯录至服务器，确定打开吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];*/
            
        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            //如果权限已经被授予
            [self uploading];
            [defaults setBool:YES forKey:kAddressListPermissionKey];
        } else {
            
            //如果权限被收回，只能提醒用户去系统设置菜单中打开
            [defaults setBool:NO forKey:kAddressListPermissionKey];
        }
        
        [defaults synchronize];
        
        if(abRef){
            
            CFRelease(abRef);
            
        }
        
    }
}
-(void)getServiceTime{
    NSString *lookTVEPG = [NSString stringWithFormat:@"%@/epg/getServerTime.shtml", LOOKTVEPG];
    
    [BaseAFHTTPManager getRequestOperationForHost:lookTVEPG forParam:@"" forParameters:nil completion:^(id responseObject) {
        NSTimeInterval serverTime = [[responseObject firstObject][@"serverTime"] doubleValue];
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        [HiTVGlobals sharedInstance].timeIntervalDifferece = serverTime - currentTime;
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
    }];
}
/**
 *  匿名用户登录(手机)
 */
-(void)anonymousUserLogin_Mobile
{
    [self getServiceTime];
    [self getMarketingDescRequest];

    [HiTVGlobals sharedInstance].deviceId = [NSUserDefaultsManager getObjectForKey:YSTENID];
    if (![HiTVGlobals sharedInstance].deviceId) {
        [HiTVGlobals sharedInstance].deviceId = @"00000000000000000000000000000000";
    }

    NSString *deviceType = @"MOBILE";

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];

    NSString *versionParams = [NSString stringWithFormat:@"%@_%@",app_Name,APPVersion];
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:deviceType forKey:@"devicetype"];
    [parameters setValue:[HiTVGlobals sharedInstance].deviceId forKey:@"deviceid"];
    [parameters setValue:[NSNumber numberWithInt:1] forKey:@"idType"];
    [parameters setValue:versionParams forKey:@"version"];
    if (![CHANNELID isEqualToString:taipanTest63]) {
        [parameters setObject:BIMS_DOMAIN forKey:@"area"];
    }
    [BaseAFHTTPManager getRequestOperationForHost:WXSEEN  forParam:@"/userservice/anonymous/login" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            if ([[responseDic objectForKey:@"uid"] isKindOfClass:[NSString class]]) {
                [HiTVGlobals sharedInstance].uid = [responseDic objectForKey:@"uid"];
            } else if([[responseDic objectForKey:@"uid"] isKindOfClass:[NSNumber class]]) {
                NSNumber* num = [responseDic objectForKey:@"uid"];
                [HiTVGlobals sharedInstance].uid = num.stringValue;
            } else {
                [HiTVGlobals sharedInstance].uid = [responseDic objectForKey:@"uid"];
                
            }
            [HiTVGlobals sharedInstance].anonymousUid = [responseDic objectForKey:@"uid"];
            [NSUserDefaultsManager saveObject:[responseDic objectForKey:@"uid"] forKey:ANONYMOUSUID];
            [NSUserDefaultsManager saveObject:[responseDic objectForKey:@"sk"] forKey:SK];
            
            [[BIMSManager sharedInstance]getUserInfo];
            
        } else {
            [self getCacheUserInfo];
            [Utils BDLog:2 module:@"603" action:@"AppLogin" content:@"result=-1&state=&content="];
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSString *error) {
        
        [Utils BDLog:2 module:@"603" action:@"AppLogin" content:@"result=-1&state=&content="];
        [self getCacheUserInfo];
    }];
}

//更新用户信息
-(void)updateUserInfo{
    NSString *uid = [NSUserDefaultsManager getObjectForKey:P_UID];
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    
    [parameters setValue:uid forKey:@"uid"];
    [parameters setValue:uid forKey:@"oprUid"];
    
    
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN  forParam:@"/userservice/taipan/userInfo" forParameters:parameters  completion:^(id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        
        if (code.intValue == 0) {
            NSDictionary *userinfo = [responseDic objectForKey:@"userInfo"];
            [HiTVGlobals sharedInstance].uid = [userinfo objectForKey:@"uid"];
            
            
            [HiTVGlobals sharedInstance].faceImg = [userinfo objectForKey:@"faceImg"];
            if ([HiTVGlobals sharedInstance].faceImg==nil ||[[HiTVGlobals sharedInstance].faceImg isKindOfClass:[NSNull class]]) {
                [HiTVGlobals sharedInstance].faceImg = @"";
            }
            [HiTVGlobals sharedInstance].nickName = [userinfo objectForKey:@"nickName"];
            if ([HiTVGlobals sharedInstance].nickName==nil) {
                [HiTVGlobals sharedInstance].nickName = @"";
            }
            [HiTVGlobals sharedInstance].phoneNo = [userinfo objectForKey:@"phoneNo"];
            /*if ([[userinfo objectForKey:@"nickName"] isEqualToString:[userinfo objectForKey:@"phoneNo"]]) {
                NSString *userName = [userinfo objectForKey:@"nickName"];
                //NSRange r1 = {4,7};
                NSString *ycStr = [userName substringWithRange:NSMakeRange(3, 4)];
                [HiTVGlobals sharedInstance].nickName = [userName stringByReplacingOccurrencesOfString:ycStr withString:@"****"];
                
            }*/
            [HiTVGlobals sharedInstance].isLogin = YES;
            
            if ([[userinfo objectForKey:@"userAuth"]intValue]==0) {
                [HiTVGlobals sharedInstance].isPublicRecord = YES;
            }
            else{
                [HiTVGlobals sharedInstance].isPublicRecord = NO;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReloadUser object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReloadUser object:nil];
        }
        
    }failure:^(NSString *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReloadUser object:nil];
        
    }];
}
//用户信息
-(void)setUserInfo:(NSDictionary *)userInfo{
    [HiTVGlobals sharedInstance].isLogin = YES;
    
    [HiTVGlobals sharedInstance].uid = [userInfo objectForKey:@"uid"];
    [HiTVGlobals sharedInstance].faceImg = [userInfo objectForKey:@"faceImg"];
    if ([HiTVGlobals sharedInstance].faceImg==nil ||[[HiTVGlobals sharedInstance].faceImg isKindOfClass:[NSNull class]]) {
        [HiTVGlobals sharedInstance].faceImg = @"";
    }
    [HiTVGlobals sharedInstance].nickName = [userInfo objectForKey:@"nickName"];
    if ([HiTVGlobals sharedInstance].nickName==nil) {
        [HiTVGlobals sharedInstance].nickName = @"";
    }
    
    [HiTVGlobals sharedInstance].phoneNo = [userInfo objectForKey:@"phoneNo"];
    

    [HiTVGlobals sharedInstance].xmppUserId = [NSUserDefaultsManager getObjectForKey:XMPP_JID];
    [HiTVGlobals sharedInstance].xmppCode = [NSUserDefaultsManager getObjectForKey:XMPP_CODE];
    
    [self getLivingTokenRequest];
    
    [self isHavePersonalResultRequest];

}
-(void)getCacheUserInfo{
    //获取到缓存的用户信息
    NSString *uid = [NSUserDefaultsManager getObjectForKey:ANONYMOUSUID];
    [HiTVGlobals sharedInstance].anonymousUid = uid;
    [HiTVGlobals sharedInstance].uid = uid;
    NSDictionary *userInfo = [NSUserDefaultsManager getObjectForKey:USERINFO];
    if (userInfo.count>0) {
        [self setUserInfo:userInfo];
        [self xmppReconnect];
    }
}
//获取用户信息
-(void)getUserInfo
{
    NSString *uid = [NSUserDefaultsManager getObjectForKey:P_UID];
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    
    [parameters setValue:uid forKey:@"uid"];
    [parameters setValue:uid forKey:@"oprUid"];
    
    
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN  forParam:@"/userservice/taipan/userInfo" forParameters:parameters  completion:^(id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        
        if (code.intValue == 0) {
            NSDictionary *userinfo = [responseDic objectForKey:@"userInfo"];
            [NSUserDefaultsManager saveObject:userinfo forKey:USERINFO];
            
            [self setUserInfo:userinfo];
            
            [NSUserDefaultsManager saveObject:[userinfo objectForKey:@"phoneNo"] forKey:PHONENO];
            [MobClick profileSignInWithPUID:[HiTVGlobals sharedInstance].phoneNo];
            
            
            /*if ([[userinfo objectForKey:@"nickName"] isEqualToString:[userinfo objectForKey:@"phoneNo"]]) {
             NSString *userName = [userinfo objectForKey:@"nickName"];
             //NSRange r1 = {4,7};
             NSString *ycStr = [userName substringWithRange:NSMakeRange(3, 4)];
             [HiTVGlobals sharedInstance].nickName = [userName stringByReplacingOccurrencesOfString:ycStr withString:@"****"];
             
             }*/
            
            if ([[userinfo objectForKey:@"userAuth"]intValue]==0) {
                [HiTVGlobals sharedInstance].isPublicRecord = YES;
            }
            else{
                [HiTVGlobals sharedInstance].isPublicRecord = NO;
            }
            //获取jid
            [self getJidRequest];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReloadUser object:nil];

            //上传手机通讯录
            [[BIMSManager sharedInstance] uploadLocalAddrBook];
        }
        else{
            [HiTVGlobals sharedInstance].isLogin = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReloadUser object:nil];
        }
        [Utils BDLog:2 module:@"603" action:@"AppLogin" content:@"result=0&state=&content="];
    }failure:^(NSString *error) {
        [Utils BDLog:2 module:@"603" action:@"AppLogin" content:@"result=-1&state=&content="];
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReloadUser object:nil];

    }];
}
/**
 *  获取用户jid信息(手机)
 */
-(void)getJidRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:@"1" forKey:@"userType"];
    if (![[HiTVGlobals sharedInstance].disable_moudles containsObject:@"mc-version64"]) {
        [parameters setObject:BIMS_DOMAIN forKey:@"area"];
    }

    [BaseAFHTTPManager getRequestOperationForHost:MultiHost  forParam:@"/getJid" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            //保存xmpp信息
            [NSUserDefaultsManager saveObject:[responseDic objectForKey:@"jid"] forKey:XMPP_JID];
            [NSUserDefaultsManager saveObject:[responseDic objectForKey:@"xmppCode"] forKey:XMPP_CODE];
            [HiTVGlobals sharedInstance].xmppUserId = [NSUserDefaultsManager getObjectForKey:XMPP_JID];
            [HiTVGlobals sharedInstance].xmppCode = [NSUserDefaultsManager getObjectForKey:XMPP_CODE];
            
            //上报社交系统
            [self uploadUserInfoRequest];
            
            if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"vip"]) {
            }
            else{
                //会员鉴权
                [self queryPriceRequest];
            }
            
            NSString *jid = [HiTVGlobals sharedInstance].xmppUserId;
            //登录xmpp
            [TPIMUser loginWithUsername:jid password:[HiTVGlobals sharedInstance].xmppCode complecationHandler:^(id responseObject, NSError *error) {
                if (!error) {
                    [HiTVGlobals sharedInstance].xmppConnected = YES;
                    [[TogetherManager sharedInstance] start];
                }
                else if(![HiTVGlobals sharedInstance].isXmppConflicted){
                    [[AppDelegate appDelegate].appdelegateService setRemoteLogoToLoading:YES];
                    [self xmppReconnect];
                }
            }];
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSString *error) {
    }];
}
/**
 *  上报社交系统
 */
-(void)uploadUserInfoRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].xmppUserId forKey:@"jid"];
    
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST  forParam:@"/taipan/uploadUserInfo" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
        }
        
    }failure:^(NSString *error) {
    }];
}
/**
 *  会员鉴权
 */
-(void)queryPriceRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].phoneNo forKey:@"phone"];
    [parameters setValue:@"PHONE" forKey:@"source"];
    // [parameters setValue:@"MEMBER|FREETRAFFIC" forKey:@"type"];
    [parameters setValue:@"" forKey:@"token"];
    
    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/member/queryPrice" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            NSString *isMember = [responseDic objectForKey:@"isMember"];
            if ([isMember isEqualToString:@"0"]) {
                [HiTVGlobals sharedInstance].VIP = YES;
                [HiTVGlobals sharedInstance].expireDate = [responseDic objectForKey:@"expireDate"];
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_VIPINFO object:nil];
            }
        }
        
    }failure:^(NSString *error) {
        
    }];
}
/**
 *  获取营销描述信息
 */
-(void)getMarketingDescRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:@"1" forKey:@"type"];
    [parameters setValue:@"PHONE" forKey:@"source"];
    
    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/marketing/getMarketingDesc" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            [HiTVGlobals sharedInstance].marketingDesc = [responseDic objectForKey:@"marketingDesc"];
            
        }
        
    }failure:^(NSString *error) {
        
    }];
}
//修改用户信息是否公开观看收藏记录
-(void)publicRecord:(NSString *)userAuth
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:userAuth forKey:@"userAuth"];
    
    
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN  forParam:@"/userservice/update/setting" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            if ([userAuth isEqualToString:@"1"]) {
                [HiTVGlobals sharedInstance].isPublicRecord = NO;
            }
            else{
                [HiTVGlobals sharedInstance].isPublicRecord = YES;
            }
        }
        
        
    }failure:^(NSString *error) {
        DDLogError(@"fail");
    }];
}

//提交点亮页
- (void)submitUserInterestedClass
{
    NSDictionary *param = @{
                            @"userId" : [HiTVGlobals sharedInstance].uid,
                            @"interestedClass" : [HiTVGlobals sharedInstance].interested,
                            };
    [BaseAFHTTPManager getRequestOperationForHost:MYEPG forParam:@"/personal/addUserInterestedClass" forParameters:param completion:^(id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        
    }];
}

/*#pragma mark -  定时器
- (void)initVerTimer
{
    if (!_verTimer) {
        _verTimer = [NSTimer scheduledTimerWithTimeInterval:REMOTESTATUSDELAY target:self selector:@selector(xmppReconnect) userInfo:nil repeats:YES];
        [_verTimer fire];
    }
}*/
- (void)xmppReconnect{
    NSString *jid = [HiTVGlobals sharedInstance].xmppUserId;
    if (![HiTVGlobals sharedInstance].isXmppConflicted) {
        //登录xmpp
        [TPIMUser loginWithUsername:jid password:[HiTVGlobals sharedInstance].xmppCode complecationHandler:^(id responseObject, NSError *error) {
            if (!error) {
                [HiTVGlobals sharedInstance].xmppConnected = YES;
                [[TogetherManager sharedInstance] start];
                [[AppDelegate appDelegate].appdelegateService setRemoteLogoToLoading:NO];
            }
            else{
                //[[AppDelegate appDelegate].appdelegateService setRemoteLogoToLoading:YES];
            }
        }];
    }
    
}

/**
 *  用CHKeychain获取手机UUID作为IMEI
 */
-(NSString*)imei{
    if ([CHKeychain load:UUIDKEY]) {
        
        NSString* result = [[CHKeychain load:UUIDKEY] stringByReplacingOccurrencesOfString:@"-" withString:@""];

        return result;
    }
    else
    {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        
        result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];

        if (result.length>32) {
            result = [result substringToIndex:32];
        }
        [CHKeychain save:UUIDKEY data:result];
        return result;
    }
    
    return nil;
}
/**
 *  获取mac地址（已无效）
 */
- (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        DDLogError(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    DDLogError(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    return macAddressString;
}

//开始上传
-(void)uploading{
    NSArray *addrBookArray = [self getLocalAddressBook];
    self.addressBookArray = [addrBookArray copy];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (AddressBook *entity in addrBookArray) {
        NSMutableDictionary *addrBookDic =  [NSMutableDictionary dictionary];
        NSString* tel = [entity.tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [addrBookDic setValue:tel forKey:@"phoneNo"];
        [addrBookDic setValue:entity.name forKey:@"name"];
        if (tel.length>0 &&entity.name.length>0) {
            [arr addObject:addrBookDic];
        }
    }
    
    id result = [NSJSONSerialization dataWithJSONObject:arr
                                                options:kNilOptions error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:result
                                                 encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:jsonString forKey:@"phoneNoAndName"];
    
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/uploadUserAddrBooks" forParameters:parameters  completion:^(id responseObject) {
        
        DDLogInfo(@"suc");
    }failure:^(NSString *error) {
        DDLogError(@"fail");
        
    }];
}
-(NSMutableArray *)getLocalAddressBook{
    NSMutableArray *addressBookTemp = [NSMutableArray array];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    else
        
    {
        addressBooks = ABAddressBookCreate();
        
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    
    //通讯录中人数
    //!!!:可能导致内存溢出
    //!!!:
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        AddressBook *addressBook = [[AddressBook alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                //!!!:可能导致内存溢出
                //!!!:
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                AddressBook *book = [[AddressBook alloc] init];
                book.name = nameString;
                book.recordID = (int)ABRecordGetRecordID(person);;
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        book.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        book.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
                //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
                [addressBookTemp addObject:book];
            }
            CFRelease(valuesRef);
        }
        
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    //!!!:可能导致内存溢出
    //!!!:
   // DDLogError(@"----%@----",self.addressBookTemp);
    return addressBookTemp;
}
#pragma mark - 申请升级
-(void)apkUpdateRequest{

    NSString *verStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    int versionCode = [verStr intValue];
    
    NSString* url = [NSString stringWithFormat:@"%@stb/getApkUpgradeInfor/%@/%@/%@/%d",
                     [HiTVGlobals sharedInstance].apkUpdateHost,[HiTVGlobals sharedInstance].imei,[HiTVGlobals sharedInstance].deviceId,[HiTVGlobals sharedInstance].softCode,versionCode];
    
    [BaseAFHTTPManager requestXMLWithParameter:@"" forHost:url completion:^(id responseObject) {
                           
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSDictionary *upgradesDic = responseDic[@"upgrades"][@"upgrade"];
        int serverCode = [upgradesDic[@"_versionId"] intValue];
        
        NSString *verStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        int localCode = [verStr intValue];
        
        if (localCode<serverCode) {
            NSString *force = upgradesDic[@"_isForce"];
            packageLocationUrl = upgradesDic[@"_packageLocation"];
            upgradeContent = upgradesDic[@"_upgradeContent"];
            [self showAlerView:force];
        }
        
    } failure:^(NSString *error){
        DDLogError(@"fail");
    }];
}
#pragma mark - 手机获取生活缴费用户登录
-(void)getLivingTokenRequest{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].phoneNo forKey:@"phoneNo"];
    
    [BaseAFHTTPManager postRequestOperationForHost:BSS_HOST forParam:@"/mobile/getLivingToken" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"resultCode"];
        if ([code isEqualToString:@"000"]) {
            [HiTVGlobals sharedInstance].livingToken = [responseDic objectForKey:@"token"];
        }
        
    }failure:^(NSString *error) {
        
    }];
}
-(void)showAlerView:(NSString *)force{
    NSString *otherButtonTitle = @"忽略";
    if ([force isEqualToString:@"true"]) {
        isForce = YES;
        otherButtonTitle = nil;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:upgradeContent delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:otherButtonTitle, nil];
    alert.tag = 10001;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 10001:
        {
            if (buttonIndex == 0) {
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/zhang-shang-mo-bai-he/id1051664084?mt=8"]];
                if (packageLocationUrl.length>0) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:packageLocationUrl]];
                }
                else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://beta.bugly.qq.com/7rzp"]];
                }
                
                // if (isForce) {
                //  exit(0);
                //}
            }
        }
            break;
        case 10002:
        {
            [self boot];
        }
            break;
        case 10003:
        {
            [self registeredMobileInformation];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark -  Request
- (void)isHavePersonalResultRequest
{
    __weak __typeof(self)weakSelf = self;
    NSDictionary *param = @{
                            @"userId" : [HiTVGlobals sharedInstance].uid,
                            //@"tvTemplateId" : WATCHTVGROUPID,
                            //@"vodTemplateId" : [[HiTVGlobals sharedInstance]getEpg_groupId],
                            @"abilityString" :  T_STBext,
                            };
    NSString* url = [NSString stringWithFormat:@"%@personal/isHavePersonalResult",
                     MYEPG];
    
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:param completion:^(id responseObject) {
        //        [HUD hideAnimated:YES];
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            if ([[resultDic objectForKey:@"isHave"] intValue] == 1) {
            }
            else{
                //自动点亮有数据则上传
                if ([HiTVGlobals sharedInstance].interested) {
                    [self submitUserInterestedClass];
                }
            }
        }
        else{
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {

    }];
}
-(void)showBootErrorView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器连接错误" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
    alert.tag = 10002;
    [alert show];
}
-(void)showRegisterErrorView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接错误，请检查网络设置" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
    alert.tag = 10003;
    [alert show];
}
@end
