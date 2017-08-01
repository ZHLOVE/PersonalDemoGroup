 //
//  TogetherManager.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/30.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "TogetherManager.h"
#import "CCLocationManager.h"
#import "IPDetector.h"
#import "HiTVDeviceInfo.h"
#import "Utils.h"
#import "BIMSManager.h"
#import "HiTViSLanMessage.h"
#import "mgServer.h"
#import "SJResumeVideoViewModel.h"

typedef void (^HiTVReceiveDataBlock)(void);

static NSString* const version62 = @"taipan6.2";
static NSString* const version63 = @"taipan6.3";
static NSString* const version64 = @"taipan6.4";

@interface TogetherManager (){
    

}
@property (nonatomic, strong) NSMutableArray* mutableDetectedDevices;

@property (nonatomic, strong) NSString* tvAnonymousUid;
@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isNetChange;

@property (nonatomic, strong) NSTimer *verTimer;              //计时器
@property (nonatomic, strong) NSString *version;              //多屏版本号

// remove from HiTVListenerManager.
@property (nonatomic, strong) NSMutableArray *distrustTvArray;
@property (nonatomic, strong) HiTVReceiveDataBlock receiveDataBlock;
@property (nonatomic, strong) SJResumeVideoViewModel *resumeViewModel;

@end
@implementation TogetherManager
+ (instancetype)sharedInstance{
    static TogetherManager *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}
-(void)start{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TPIMNotification_NetReachability object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChange:) name:TPIMNotification_NetReachability object:nil];

    [[HiTVGlobals sharedInstance].tvAnonymousUidArray removeAllObjects];
    if (![HiTVGlobals sharedInstance].uid) {
        [HiTVGlobals sharedInstance].uid = @"";
    }
    [self reportConditionsformation];
    
    self.isStart = YES;
    
    
    __weak typeof(self) this = self;
    
    self.receiveDataBlock = ^{
        [HiTVGlobals sharedInstance].iniT = @"true";
        [this reportConditionsformation];
    };

}
/*
 *掉线重连
 */
-(void)reconnect{
    if (![HiTVGlobals sharedInstance].isLogin) {
        if (!self.isStart) {
            
            [HiTVGlobals sharedInstance].iniT = @"false";
            //NSString *netWorkState = [Utils getNetWorkStates];
            [HiTVGlobals sharedInstance].tvAnonymousUid = nil;
            [[HiTVGlobals sharedInstance].tvAnonymousUidArray removeAllObjects];
            self.connectedDevice = nil;
            [[ScreenManager sharedInstance]reset];
            [self reportConditionsformation];
        }
        self.isStart = NO;
    }
    
}
//上报在一起，本地信息
-(void)reportConditionsformation{
    self.reportType = @"NOSCANCODE";
    if ([[HiTVGlobals sharedInstance].latitude intValue]==0) {
        [self getLat];
    }
    else{
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self Report];
        //});
    }
}

//网络改变
-(void)reachabilityStatusChange:(NSNotification *)notification{
    if (![HiTVGlobals sharedInstance].isLogin) {
        if (!self.isStart) {
            
            [HiTVGlobals sharedInstance].iniT = @"true";
            NSString *netWorkState = [Utils getNetWorkStates];
            if (![netWorkState isEqualToString:@"WIFI"]) {
                [HiTVGlobals sharedInstance].tvAnonymousUid = nil;
            }
            [[HiTVGlobals sharedInstance].tvAnonymousUidArray removeAllObjects];
            self.connectedDevice = nil;
            [[ScreenManager sharedInstance]reset];
            [self reportConditionsformation];
        }
        self.isStart = NO;
    }
}


