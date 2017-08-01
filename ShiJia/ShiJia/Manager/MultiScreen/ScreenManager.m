//
//  ScreenManager.m
//  HiTV
//
//  Created by cs090_jzb on 15/8/17.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "ScreenManager.h"
#import "MsProtocol.h"
#import "ScreenDeviceInfo.h"
#import "DeviceChooseView.h"
#import "HiTVWebServer.h"
#import "GTMBase64.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "TSLibraryImport.h"
#import "YYCache.h"
#import "TPIMContentModel.h"
#import "TPIMNodeModel.h"
#import "HiTVGlobals.h"
#import "TogetherManager.h"
#import "UpYun.h"
#import "SJLocailFileResponseModel.h"
#import "TogetherManager.h"

//NSString * const TPIMNotification_ReceiveMessage_Type10 = @"TPIMNotification_ReceiveMessage_Type10";// 投屏反馈消息

//#define TEST_UID @"10000376"
#define FILE_MAX (10*1024*1024)


@interface ScreenManager ()<DeviceChooseViewDelegate>
{
    MBProgressHUD *HUD;
    ScreenDeviceInfo *tempDeviceInfo;
    
    ScreenDeviceInfo *DeviceInfo;
    
    NSTimer *verTimer;
    UIAlertView *alert;
}
@property (nonatomic, strong) NSMutableArray* mutableScreenDevices;
@property (nonatomic, strong) NSString *upoadUrl;

@property (nonatomic, copy) ScreenManagerDeviceDetectedBlock screenDetectedBlock;

@property (nonatomic, copy) ScreenManagerLacalRemoteBlock remoteBlock;
@property (nonatomic, copy) ScreenManagerLacalRemoteBlock failedBlock;
//本地资源
//@property (nonatomic, strong) LocalSourceModel *sourceModel;
//如果是网络url需要传sourcetype
@property (nonatomic, assign) SouceType sourceType;
//直播和点播时需要
@property (nonatomic, retain) TPIMContentModel *contentModel;


@property (nonatomic, strong) id upLoadFileParams;

/**
 *  added by yy 缓存
 */
@property (nonatomic, retain) YYCache *cache;
@property (nonatomic, assign) BOOL screenDanmu;

@property (nonatomic, strong) NSString *stamp; //时间戳

/**
 * 获取投屏信息接口
 */
-(void)getScreenDeviceDetectionRequest;

/**
 * 用户自定义文件上传接口
 文件类型;view:视屏，picture:图片,audio：音频
 filepath:文件路径
 */
//- (void)userUploadScreenFileRequest:(NSString *)fileType fileData:(NSData *)fileData;


@end

@implementation ScreenManager
+ (instancetype)sharedInstance{
    static ScreenManager *sharedObject = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        sharedObject.cache = [[YYCache alloc] initWithName:@"ScreenCache"];
    });
    
    return sharedObject;
}
/*- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [[YYCache alloc] initWithName:@"ScreenCache"];
        //监听被下线消息
    }
    return self;
}*/

