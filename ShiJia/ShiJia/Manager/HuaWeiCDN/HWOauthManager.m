//
//  HWOauthManager.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/21.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "HWOauthManager.h"
#import "JKEncrypt.h"
#import "BIMSManager.h"
#import "IPDetector.h"

static NSString* const HWHost = @"http://221.179.217.6:8082";
static NSString* const userId = @"201703141515";
static int h_interval = 600;


@interface HWOauthManager ()
@property(nonatomic,strong) NSString *epgUrl;
@property(nonatomic,strong) NSString *encryToken;   //挑战字;
@property (nonatomic, strong)dispatch_source_t time;

@end
@implementation HWOauthManager
+ (instancetype)sharedInstance{
    static HWOauthManager *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

-(void)Authentication{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    
    [parameters setValue:@"Login" forKey:@"Action"];
    [parameters setValue:userId forKey:@"UserID"];
    [parameters setValue:@"1" forKey:@"return_type"];

    WEAKSELF
    [BaseAFHTTPManager postRequestOperationForHost:HWHost  forParam:@"/EDS/jsp/AuthenticationURL" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *url = responseDic[@"epgurl"];
        if (url.length>0) {
            NSString *str = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            NSArray *host = [str componentsSeparatedByString:@"/"];
            weakSelf.epgUrl = [NSString stringWithFormat:@"http://%@",host[0]];
            if (weakSelf.epgUrl.length>0) {
                [weakSelf getEncryToken];
            }
        }
    }failure:^(NSString *error) {

    }];
}
-(void)getEncryToken{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    
    [parameters setValue:@"EncryToken" forKey:@"response_type"];
    [parameters setValue:@"android" forKey:@"client_id"];
    [parameters setValue:userId forKey:@"userid"];

    WEAKSELF
    [BaseAFHTTPManager postRequestOperationForHost:self.epgUrl  forParam:@"/EPG/oauth/v2/authorize" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        weakSelf.encryToken = responseDic[@"EncryToken"];
        [weakSelf getAccessToken];
        
    }failure:^(NSString *error) {
        
    }];
}
-(void)getAccessToken{
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        
        [parameters setValue:@"EncryToken" forKey:@"grant_type"];
        [parameters setValue:@"android" forKey:@"client_id"];
        [parameters setValue:userId forKey:@"UserID"];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        [parameters setValue:app_Name forKey:@"DeviceType"];
        
        NSString* version = APPVersion;
        [parameters setValue:version forKey:@"DeviceVersion"];
       // [parameters setValue:[self encrypt] forKey:@"authinfo"];
        [parameters setValue:@"1" forKey:@"userdomain"];
        [parameters setValue:@"1" forKey:@"datadomain"];
        [parameters setValue:@"1" forKey:@"accountType"];

        WEAKSELF
        [BaseAFHTTPManager postRequestOperationForHost:self.epgUrl  forParam:@"/EPG/oauth/v2/token" forParameters:parameters  completion:^(id responseObject) {
            NSDictionary *responseDic = (NSDictionary *)responseObject;
            weakSelf.accessToken = responseDic[@"access_token"];
            [weakSelf refreshAccessToken];
        }failure:^(NSString *error) {
            
        }];
}