-(void) actionOfCallback:(NSData*) data
{
    HiTViSLanMessage* message = [[HiTViSLanMessage alloc] initWithDataForListener:data];
    if (!message.tvAnonymousUid || message.tvAnonymousUid.length==2) {
        ;
    }
    else{
        //automatic为1，必须上报
        if (message.automatic == 1) {
            [HiTVGlobals sharedInstance].tvAnonymousUid = message.tvAnonymousUid;
            if (self.receiveDataBlock) {
                self.receiveDataBlock();
            }
        }
        else if(message.automatic == 3){//单播结果
            NSMutableArray *tvs = [NSMutableArray array];
            [tvs addObject:message.tvAnonymousUid];
            [self.distrustTvArray removeObject:message.tvAnonymousUid];
            [[TogetherManager sharedInstance] confirmTvNetTVS:tvs identityNet:@"sameNet" completion:^(id responseObject,NSString *error){
                
            }];
        }
        //automatic不为1，只上报一次
        else{
            BOOL ISHas = NO;
            for (NSString *ids in [HiTVGlobals sharedInstance].tvAnonymousUidArray) {
                if ([message.tvAnonymousUid isEqualToString:ids]) {
                    ISHas = YES;
                    break;
                }
            }
            if (!ISHas) {
                [HiTVGlobals sharedInstance].tvAnonymousUid = message.tvAnonymousUid;
                if (self.receiveDataBlock) {
                    self.receiveDataBlock();
                }
                if(![HiTVGlobals sharedInstance].tvAnonymousUidArray)
                {
                    [HiTVGlobals sharedInstance].tvAnonymousUidArray = [NSMutableArray array];
                }
                [[HiTVGlobals sharedInstance].tvAnonymousUidArray addObject:message.tvAnonymousUid];
            }
            //            DDLogInfo(@"----%@-----",[HiTVGlobals sharedInstance].tvAnonymousUidArray);
        }
    }
}
/**
* 发送在一起关联请求
 */
-(void)uploadDeviceRelationRequest:(NSDictionary *)infoDic{

    [HiTVGlobals sharedInstance].intranetIp = [IPDetector getIPAddress];
    [HiTVGlobals sharedInstance].gateWay = [IPDetector getGatewayIPAddress];
    [HiTVGlobals sharedInstance].ssid = [IPDetector currentWifiSSID];
    [HiTVGlobals sharedInstance].gateWayMac = [IPDetector gateWayMac];
    if (![HiTVGlobals sharedInstance].gateWayMac) {
        [HiTVGlobals sharedInstance].gateWayMac = @"";
    }
    if ([HiTVGlobals sharedInstance].latitude == nil) {
        [HiTVGlobals sharedInstance].latitude = @"";
    }
    if ([HiTVGlobals sharedInstance].longitude == nil) {
        [HiTVGlobals sharedInstance].longitude = @"";
    }
    if ([HiTVGlobals sharedInstance].ssid == nil) {
        [HiTVGlobals sharedInstance].ssid = @"";
    }
    if ([HiTVGlobals sharedInstance].gateWay == nil) {
        [HiTVGlobals sharedInstance].gateWay = @"";
    }
    if ([HiTVGlobals sharedInstance].intranetIp == nil) {
        [HiTVGlobals sharedInstance].intranetIp = @"";
    }
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setObject:[HiTVGlobals sharedInstance].longitude forKey:@"longitude"];
    [parameters setObject:[HiTVGlobals sharedInstance].latitude forKey:@"latitude"];
    [parameters setObject:[HiTVGlobals sharedInstance].intranetIp forKey:@"intranetIp"];
    [parameters setObject:[HiTVGlobals sharedInstance].ssid forKey:@"ssid"];
    [parameters setObject:[HiTVGlobals sharedInstance].gateWay forKey:@"gateWay"];
    [parameters setObject:[HiTVGlobals sharedInstance].gateWayMac forKey:@"gateWayMac"];

    [parameters setObject:@"APP" forKey:@"type"];
    if ([infoDic objectForKey:@"tvAnonymousUid"]) {
        [parameters setObject:@"true" forKey:@"result"];
    }
    else{
        [parameters setObject:@"false" forKey:@"result"];
    }
    [parameters setObject:@"" forKey:@"templateId"];
    if (![HiTVGlobals sharedInstance].iniT) {
        [HiTVGlobals sharedInstance].iniT = @"true";
    }
    [parameters addEntriesFromDictionary:infoDic];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *jsonString = [parameters mj_JSONString];
    
    [dic setObject:jsonString forKey:@"states"];
    [dic setObject:[HiTVGlobals sharedInstance].iniT forKey:@"init"];
    [dic setObject:self.reportType forKey:@"reportType"];
    [dic setObject:BIMS_DOMAIN forKey:@"area"];
    [dic setObject:self.version forKey:@"version"];


    [MsProtocol creatRelationRequest:dic completion:^(id responseObject) {
        DDLogInfo(@"suc");
        if ([self.version isEqualToString:version62]) {
            // no version 6.2 case
            //[self verTimer];
            
        }
        else{
            [self setRemoteStatus];
        }
        
        
    } failure:^(NSString *error) {
        DDLogError(@"fail");
    }];
}
- (NSArray*)detectedDevices{
    return self.mutableDetectedDevices;
}