-(void)remoteNetVideoWithContentModel:(TPIMContentModel *)conentModel
{
    [self setContentModel:conentModel];
    self.screenDanmu = NO;
    if ([conentModel.playerType isEqualToString:@"danmu"]) {
        self.screenDanmu = YES;
    }
    if ([TogetherManager sharedInstance].connectedDevice) {
        HiTVDeviceInfo *deviceEntity = [TogetherManager sharedInstance].connectedDevice;
        ScreenDeviceInfo *entity = [[ScreenDeviceInfo alloc]init];
        entity.tvAnonymousUid = deviceEntity.deviceID;
        entity.intranetIp = deviceEntity.ip;
        entity.jId = deviceEntity.jId;
        entity.jidAddr = deviceEntity.jIdAddr;
        entity.tvName = deviceEntity.tvName;
        entity.state = deviceEntity.state;
        tempDeviceInfo = entity;
        [self connectScreenDevice:tempDeviceInfo];
    }
    else{
        [self getScreenDeviceDetectionRequest];
       /* if (!self.screenDanmu) {
            if ([self.contentModel.action isEqualToString:@"play"]) {
                // [MBProgressHUD show:@"投屏失败" icon:@"img_failed" view:nil];
                [MBProgressHUD show:@"亲，没有关联设备，请添加" icon:nil view:nil];
                
            }
        }*/
    }
}
-(void)remoteControlContentModel:(TPIMContentModel *)conentModel
{
    
    HiTVDeviceInfo* connectedDevice = [TogetherManager sharedInstance].connectedDevice;
    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    
    //from
    TPIMNodeModel *from = [[TPIMNodeModel alloc] init];
    from.uid = [NSString stringWithFormat:@"%@",[HiTVGlobals sharedInstance].uid];
    from.nickname = [HiTVGlobals sharedInstance].nickName;
    from.jid = [HiTVGlobals sharedInstance].xmppUserId;
    message.from = from;
    
    //to
    NSMutableArray *to = [[NSMutableArray alloc] init];
    TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
    node.uid = connectedDevice.deviceID;
    node.nickname = connectedDevice.tvName;
    node.jid = connectedDevice.jId;
    [to addObject:node];
    message.to = [NSArray arrayWithArray:to];
    
    
    message.type = @"13";
    message.contentModel = conentModel;
    message.sentMethod = kTPMessageSentMethod_ByXmpp;
    
    
    [TPIMMessageModel sendMessage:message completionHandler:^(id responseObject, NSError *error) {
        
    }];
}
- (void)remoteChatRoomVideoWithContentModel:(TPIMContentModel *)contentModel
{
    self.screenDanmu = YES;
    [self setContentModel:contentModel];
    if (tempDeviceInfo) {
        if ([tempDeviceInfo.state isEqualToString:TOGETHER_SAME_NET] ) {
            [self sendMessageToDevice:tempDeviceInfo withUrl:nil sendtype:self.sourceType];
        }
        else{
            if ([contentModel.playerType isEqualToString:@"onDemand"] || [contentModel.playerType isEqualToString:@"danmu"]) {
                [self sendMessageToDevice:tempDeviceInfo withUrl:nil sendtype:self.sourceType];
            }
        }
    }
    else{
        [self getScreenDeviceDetectionRequest];
    }
}

- (void)sendMessageToDevice:(ScreenDeviceInfo *)deviceInfo withUrl:(NSString *)url sendtype:(SouceType)sourceType
{
    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    
    //from
    TPIMNodeModel *from = [[TPIMNodeModel alloc] init];
    from.uid = [NSString stringWithFormat:@"%@",[HiTVGlobals sharedInstance].uid];
    from.nickname = [HiTVGlobals sharedInstance].nickName;
    from.jid = [HiTVGlobals sharedInstance].xmppUserId;
    message.from = from;
    
    //to
    NSMutableArray *to = [[NSMutableArray alloc] init];
    TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
    node.uid = deviceInfo.tvAnonymousUid;
    node.nickname = deviceInfo.tvName;
    node.jid = deviceInfo.jId;
    [to addObject:node];
    message.to = [NSArray arrayWithArray:to];
    
    message.type = @"9";
    TPIMContentModel *content = [[TPIMContentModel alloc]init];
    if (url.length > 0) {
        content.stype = @"";
        content.faceImg = @"";
        content.content = @"";
        content.action = @"play";
        content.url = url;
        switch (sourceType) {
            case Photo:
            {
                content.playerType = @"photo";
                content.content = @"本地文件投屏（图片投屏）";
            }
                break;
            case Audio:
            {
                content.playerType = @"music";
                content.startTime = @"0";
                content.content = @"本地文件投屏（音乐投屏）";
            }
                break;
            case Video:
            {
                content.playerType = @"video";
                content.content = @"本地文件投屏（视频投屏）";
            }
            default:
                break;
        }
        
    }
    else {
        if (self.contentModel) {
            //弹幕投屏
            if ([self.contentModel.playerType isEqualToString:@"danmu"]) {
            }
            content = self.contentModel;
            
            //点播、看点是否显示弹幕 --added by yy 2015.12.02
            //|| [content.playerType isEqualToString:@"channel"]
            if ([content.playerType isEqualToString:@"onDemand"] || [content.playerType isEqualToString:@"watchTV"]) {
                content.haveDanmu = self.contentModel.haveDanmu;
                if (content.haveDanmu.length == 0) {
                    content.haveDanmu = @"false";
                }
            }
            
        }
        
    }
    if ([deviceInfo.state isEqualToString:TOGETHER_SAME_NET]||[deviceInfo.state isEqualToString:TOGETHER_DIFF_NET]) {
        content.stype = @"1";
    }
    else{
        content.stype = @"2";
    }
    self.state = deviceInfo.state;

    NSString *netWorkState = [Utils getNetWorkStates];
    if (![netWorkState isEqualToString:@"WIFI"]) {
       // content.stype = @"2";
    }
    content.faceImg = [[HiTVGlobals sharedInstance]faceImg];
    content.nickName = [HiTVGlobals sharedInstance].nickName;
    content.stamp = [Utils nowTimeString];
    message.contentModel = content;
    message.sentMethod = kTPMessageSentMethod_ByXmpp;
    if ([content.action isEqualToString:@"play"]) {
        self.stamp = message.contentModel.stamp;
    }

    
    [TPIMMessageModel sendMessage:message completionHandler:^(id responseObject, NSError *error) {
        DDLogInfo(@"%@",responseObject);
        if (content.showToast) {
            
            [self showAllTextDialog:[NSString stringWithFormat:@"已投屏到%@上",deviceInfo.tvName]];
        }
    }];
}