-(void)refreshAccessToken{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(h_interval * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(h_interval* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(self.time, ^{
        
        [self toUpdateAccessToken];
    });
    //启动定时器
    dispatch_resume(self.time);
}
-(void)toUpdateAccessToken{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    
    [parameters setValue:@"refresh_token" forKey:@"grant_type"];
    [parameters setValue:self.accessToken forKey:@"refresh_token"];
    [parameters setValue:@"123456" forKey:@"client_secret"];
    [parameters setValue:@"android" forKey:@"client_id"];
    
    WEAKSELF
    [BaseAFHTTPManager postRequestOperationForHost:self.epgUrl  forParam:@"/EPG/oauth/v2/token" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        weakSelf.accessToken = responseDic[@"access_token"];
        
    }failure:^(NSString *error) {
        
    }];
}
-(void)playContentAuthorize:(HWVideoModel *)content completion:(void(^)(NSString *playUrl,NSString *error))handler{
    HWVideoModel *model = content;
    model.idflag = @"1";
    model.Authorization = self.accessToken;

    [BaseAFHTTPManager postJsonRequestOperationForHost:self.epgUrl  forParam:@"/EPG/interEpg/user/default/authorize" forParameters:model.mj_keyValues  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"returncode"] intValue] == 0) {
            NSArray *urls = responseDic[@"urls"];
            NSDictionary *urlDic = urls.firstObject;
            NSString *playurl = urlDic[@"playurl"];

            handler(playurl,nil);
        }
        else{
            handler(nil,@"fail");
        }
        
    }failure:^(NSString *error) {
        //handler(nil,error);
        //[self getEncryToken];
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        
        [parameters setValue:@"EncryToken" forKey:@"grant_type"];
        [parameters setValue:@"android" forKey:@"client_id"];
        [parameters setValue:userId forKey:@"UserID"];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        [parameters setValue:app_Name forKey:@"DeviceType"];
        
        NSString* version = APPVersion;
        [parameters setValue:version forKey:@"DeviceVersion"];
        // [parameters setValue:[self encrypt] forKey:@"authinfo"];
        [parameters setValue:@"1" forKey:@"userdomain"];
        [parameters setValue:@"1" forKey:@"datadomain"];
        [parameters setValue:@"1" forKey:@"accountType"];
        
        WEAKSELF
        [BaseAFHTTPManager postRequestOperationForHost:self.epgUrl  forParam:@"/EPG/oauth/v2/token" forParameters:parameters  completion:^(id responseObject) {
            NSDictionary *responseDic = (NSDictionary *)responseObject;
            weakSelf.accessToken = responseDic[@"access_token"];
            HWVideoModel *model = content;
            model.idflag = @"1";
            model.Authorization = self.accessToken;
            
            [BaseAFHTTPManager postJsonRequestOperationForHost:self.epgUrl  forParam:@"/EPG/interEpg/user/default/authorize" forParameters:model.mj_keyValues  completion:^(id responseObject) {
                NSDictionary *responseDic = (NSDictionary *)responseObject;
                if ([responseDic[@"returncode"] intValue] == 0) {
                    NSArray *urls = responseDic[@"urls"];
                    NSDictionary *urlDic = urls.firstObject;
                    NSString *playurl = urlDic[@"playurl"];
                    
                    handler(playurl,nil);
                }
                else{
                    handler(nil,@"fail");
                }
                
            }failure:^(NSString *error) {
                handler(nil,error);
            }];
        }failure:^(NSString *error) {
            
        }];
    }];
}
//TV 网络包
-(NSDictionary *)tvDic{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    
    [parameters setValue:@"EncryToken" forKey:@"grant_type"];
    [parameters setValue:@"android" forKey:@"client_id"];
    [parameters setValue:@"04957325F473" forKey:@"UserID"];
    [parameters setValue:@"B860AV2.1" forKey:@"DeviceType"];
    [parameters setValue:@"1.0V81011334.0003" forKey:@"DeviceVersion"];
    [parameters setValue:@"fb9c00afed212d3c08f0c950d014c9cc7f576dad98073faf72d4b56468ed21769910f6216fed11b1dc4f676f1fe2d7fcab901941f9b2c553ed4ffee76c7bcbdfa55fa6ee82c1116723394cf908f20bcd4436459b3d48749bbb758cbb359be668a5609ae2d0068bb24e9926e39e29c137398f07bab20e83d6fa99d2fd9721d68e7618d3ce7ee605a5" forKey:@"authinfo"];
    
    [parameters setValue:@"1" forKey:@"userdomain"];
    [parameters setValue:@"1" forKey:@"datadomain"];
    [parameters setValue:@"1" forKey:@"accountType"];

    return parameters;
}

-(NSString *)encrypt{
    /*NSString *str = @"fb9c00afed212d3c08f0c950d014c9cc7f576dad98073faf72d4b56468ed21769910f6216fed11b1dc4f676f1fe2d7fcab901941f9b2c553ed4ffee76c7bcbdfa55fa6ee82c1116723394cf908f20bcd4436459b3d48749bbb758cbb359be668a5609ae2d0068bb24e9926e39e29c137398f07bab20e83d6fa99d2fd9721d68e7618d3ce7ee605a5";
    
    DDLogInfo(@"---%@---",[JKEncrypt doDecEncryptStr:str]);*/
    
    
    int x = arc4random() % 99999999;
    NSString *random = [NSString stringWithFormat:@"%d",x];
    NSString *encryToken = self.encryToken;
    NSString *userID = userId;
    NSString *deviceID = [[BIMSManager sharedInstance]imei];
    NSString *ip = [IPDetector getIPAddress];
    NSString *mac = [IPDetector getMacAddress];
    NSString *ott = @"OTT";
    
    NSString *authinfo = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@",random,encryToken,userID,deviceID,ip,mac,ott];
    
    NSString *result = [JKEncrypt doEncryptStr:authinfo];
    
    return result;
}
@end