/**
 *  判断本地信息是否获取完整
 */
-(void)Report{
    //if ([HiTVGlobals sharedInstance].latitude &&[HiTVGlobals sharedInstance].longitude) {
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    if ([HiTVGlobals sharedInstance].tvAnonymousUid) {
        [parameters setObject:[HiTVGlobals sharedInstance].tvAnonymousUid forKey:@"tvAnonymousUid"];
    }
    if ([[HiTVGlobals sharedInstance].uid intValue] == [[HiTVGlobals sharedInstance].anonymousUid intValue]) {
        return;
    }
    [parameters setObject:[HiTVGlobals sharedInstance].uid forKey:@"typeId"];
    [parameters setObject:[HiTVGlobals sharedInstance].xmppUserId forKey:@"jId"];
    if (![HiTVGlobals sharedInstance].nickName) {
        [HiTVGlobals sharedInstance].nickName = @"";
    }
    if (![HiTVGlobals sharedInstance].faceImg) {
        [HiTVGlobals sharedInstance].faceImg = @"";
    }
    [parameters setObject:[HiTVGlobals sharedInstance].nickName forKey:@"nickName"];
    [parameters setObject:XMPPHOST forKey:@"jIdAddr"];
    [parameters setObject:[HiTVGlobals sharedInstance].faceImg forKey:@"faceImg"];
    //[parameters setObject:@"TOGETHER_SAME_NET" forKey:@"state"];
    if ([HiTVGlobals sharedInstance].serviceAddrs) {
        [parameters setObject:[HiTVGlobals sharedInstance].serviceAddrs forKey:@"serviceAddr"];
    }
    
//    [self uploadDeviceRelationRequest:parameters];
    [self performSelectorInBackground:@selector(uploadDeviceRelationRequest:) withObject:parameters];
    // }
}
//地理信息
-(void)getLat
{
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        NSString *latitude = [NSString stringWithFormat:@"%.4f",locationCorrrdinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%.4f",locationCorrrdinate.longitude];
        
        if ([[HiTVGlobals sharedInstance].latitude intValue] != 0) {
            self.reportType = @"GPRS";
        }
        if (![CCLocationManager shareLocation].openLocation) {
            [HiTVGlobals sharedInstance].latitude = @"";
            [HiTVGlobals sharedInstance].longitude = @"";
            [self Report];
        }
        else if (!([[HiTVGlobals sharedInstance].latitude isEqualToString:latitude]&&[[HiTVGlobals sharedInstance].longitude isEqualToString:longitude])) {
            [HiTVGlobals sharedInstance].latitude = latitude;
            [HiTVGlobals sharedInstance].longitude = longitude;
            [self Report];
        }
        
    }];
}
/**
 * 获取关联列表
 */