- (void)reset {
    tempDeviceInfo = nil;
}

#pragma mark - DeviceChooseViewDelegate  选择设备
- (void)connectScreenDevice:(ScreenDeviceInfo *)device{
    //记录上次链接的设备
    tempDeviceInfo = device;
    //监听投屏回执操作
    [self listenerScreenBackBlock];
    
    [self sendMessageToDevice:device withUrl:nil sendtype:self.sourceType];

}

/**
 * 获取投屏信息接口
 */
-(void)getScreenDeviceDetectionRequest{
    DeviceInfo =[ScreenDeviceInfo new];
    [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
        BOOL succuss = NO;
        NSArray *devicesArray = devices;
        if (devicesArray.count==1) {
            HiTVDeviceInfo *deviceEntity = [devicesArray objectAtIndex:0];
            ScreenDeviceInfo *entity = [[ScreenDeviceInfo alloc]init];
            entity.tvAnonymousUid = deviceEntity.deviceID;
            entity.intranetIp = deviceEntity.ip;
            entity.jId = deviceEntity.jId;
            entity.jidAddr = deviceEntity.jIdAddr;
            entity.tvName = deviceEntity.tvName;
            entity.state = deviceEntity.state;
            [TogetherManager sharedInstance].connectedDevice = deviceEntity;
            [self connectScreenDevice:entity];
            
            succuss = YES ;
        }
        else{
            for (HiTVDeviceInfo *deviceEntity in devicesArray) {
                if ([deviceEntity.userId isEqualToString:[TogetherManager sharedInstance].connectedDevice.userId]) {
                    ScreenDeviceInfo *entity = [[ScreenDeviceInfo alloc]init];
                    entity.tvAnonymousUid = deviceEntity.deviceID;
                    entity.intranetIp = deviceEntity.ip;
                    entity.jId = deviceEntity.jId;
                    entity.jidAddr = deviceEntity.jIdAddr;
                    entity.tvName = deviceEntity.tvName;
                    entity.state = deviceEntity.state;
                    [TogetherManager sharedInstance].connectedDevice = deviceEntity;
                    [self connectScreenDevice:entity];
                    succuss = YES ;
                }
            }
            for (HiTVDeviceInfo *deviceEntity in devicesArray) {
                if ([deviceEntity.relationType isEqualToString:@"DEFAULTUSER"]) {
                    ScreenDeviceInfo *entity = [[ScreenDeviceInfo alloc]init];
                    entity.tvAnonymousUid = deviceEntity.userId;
                    entity.intranetIp = deviceEntity.ip;
                    entity.jId = deviceEntity.jId;
                    entity.jidAddr = deviceEntity.jIdAddr;
                    entity.tvName = deviceEntity.tvName;
                    entity.state = deviceEntity.state;
                    [TogetherManager sharedInstance].connectedDevice = deviceEntity;
                    [self connectScreenDevice:entity];
                    succuss = YES ;
                }
            }
        }
        
        if (succuss) {
            if (!self.screenDanmu) {
              //  [MBProgressHUD show:@"投屏成功" icon:@"img_success" view:nil];
            }
            
        }
        else{
            if (!self.screenDanmu) {
                if ([self.contentModel.action isEqualToString:@"play"]) {
                   // [MBProgressHUD show:@"投屏失败" icon:@"img_failed" view:nil];
#if BeiJing
                    self.screenManagerBlock(NO,@"-1");

#else
                    self.screenManagerBlock(NO,@"-1");
                    //[MBProgressHUD show:@"亲，没有关联设备，请添加" icon:nil view:nil];
                    
#endif
                }
            }
            if (self.failedBlock) {
                self.failedBlock();
            }
        }
        
    }];
}

