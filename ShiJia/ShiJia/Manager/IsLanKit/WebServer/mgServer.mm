//
//  httpSrv.m
//  httpSrv
//
//  Created by Jian Huang on 8/22/16.
//  Copyright © 2016 Jian Huang. All rights reserved.
//

#import "mgServer.h"
#import "httpSrv.h"
#import "BIMSManager.h"
#import "Config.h"
#import "TogetherManager.h"

void actionResultCallBackImp(int status, const char* reason)
{
    DDLogInfo(@"%s", reason);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_dlnaDoActionCallbackImp object:@{@"status":[NSNumber numberWithInt:status],@"reason":[NSString stringWithUTF8String:reason]}];
}


void resultCallBackImp(int status, const char* reason)
{
    DDLogInfo(@"%s", reason);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_dlnaBroastcastCallbackImp object:@{@"status":[NSNumber numberWithInt:status],@"reason":[NSString stringWithUTF8String:reason]}];
}

void dlnaDevicesCallbackImp(const char* uuid, const char* deviceName, bool isOffline)
{
    DDLogInfo(@"%@ is %@", [NSString stringWithUTF8String:uuid], isOffline?@"Add.":@"removed.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_dlnaDevicesCallbackImp object:@{@"uuid":[NSString stringWithUTF8String:uuid],@"deviceName":[NSString stringWithUTF8String:deviceName], @"isOffline":isOffline?@1:@0}];
    
}

void receiverCallback(char* data1, unsigned int cnt) {
    NSData* data = [NSData dataWithBytes:data1 length:cnt];
    [[TogetherManager sharedInstance] actionOfCallback:data];
#if 0
    // test code.
    const char* param = "{\
    \"mobileUserId\":\"999999\" ,\
    \"network\":\"2G\" ,\
    \"uploadAddr\":\"123123123 hello world\"\
    }";
    //char arr[1024] = {0};
    DDLogInfo(@"%@", [mgServer getSrvParams]);
    [mgServer setSrvParams:[NSString stringWithUTF8String:param]];
    DDLogInfo(@"%@", [mgServer getSrvParams]);

    
    DDLogInfo(@"network is %d",[Utils isConnectedToInternet]);
#endif
}


static void(^block)() = ^(){
    const char* mobileType = [Utils platformString].UTF8String;
    NSString* str = [HiTVGlobals sharedInstance].uid;
    if (str == nil) {
        str = [HiTVGlobals sharedInstance].anonymousUid;
    }
    
    if ([str isKindOfClass:[NSNumber class]]) {
        NSNumber* tmp = (NSNumber*) str;
        str = [tmp stringValue];
    }
    
    NSString *version = APPVersion;
    NSString* sysVersion = [[UIDevice currentDevice] systemVersion];
    NSString* imei = [[BIMSManager sharedInstance] imei];
    const char* network = [Utils getNetWorkStates].UTF8String;
    
    NSString* ip = [IPDetector getIPAddress];
    if ([ip isEqual:@"error"]) {
        ip = @"127.0.0.1";
    }
    
    const char* param = "{\
    \"webRoot\":\"%s\",\
    \"host\":\"%s\",\
    \"port\":\"8090\",\
    \"mobileType\":\"%s\",\
    \"mobileUserId\":\"%s\",\
    \"app_version\":\"%s\",\
    \"sys_version\":\"%s\",\
    \"imsi\":\"%s\",\
    \"network\":\"%s\",\
    \"packageCount\":\"%s\",\
    \"uploadAddr\":\"%s\",\
    \"uploadInterval\":\"%s\"\
    }";
    char arr[1024] = {0};
    
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = cacPath.firstObject;
    sprintf(arr, param, cachePath.UTF8String,
            ip.UTF8String,
            mobileType,
            [NSString stringWithFormat:@"%@|%@|%s", isBlankString(str), isBlankString([HiTVGlobals sharedInstance].phoneNo), network].UTF8String,
            version.UTF8String,
            sysVersion.UTF8String,
            imei.UTF8String,
            network,
            "50",
            [HiTVGlobals sharedInstance].loggerAddr.UTF8String,
            "60");
    printf("\nhttp server params: \n\n%s\n", arr);
    
    CallBack t = &receiverCallback;
    //CallBack t = NULL;
    startHttpService(arr);
    startMonitoring(t);
    DDLogInfo(@"%@", [HiTVGlobals sharedInstance].phoneNo);
};

@implementation mgServer

+ (void)start
{
#ifdef SIMPLE_HTTP_SERVICE
    main_test();
#else
    block();
#endif
}


+ (void)stop{
    stopHttpService();
    stopMonitoring();
}

+ (NSString*) currentPort
{
    return [NSString stringWithFormat:@"%d", getHttpSrvPort()];
}

+ (bool)updateSrvInfo:(SrvInfoType) type : (NSString*) value
{
    if ([value isKindOfClass:[NSString class]]) {
        if (value.length > 0) {
            return updateSrvInfo(value.UTF8String, type);
        } else {
            return false;
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber* num = (NSNumber*)value;
        return updateSrvInfo(num.stringValue.UTF8String, type);
    } else {
        DDLogInfo(@"value input occur ERROR!!!");
        return false;
    }
}

+ (void)sendMsg:(NSData*) data andHost :(NSString*) host
{
    Byte *testByte = (Byte *)[data bytes];
    sendUdp(testByte, host.UTF8String, 5002);
}

#if 0
+ (void)startDlna
{
    dlnaDevicesCallback t = &dlnaDevicesCallbackImp;
    startDlnaService(t);
}

+ (void)stopDlna
{
    stopDlnaService();
}

+ (void)broadcast2Tv:(NSString*) uuid :(NSString*)url
{
    resultCallBack t = & resultCallBackImp;
    broadcast2Tv(url.UTF8String, t, uuid.UTF8String);
}

+ (void)doAction:(ActionType) type :(NSString*) uuid :(NSString*)pos
{
    resultCallBack t = & actionResultCallBackImp;
    doAction(type, t, uuid.UTF8String, pos.UTF8String);
}
#endif
@end