-(void)getDeviceDetectionRequestForCompletion:(void(^)(NSArray *devices,NSString *error))handler{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"phoneId"];
    if ([HiTVGlobals sharedInstance].getTvType.length == 0) {
        [parameters setObject:@"default" forKey:@"type"];
    }else{
        [parameters setObject:[HiTVGlobals sharedInstance].getTvType forKey:@"type"];
    }
    [parameters setObject:BIMS_DOMAIN forKey:@"area"];
    [parameters setObject:self.version forKey:@"version"];

    [MsProtocol getTVListRequest:parameters completion:^(id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            self.barrageSwitch = [resultDic objectForKey:@"barrageSwitch"];
            NSMutableArray *tvArray = [NSMutableArray array];
            if ([self.version isEqualToString:version63]) {
                NSString *result = [resultDic objectForKey:@"message"];
                if ([result isKindOfClass:[NSNull class]]) {
                    return ;
                }
                NSArray *resultArray = [result mj_JSONObject];
                for (NSMutableDictionary *userDic in resultArray) {
                    HiTVDeviceInfo *entity = [[HiTVDeviceInfo alloc]init];
                    entity.userId = [userDic objectForKey:@"userId"];
                    entity.nickName = [userDic objectForKey:@"nickName"];
                    entity.jId = [userDic objectForKey:@"jId"];
                    entity.jIdAddr = [userDic objectForKey:@"jIdAddr"];
                    entity.serviceAddr = [userDic objectForKey:@"serviceAddr"];
                    entity.tvName = [userDic objectForKey:@"tvName"];
                    entity.faceImg = [userDic objectForKey:@"faceImg"];
                    entity.state = [userDic objectForKey:@"state"];
                    entity.relationType = [userDic objectForKey:@"relationType"];
                    entity.tvName = [NSString stringWithFormat:@"%@的家",entity.nickName];
                    entity.ownerUid = [userDic objectForKey:@"userId"];

                    [tvArray addObject:entity];
                }
            }
            else{
                BOOL connectTv = NO;
                NSArray *resultArray = [resultDic objectForKey:@"ownerList"];
                for (NSMutableDictionary *userDic in resultArray) {
                    NSArray *tvList = userDic[@"tvList"];
                    if (tvList.count == 0) {
                        HiTVDeviceInfo *entity = [[HiTVDeviceInfo alloc]init];
                        // entity.userId = [userDic objectForKey:@"ownerUid"];
                        entity.nickName = [userDic objectForKey:@"ownerNickName"];
                        entity.faceImg = [userDic objectForKey:@"faceImg"];
                        entity.relationType = [userDic objectForKey:@"relationType"];
                        //entity.ownerUid = [userDic objectForKey:@"ownerUid"];
                        entity.tvName = [NSString stringWithFormat:@"%@的家",entity.nickName];
                        entity.ownerUid = [userDic objectForKey:@"ownerUid"];
                        entity.ownerUserId = [userDic objectForKey:@"ownerUid"];
                        if ([entity.ownerUid isEqualToString:self.connectedDevice.ownerUid]) {
                            connectTv = YES;
                        }
                    }
                    else{
                        for (int n = 0;n<tvList.count;n++) {
                            NSMutableDictionary *tvDic = tvList[n];
                            HiTVDeviceInfo *entity = [[HiTVDeviceInfo alloc]init];
                            // entity.userId = [userDic objectForKey:@"ownerUid"];
                            entity.nickName = [userDic objectForKey:@"ownerNickName"];
                            entity.faceImg = [userDic objectForKey:@"faceImg"];
                            entity.relationType = [userDic objectForKey:@"relationType"];
                            //entity.ownerUid = [userDic objectForKey:@"ownerUid"];
                            entity.jId = [tvDic objectForKey:@"tvJid"];
                            //entity.jIdAddr = [tvDic objectForKey:@"jIdAddr"];
                            // entity.serviceAddr = [tvDic objectForKey:@"serviceAddr"];
                            entity.tvName = [tvDic objectForKey:@"tvName"];
                            entity.state = [tvDic objectForKey:@"state"];
                            entity.userId = [tvDic objectForKey:@"tvUid"];
                            entity.deviceID = [tvDic objectForKey:@"tvUid"];
                            entity.tvUid = [tvDic objectForKey:@"tvUid"];
                            
                            NSString *ownerUid = [userDic objectForKey:@"ownerUid"];
                           // NSString *uid = [HiTVGlobals sharedInstance].uid;

                            entity.ownerUid = [NSString stringWithFormat:@"%@%@",ownerUid,[tvDic objectForKey:@"tvJid"]];
                            entity.ownerUserId = [userDic objectForKey:@"ownerUid"];
                           // if (!([ownerUid intValue] ==[uid intValue]&& [entity.state isEqualToString:@"UNTOGETHER_OFFLINE"])) {
                                if (tvList.count>1) {
                                    entity.tvName = [NSString stringWithFormat:@"%@的家%d",entity.nickName,n+1];
                                }
                                else{
                                    entity.tvName = [NSString stringWithFormat:@"%@的家",entity.nickName];
                                }
                                [tvArray addObject:entity];
                            //}
                            if ([entity.ownerUid isEqualToString:self.connectedDevice.ownerUid]) {
                                connectTv = YES;
                            }
                        }
                    }
                    
                }
                for (HiTVDeviceInfo *entity in tvArray) {
                    DDLogInfo(@"----%@-----",entity.ownerUid);
                }
                if (!connectTv) {
                    self.connectedDevice = nil;
                }
            }
            
            self.mutableDetectedDevices = tvArray;
            [self setDefaultDevice];
                      
            handler(tvArray,nil);

            if (self.deviceDetectedBlock) {
                self.deviceDetectedBlock();
            }
        }
    } failure:^(NSString *error) {
        handler(nil,error);
    }];
}
-(void)setDefaultDevice{
    //if (!self.connectedDevice) {
    NSString *uid = [NSString stringWithFormat:@"%d",[HiTVGlobals sharedInstance].uid.intValue];
        if (self.connectedDevice.IsConnected) {
            return;
        }
        else if (self.mutableDetectedDevices.count==1) {
            HiTVDeviceInfo *deviceEntity = [self.mutableDetectedDevices objectAtIndex:0];
            self.connectedDevice = deviceEntity;
        }
        else if (self.mutableDetectedDevices.count==0) {
            self.connectedDevice = nil;
        }
        else{
            NSString *ownerUid = [NSUserDefaultsManager getObjectForKey:uid];
            for (HiTVDeviceInfo *deviceEntity in self.mutableDetectedDevices) {
                if ([deviceEntity.ownerUid isEqualToString:ownerUid]) {
                    self.connectedDevice = deviceEntity;
                    return;
                }
            }
            for (HiTVDeviceInfo *deviceEntity in self.mutableDetectedDevices) {
                if ([deviceEntity.userId isEqualToString:self.connectedDevice.userId]) {
                    self.connectedDevice = deviceEntity;
                    return;
                }
            }

            for (HiTVDeviceInfo *deviceEntity in self.mutableDetectedDevices) {
                if ([deviceEntity.relationType isEqualToString:@"DEFAULTUSER"]/*&&([deviceEntity.state isEqualToString:TOGETHER_SAME_NET]||[deviceEntity.state isEqualToString:TOGETHER_DIFF_NET])*/) {
                    self.connectedDevice = deviceEntity;
                    return;
                }
            }
            for (HiTVDeviceInfo *deviceEntity in self.mutableDetectedDevices) {
                /*if ([deviceEntity.state isEqualToString:TOGETHER_SAME_NET]||[deviceEntity.state isEqualToString:TOGETHER_DIFF_NET]) {
                    self.connectedDevice = deviceEntity;
                    return;
                }*/
                self.connectedDevice = deviceEntity;
                return;
            }
            
            for (HiTVDeviceInfo *deviceEntity in self.mutableDetectedDevices) {
                 if ([deviceEntity.relationType isEqualToString:@"DEFAULTUSER"]) {
                    self.connectedDevice = deviceEntity;
                     return;
                }
            }
        }
}
/**
 * 解除关联关系
 */