#pragma mark - MBProgressHUD
-(void)showAllTextDialog:(NSString *)str
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    HUD.labelText = str;
    HUD.mode = MBProgressHUDModeText;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
    
}

-(void)remoteLoacalFileWith:(TPIMContentModel *)contentModel andType:(SouceType)sourceType{
    
    [self setContentModel:contentModel];
    HiTVDeviceInfo *deviceEntity =[TogetherManager sharedInstance].connectedDevice;
    ScreenDeviceInfo *entity = [[ScreenDeviceInfo alloc]init];
    entity.tvAnonymousUid = deviceEntity.userId;
    entity.intranetIp = deviceEntity.ip;
    entity.jId = deviceEntity.jId;
    entity.jidAddr = deviceEntity.jIdAddr;
    entity.tvName = deviceEntity.tvName;
    entity.state = deviceEntity.state;
    DeviceInfo = entity;
    if (deviceEntity) {
        //监听投屏回执操作
        [self listenerScreenBackBlock];
        
        [self sendLoacalFileScreenMessageToDevice:DeviceInfo
                                        withXMPPModel:contentModel
                                             sendtype:sourceType];
    }else{        
        if (_remoteLoacalFileBlock) {
            self.remoteLoacalFileBlock(NO);
        }
    }
    
}