-(void)removeDeviceDetectionRequest:(NSString *)uid completion:(void(^)(id responseObject,NSString *error))handler{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:uid forKey:@"tvAnonymousUid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"phoneUid"];
    [parameters setObject:BIMS_DOMAIN forKey:@"phoneArea"];
    [parameters setObject:BIMS_DOMAIN forKey:@"tvArea"];

    [MsProtocol removeRelationRequest:parameters completion:^(id responseObject) {
        handler(responseObject,nil);
    } failure:^(NSString *error) {
        handler(nil,error);
    }];
}

- (void)getDistrustTvsMethod
{
    NSString *netWorkState = [Utils getNetWorkStates];
    if ([netWorkState isEqualToString:@"WIFI"]) {
        [self getDistrustTvs];
    }
}
/**
 * 手机获取疑似电视列表接口
 */
-(void)getDistrustTvs{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"phoneUid"];
    [parameters setObject:BIMS_DOMAIN forKey:@"area"];
    [parameters setObject:self.version forKey:@"version"];

    [MsProtocol getDistrustTvsRequest:parameters completion:^(id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            NSMutableArray *tvs = [NSMutableArray array];
            for (NSDictionary *dic in resultDic[@"distrustTvs"]) {
                HiTVDeviceInfo *deviceEntity = [[HiTVDeviceInfo alloc]init];
                deviceEntity.deviceID = dic[@"tvUid"];
                deviceEntity.insideIp = dic[@"insideIp"];
                deviceEntity.outsideOutIp = dic[@"outsideOutIp"];
                [tvs addObject:deviceEntity];
                [[TogetherManager sharedInstance] sendMsg:deviceEntity];
            }
            self.distrustTvs = tvs;
            [[TogetherManager sharedInstance]confirmTvs];
        }
    } failure:^(NSString *error) {
        
    }];
}
-(void)confirmTvNetTVS:(NSArray *)tvUids identityNet:(NSString *)identityNet completion:(void(^)(id responseObject,NSString *error))handler{
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"phoneUid"];
    [parameters setValue:identityNet forKey:@"identityNet"];
    NSString *tvUidString = [tvUids componentsJoinedByString:@","];
    [parameters setValue:tvUidString forKey:@"tvUids"];
    NSString *reportString = [[HiTVGlobals sharedInstance].tvAnonymousUidArray componentsJoinedByString:@","];
    [parameters setValue:reportString forKey:@"reportUids"];
    [parameters setObject:BIMS_DOMAIN forKey:@"area"];


    [MsProtocol confirmTvNet:parameters completion:^(id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            [self setRemoteStatus];
        }
        else{
            handler(nil,[resultDic objectForKey:@"message"]);
        }
    } failure:^(NSString *error) {
        handler(nil,error);
        
    }];
}
-(void)getRoomNums:(NSString *)roomId completion:(void(^)(RoomNumEntity *roomEntity,NSString *error))handler{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:roomId forKey:@"roomId"];

    [MsProtocol getRoomNumsRequest:parameters completion:^(id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            RoomNumEntity *entity = [[RoomNumEntity alloc]init];
            entity.roomId = resultDic[@"roomId"];
            entity.onlineNum = resultDic[@"onlineNum"];
            handler(entity,nil);
        }
        else{
            handler(nil,[resultDic objectForKey:@"message"]);
        }
    } failure:^(NSString *error) {
        handler(nil,error);

    }];
}