- (void)sendLoacalFileScreenMessageToDevice:(ScreenDeviceInfo *)deviceInfo
                              withXMPPModel:(TPIMContentModel *)contentModel
                                   sendtype:(SouceType)sourceType{
    
    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    
    //from
    TPIMNodeModel *from = [[TPIMNodeModel alloc] init];
    from.uid = [NSString stringWithFormat:@"%@",[HiTVGlobals sharedInstance].uid];
    from.nickname = [HiTVGlobals sharedInstance].nickName;
    from.jid = [HiTVGlobals sharedInstance].xmppUserId;
    message.from = from;
    
    //to
    NSMutableArray *to = [[NSMutableArray alloc] init];
    TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
    node.uid = deviceInfo.tvAnonymousUid;
    node.nickname = deviceInfo.tvName;
    node.jid = deviceInfo.jId;
    [to addObject:node];
    message.to = [NSArray arrayWithArray:to];
    
    message.type = @"9";
    
    TPIMContentModel *content = contentModel;
    
    if (sourceType==Video) {
        content.content = @"本地文件投屏（视频投屏）";
    }
    
    if (sourceType==Photo) {
         content.content = @"本地文件投屏（图片投屏）";
    }
    if ([deviceInfo.state isEqualToString:TOGETHER_SAME_NET]||[deviceInfo.state isEqualToString:TOGETHER_DIFF_NET]) {
        content.stype = @"1";
        
    }else{
        content.stype = @"2";
    }
    self.state = deviceInfo.state;
    content.faceImg = [[HiTVGlobals sharedInstance]faceImg];
    content.nickName = [HiTVGlobals sharedInstance].nickName;
    content.stamp = [Utils nowTimeString];
    message.contentModel = content;
    message.sentMethod = kTPMessageSentMethod_ByXmpp;
    if ([content.action isEqualToString:@"play"]) {
        self.stamp = message.contentModel.stamp;
    }
    
    [TPIMMessageModel sendMessage:message completionHandler:^(id responseObject, NSError *error) {
        
        if (error) {
            if (self.remoteLoacalFileBlock) {
                self.remoteLoacalFileBlock(NO);
            }
        }else{
            if (self.remoteLoacalFileBlock) {
                self.remoteLoacalFileBlock(YES);
            }
        }
    }];
}
#pragma mark - 监听投屏回执
-(void)listenerScreenBackBlock{
    
    if (!self.screenDanmu) {
        
        if ([self.contentModel.action isEqualToString:@"play"]) {
            verTimer = [NSTimer scheduledTimerWithTimeInterval:SCREENDELAY target:self selector:@selector(verUpdate) userInfo:nil repeats:NO];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showMessag:@"正在连接电视..." toView:nil];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenFeedback:) name:TPIMNotification_ReceiveMessage_Type10 object:nil];
    }
}
-(void)verUpdate{
    
    [self closeTimer];
   // [MBProgressHUD show:@"投屏失败，请确认默认关联的家庭电视是否在线！" icon:nil view:nil];
    //[OMGToast showWithText:@"投屏失败，请确认默认关联的家庭电视是否在线！"duration:3];
    
    alert = [[UIAlertView alloc]initWithTitle:@"" message:@"投屏失败，请确认默认关联的家庭电视是否在线！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];

    [alert show];

}
-(void)performDismiss:(NSTimer *)timer
{
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}
-(void)closeTimer{
    [verTimer invalidate];
    verTimer = nil;
    [MBProgressHUD hideHUD];
}
#pragma mark - 投屏回执回调
//收到xmpp消息
- (void)screenFeedback:(NSNotification *)notification
{
    [self closeTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TPIMNotification_ReceiveMessage_Type10
                                                  object:nil];
    if (!self.screenDanmu) {
        TPIMMessageModel *msgmodel = [notification.userInfo valueForKey:TPIMNotification_MessageKey];
        NSString *content = msgmodel.contentModel.stamp;
        if ([content isEqualToString:self.stamp]) {
            if ([msgmodel.contentModel.action isEqualToString:@"accept"]) {
                if ([self.contentModel.action isEqualToString:@"play"]) {
                    if (self.screenManagerBlock) {
                        self.screenManagerBlock(YES,nil);
                    }
                }
               
                //NSString* content = [NSString stringWithFormat:[[NSUserDefaults standardUserDefaults] objectForKey:@"ScreenMappingContent"], 0];
                NSString* content = [NSUserDefaultsManager getObjectForKey:@"ScreenMappingContent"];

                [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:content];
                [MBProgressHUD show:@"投屏成功" icon:@"img_success" view:nil];
                [UMengManager event:@"U_ScreenMapping"];
            }
            else if ([msgmodel.contentModel.action isEqualToString:@"inject"]){
                if (self.screenManagerBlock) {
                    self.screenManagerBlock(NO,nil);
                }
                [MBProgressHUD show:@"电视拒绝了您的投屏" icon:nil view:nil];
                NSString* content = [NSString stringWithFormat:[[NSUserDefaults standardUserDefaults] objectForKey:@"ScreenMappingContent"], -1];
                [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:content];

            }
            else if ([msgmodel.contentModel.action isEqualToString:@"exit"]||[msgmodel.contentModel.action isEqualToString:@"stop"])
            {
                if (self.screenManagerBlock) {
                    self.screenManagerBlock(NO,msgmodel.contentModel.time);
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenFeedback:) name:TPIMNotification_ReceiveMessage_Type10 object:nil];
    
}
@end