-(void)setRemoteStatus{
    [self getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
        
        if (error) {
            [AppDelegate appDelegate].appdelegateService.isConnect = NO;
        }
        else{
            
            if (_resumeViewModel == nil) {
                _resumeViewModel = [[SJResumeVideoViewModel alloc] init];
                if (devices.count > 0) {
                    
                    [_resumeViewModel start];
                }
            
            }
            HiTVDeviceInfo *deviceEntity = [TogetherManager sharedInstance].connectedDevice;
            if ([deviceEntity.state isEqualToString:@"TOGETHER_SAME_NET"]||[deviceEntity.state isEqualToString:@"TOGETHER_DIFF_NET"]) {
                if (![AppDelegate appDelegate].appdelegateService.isConnect) {
                    [AppDelegate appDelegate].appdelegateService.isConnect = YES;
                }
            }
            else{
                if ([AppDelegate appDelegate].appdelegateService.isConnect) {
                    [AppDelegate appDelegate].appdelegateService.isConnect = NO;
                    
                }
            }
        }
    }];
}
-(NSString *)version{
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"mc-version64"]) {
        _version = version63;
    }
    else{
        _version = version64;
    }
    return _version;
}

-(NSMutableArray *)distrustTvArray{
    if (!_distrustTvArray) {
        _distrustTvArray = [NSMutableArray array];
    }
    return _distrustTvArray;
}

// remove from HiTVListenerManager
-(void)confirmTvs{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        NSMutableArray  *tvIds = [NSMutableArray array];
        for (HiTVDeviceInfo *deviceEntity in [TogetherManager sharedInstance].distrustTvs) {
            for (NSString *deviceID in self.distrustTvArray) {
                if ([deviceEntity.deviceID isEqualToString:deviceID]) {
                    [tvIds addObject:deviceID];
                }
            }
        }
        if (tvIds.count>0) {
            [[TogetherManager sharedInstance] confirmTvNetTVS:tvIds identityNet:@"notSameNet" completion:^(id responseObject,NSString *error){
                
            }];
        }
    });
}

-(void)sendMsg:(HiTVDeviceInfo *)phoneInfo{
    NSString *host = phoneInfo.insideIp;
    
    HiTViSLanMessage* message = [[HiTViSLanMessage alloc] init];
    [message writeStringValue:phoneInfo.deviceID];
    for (int i = 0; i<10; i++) {
        [self p_sendDataTo:host
                  withPort:5002
                andMessage:message];
    }
    
    [self.distrustTvArray addObject:phoneInfo.deviceID];
    
}
- (void)p_sendDataTo:(NSString*)ip withPort:(NSUInteger)port andMessage:(HiTViSLanMessage*)message{
    NSData* data = [message makeData];
    [mgServer sendMsg:data andHost:ip];
}

@end
