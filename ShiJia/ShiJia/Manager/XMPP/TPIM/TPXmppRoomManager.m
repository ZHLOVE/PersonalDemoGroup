//
//  TPXmppRoomManager.m
//  HiTV
//
//  Created by yy on 15/11/9.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPXmppRoomManager.h"
#import "XMPPRoom.h"
#import "TPIMGroup.h"
#import "TPIMUser.h"
#import "TPIMMessage.h"
#import "TPIMContentModel.h"
#import "AppDelegate.h"
#import "UIWindow+PazLabs.h"
//#import "YYCache.h"
#import "TPDanmakuData.h"
#import "TogetherManager.h"
#import "TVProgram.h"
#import "TVStation.h"
#import "TPIMNodeModel.h"
#import "TPMessageRequest.h"
#import "TPFileOperation.h"
#import "AES128Util.h"
#import "NSString+Conversion.h"

#import "HiTVVideo.h"
#import "VideoSource.h"
#import "UserEntity.h"
#import "WatchFocusVideoEntity.h"
#import "WatchFocusVideoProgramEntity.h"
#import "TVProgram.h"
#import "TVStation.h"
#import "WatchListEntity.h"

#import "SJMultiVideoDetailViewController.h"
#import "SJMessageCenterViewController.h"
#import "WatchListViewController.h"
#import "VideoHomeViewController.h"
#import "ChannelViewController.h"
#import "SJMyViewController.h"
#import "UIViewController+Autorotate.h"
#import "MainViewController.h"

NSString * const RoomMemberChangedNotification       = @"RoomMemberChangedNotification";
NSString * const RoomMessageReceivedNotification     = @"RoomMessageReceivedNotification";
NSString * const RoomMessageModelKey                 = @"RoomMessageModelKey";
NSString * const RoomDanmuMessageModelKey            = @"RoomDanmuMessageModelKey";
NSString * const RoomOccupantInfoChangedNotification = @"RoomOccupantInfoChangedNotification";
NSString * const RoomOccupantModelKey                = @"RoomOccupantModelKey";

@interface TPXmppRoomManager ()
{
    BOOL createdRoom;
    BOOL finishInvited;
}
@property (nonatomic, assign, readwrite) BOOL isInChatRoom;
@property (nonatomic, strong) YYCache *cache;
//@property (nonatomic, strong, readwrite) NSMutableArray *roomMemberList;
@property (nonatomic, assign, readwrite) BOOL showMinimumVideoView;
@property (nonatomic, strong, readwrite) NSString *roomId;//roomid(注：始终为最新房间id)
@property (nonatomic, strong) NSString *oldRoomId;
@property (nonatomic, strong) XMPPRoom *oldRoom;

@end

@implementation TPXmppRoomManager

#pragma mark - init
+ (TPXmppRoomManager *)defaultManager
{
    static TPXmppRoomManager *instance = nil;
    static dispatch_once_t precidate;
    dispatch_once(&precidate, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.cache = [[YYCache alloc] initWithName:@"UserDataCache"];
        self.roomMemberList = [[NSMutableArray alloc] init];
        [self startObserving];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Message
//发送消息
- (void)sendMessage:(NSString *)msg
{
    //发消息
    TPIMContentMessage *message = [[TPIMContentMessage alloc] init];
    message.conversationType = kTPIMGroup;
    
    //设置消息内容
    TPIMContentModel *content = [[TPIMContentModel alloc] init];
    content.content = msg;
    content.icon = [HiTVGlobals sharedInstance].faceImg;
    content.from = [HiTVGlobals sharedInstance].nickName;
    content.uid = [HiTVGlobals sharedInstance].uid;
    content.fromphone = [HiTVGlobals sharedInstance].phoneNo;
    message.contentText = [content mj_JSONString];
    
    XMPPJID *jid = [XMPPJID jidWithString:self.roomId];
    message.targetId = [jid bare];
    
    [TPIMMessage sendMessage:message];
}

- (void)sendRecordData:(NSData *)recordData recordString:(NSString *)recordString recordDuration:(CGFloat)recordDuration
{
    if (recordData == nil) {
        return;
    }
    
    [TPMessageRequest uploadRecordFile:recordData completion:^(NSString *responseObject, NSError *error) {
        if (responseObject.length != 0) {
            //上传录音成功，发送xmpp消息
            [TPFileOperation removeVoiceMessage:@"record.wav"];
            TPIMVoiceMessage *msg = [[TPIMVoiceMessage alloc] init];
            msg.conversationType = kTPIMGroup;
            msg.resourcePath = responseObject;
            msg.voiceString = recordString;
            msg.duration = [NSString stringWithFormat:@"%.f",recordDuration];
            msg.targetId = self.roomId;
            [TPIMMessage sendMessage:msg];
        }
    }];
    
}

- (void)sendFollowFriendMessage
{
    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    
    //保存消息标志位
    message.ext = @"1";
    if ([self.stype isEqualToString:@"noti"]||[self.stype isEqualToString:@"miao"]) {
        message.ext = @"0";
    }
    //to array
    NSMutableArray *to = [[NSMutableArray alloc] init];
    for (UserEntity *model in self.invitedUserList) {
        TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
        node.jid = model.jid;
        node.uid = model.uid;
        node.nickname = model.name.length > 0 ? model.name : model.nickName;
        if (node.nickname.length == 0) {
            node.nickname = model.name;
        }
        [to addObject:node];
    }
    message.to = [NSArray arrayWithArray:to];
    
    //消息类型，7--约片消息
    message.type = @"7";
    
    
    //content Model
    TPIMContentModel *content = [[TPIMContentModel alloc] init];
    content.faceImg = [HiTVGlobals sharedInstance].faceImg;
    content.content = [NSString stringWithFormat:@"%@想加入和你一起看",[HiTVGlobals sharedInstance].nickName];
    message.title = [NSString stringWithFormat:@"%@想加入和你一起看",[HiTVGlobals sharedInstance].nickName];

    content.contents = content.content;
    message.summary = message.title;
    content.stype = self.stype;
    //消息发送方式
    message.sentMethod = kTPMessageSentMethod_ByHttp;
    message.contentModel = content;

    //发送消息
    [TPIMMessageModel sendMessage:message completionHandler:^(id responseObject, NSError *error) {
        self.stype = nil;
        //[MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
       // [OMGToast showWithText:@"发送邀请成功"];
        if (self.didFinishInvitation) {
            self.didFinishInvitation();
        }
    }];
    [UMengManager event:@"U_Appoint"];
}

//发送邀请消息
- (void)sendInvitationMessageWithRoomId:(NSString *)roomId
{
    
    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    
    //保存消息标志位
    message.ext = @"1";
    if ([self.stype isEqualToString:@"noti"]||[self.stype isEqualToString:@"miao"]) {
        message.ext = @"0";
    }
    //to array
    NSMutableArray *to = [[NSMutableArray alloc] init];
    for (UserEntity *model in self.invitedUserList) {
        TPIMNodeModel *node = [[TPIMNodeModel alloc] init];
        node.jid = model.jid;
        node.uid = model.uid;
        node.nickname = model.name.length > 0 ? model.name : model.nickName;
        if (node.nickname.length == 0) {
            node.nickname = model.name;
        }
        [to addObject:node];
    }
    message.to = [NSArray arrayWithArray:to];
    
    //消息类型，7--约片消息
    message.type = @"7";
    
    
    //content Model
    TPIMContentModel *content = [[TPIMContentModel alloc] init];
    content.faceImg = [HiTVGlobals sharedInstance].faceImg;
    switch (self.videoType) {
            // 点播
        case TPChatRoomVideoTypeVOD:
        {
            
            content.url = self.videoSource.actionURL;
            content.videoType = @"vod";
            content.thumPath = self.video.picurl;
            content.pId = self.video.videoID;
            content.programId = self.videoSource.sourceID;
            content.programSeriesId = self.video.videoID;
            content.programName = self.videoSource.name;
            content.directors = self.video.director;
            content.actors = self.video.actor;
            message.title = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.videoSource.name];
            //content.content = [NSString stringWithFormat:@"<font color='#e6e6e6'>%@ 约你一起看</font> <font color='#005d70'>《%@》</font> <font color='#e6e6e6'>,要不要马上就约起来，一起边看边聊呢？</font>",[HiTVGlobals sharedInstance].nickName,self.videoSource.name];
            content.content = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.videoSource.name];

            
            
        }
            break;
            // 看点
        case TPChatRoomVideoTypeWatchTV:
        {
            
            content.url = [self encodeActionUrl:self.watchProgramEntity.programUrl];
            content.videoType = @"watchtv";
            content.thumPath = self.watchEntity.img;
            content.pId = self.watchEntity.catgId.description;
            content.programSeriesId = self.watchEntity.catgId.description;
            content.programName = self.watchProgramEntity.programName;
            content.programId = self.watchProgramEntity.programId;
            content.directors = self.watchEntity.director;
            content.startTime = [NSString stringWithFormat:@"%lld",self.watchProgramEntity.startTime];
            content.endTime = [NSString stringWithFormat:@"%lld",self.watchProgramEntity.endTime];
            message.title = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.watchProgramEntity.programName];
            //content.content = [NSString stringWithFormat:@"<font color='#e6e6e6'>%@ 约你一起看</font> <font color='#005d70'>《%@》</font> <font color='#e6e6e6'>,要不要马上就约起来，一起边看边聊呢？</font>",[HiTVGlobals sharedInstance].nickName,self.watchProgramEntity.programName];
            content.content = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.watchProgramEntity.programName];

        }
            break;
        case TPChatRoomVideoTypeLive:
        {
            content.url = self.tvProgram.programUrl;
            content.videoType = @"live";
            content.pId = self.tvStation.uuid;
            content.programId = [NSString stringWithFormat:@"%.f",self.tvProgram.programId];
            content.programSeriesId = self.tvStation.uuid;
            content.programName = self.tvProgram.programName;
            content.channelUuid = self.tvStation.uuid;
            content.uuId = self.tvStation.uuid;
            content.startTime = self.tvProgram.startTime;
            content.endTime = self.tvProgram.endTime;
            content.channelLogo = self.tvStation.logo;
            content.channelName = self.tvStation.channelName;
            content.thumPath = self.tvProgram.hPosterAddr.length == 0 ? self.tvProgram.vPosterAddr:self.tvProgram.hPosterAddr;
            message.title = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];
            //content.content = [NSString stringWithFormat:@"<font color='#e6e6e6'>%@ 约你一起看</font> <font color='#005d70'>《%@》</font> <font color='#e6e6e6'>,要不要马上就约起来，一起边看边聊呢？</font>",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];
            content.content = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];
            
        }
            break;
        case TPChatRoomVideoTypeReplay:
        {
            content.url = self.tvProgram.programUrl;
            content.videoType = @"replay";
            content.pId = self.tvStation.uuid;
            content.programId = [NSString stringWithFormat:@"%.f",self.tvProgram.programId];
            content.programSeriesId = self.tvStation.uuid;
            content.programName = self.tvProgram.programName;
            content.channelUuid = self.tvStation.uuid;
            content.uuId = self.tvStation.uuid;
            content.startTime = self.tvProgram.startTime;
            content.endTime = self.tvProgram.endTime;
            content.channelLogo = self.tvStation.logo;
            content.channelName = self.tvStation.channelName;
            content.thumPath = self.tvProgram.hPosterAddr.length == 0 ? self.tvProgram.vPosterAddr:self.tvProgram.hPosterAddr;
            message.title = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];
            //content.content = [NSString stringWithFormat:@"<font color='#e6e6e6'>%@ 约你一起看</font> <font color='#005d70'>《%@》</font> <font color='#e6e6e6'>,要不要马上就约起来，一起边看边聊呢？</font>",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];
            content.content = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.tvProgram.programName];

        }
            break;
            
        default:
            break;
    }
    
    
    content.contents = content.content;
    message.summary = message.title;
    content.datePoint = [NSString stringWithFormat:@"%.f",self.currentPlayedSeconds];
    content.roomId = roomId;
    content.stype = self.stype;

    //消息发送方式
    message.sentMethod = kTPMessageSentMethod_ByHttp;
    message.contentModel = content;
    
    //发送消息
    [TPIMMessageModel sendMessage:message completionHandler:^(id responseObject, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (![content.stype isEqualToString:@"miao"]) {
            [OMGToast showWithText:@"发送邀请成功"];
            self.stype = nil;
        }
        if (self.didFinishInvitation) {
            self.didFinishInvitation();
        }
    }];
    
    [UMengManager event:@"U_Appoint"];
}

//创建房间
- (void)createRoom
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if (!createdRoom) {
        
        //设置创建房间标志位为YES，避免重复创建房间
        createdRoom = YES;
        
        
        //从播放器进入邀请
        
        //1、创建xmpp房间/进入房间
        TPIMGroup *group = [[TPIMGroup alloc] init];
        group.groupName = [NSString generateUUID];
        
        [TPIMGroup createGroup:group completionHandler:^(id responseObject, NSError *error) {
            
            
            if (error == nil) {
                //创建房间成功
                if ([responseObject isKindOfClass:[XMPPRoom class]]) {
                    
                    //创建房间成功发送邀请消息
                    XMPPRoom *room = (XMPPRoom *)responseObject;
                    [[TPXmppRoomManager defaultManager] setCurrentRoom:room];
                    [self sendInvitationMessageWithRoomId:[room.roomJID bare]];
                    
                }
                else{
                    //创建房间失败
                }
                
            }
            else{
                //创建房间失败
            }
        }];
        
    }
    
}

- (void)sendInvitationMessageAndCreateRoom
{
    //[MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    if (!createdRoom) {
        
        //设置创建房间标志位为YES，避免重复创建房间
        createdRoom = YES;
        
        //1、创建xmpp房间/进入房间
        TPIMGroup *group = [[TPIMGroup alloc] init];
        group.groupName = [NSString generateUUID];
        group.isPublicGroup = NO;
        
        self.roomId = group.groupName;
        [TPIMGroup createGroup:group completionHandler:^(id responseObject, NSError *error) {
            
            if (error == nil) {
                //创建房间成功
                if ([responseObject isKindOfClass:[XMPPRoom class]]) {
                    
                    //创建房间成功发送邀请消息
                    XMPPRoom *room = (XMPPRoom *)responseObject;
                    self.roomId = room.roomJID.bare;
                    [[TPXmppRoomManager defaultManager] setCurrentRoom:room];
                    [self sendInvitationMessageWithRoomId:[room.roomJID bare]];
                    
                }
                else{
                    //创建房间失败
                }
                
            }
            else{
                //创建房间失败
            }
        }];
        
    }
}

#pragma mark - Room operation
//加入聊天室
- (void)joinRoom
{
    
    if (!self.invitedMessageModel || !self.currentRoom) {
        return;
    }
    
//    [[TogetherManager sharedInstance] getDeviceDetectionRequest];
//    [TogetherManager sharedInstance].deviceDetectedBlock = ^(){
//        self.deviceArray = [NSArray arrayWithArray:[TogetherManager sharedInstance].detectedDevices];
//    };
    TPIMUser *user = [[TPIMUser alloc] init];
    user.jid = [HiTVGlobals sharedInstance].xmppUserId;
    user.nickname = [HiTVGlobals sharedInstance].nickName;
    user.headImageUrl = [HiTVGlobals sharedInstance].faceImg;
    
    BOOL added = NO;
    for (TPIMUser *data in self.roomMemberList) {
        if ([data.jid isEqualToString:user.jid]) {
            added = YES;
        }
    }
    
    if (!added) {
        [self.roomMemberList addObject:user];
    }
    
    //直接进入聊天室
    [self pushChatRoomController];
    
}

//进入聊天室界面
- (void)pushChatRoomController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *activecontroller = [delegate.window visibleViewController];
    
    if ([activecontroller isKindOfClass:[SJMultiVideoDetailViewController class]]) {
        
        // 当前活动controller为详情页
        SJMultiVideoDetailViewController *videoDetailVC = (SJMultiVideoDetailViewController *)activecontroller;
        if ([self.invitedMessageModel.contentModel.videoType isEqualToString:@"vod"]||[self.invitedMessageModel.contentModel.videoType isEqualToString:@"watchtv"]) {
            
            // 点播
            videoDetailVC.videoType = SJVideoTypeVOD;
            videoDetailVC.videoID = self.invitedMessageModel.contentModel.programSeriesId;
            
        }
        else if ([self.invitedMessageModel.contentModel.videoType isEqualToString:@"watchtv"]){
            
            // 看点
            videoDetailVC.videoType = SJVideoTypeWatchTV;
            videoDetailVC.categoryID = self.invitedMessageModel.contentModel.programSeriesId;
            videoDetailVC.videoID = self.invitedMessageModel.contentModel.catgId;
            
        }
        else if ([self.invitedMessageModel.contentModel.videoType isEqualToString:@"live"] ){
            
            // 直播
            videoDetailVC.videoType = SJVideoTypeLive;
            
            TVProgram *program = [[TVProgram alloc] init];
            program.programId = [self.invitedMessageModel.contentModel.programId doubleValue];
            program.programUrl = self.invitedMessageModel.contentModel.url;
            program.programName = self.invitedMessageModel.contentModel.programName;
            program.uuid = self.invitedMessageModel.contentModel.pId;
            program.startTime = self.invitedMessageModel.contentModel.startTime;
            program.endTime = self.invitedMessageModel.contentModel.endTime;
            
            TVStation *station = [[TVStation alloc] init];
            station.uuid = self.invitedMessageModel.contentModel.channelUuid;
            station.channelName = self.invitedMessageModel.contentModel.channelName;
            station.logo = self.invitedMessageModel.contentModel.channelLogo;
            
            videoDetailVC.tvProgram = program;
            videoDetailVC.tvStation = station;
            
        }
        else{
            
            // 直播
            videoDetailVC.videoType = SJVideoTypeReplay;
            
            TVProgram *program = [[TVProgram alloc] init];
            program.programId = [self.invitedMessageModel.contentModel.programId doubleValue];
            program.programUrl = self.invitedMessageModel.contentModel.url;
            program.programName = self.invitedMessageModel.contentModel.programName;
            program.uuid = self.invitedMessageModel.contentModel.pId;
            program.startTime = self.invitedMessageModel.contentModel.startTime;
            program.endTime = self.invitedMessageModel.contentModel.endTime;
            
            TVStation *station = [[TVStation alloc] init];
            station.uuid = self.invitedMessageModel.contentModel.channelUuid;
            station.channelName = self.invitedMessageModel.contentModel.channelName;
            station.logo = self.invitedMessageModel.contentModel.channelLogo;
            
            videoDetailVC.tvProgram = program;
            videoDetailVC.tvStation = station;
            
        }

        [videoDetailVC setupChildController];
        
    }
    else{
        
        UIViewController *viewcontroller;
        if ([self.invitedMessageModel.contentModel.videoType isEqualToString:@"vod"]||[self.invitedMessageModel.contentModel.videoType isEqualToString:@"watchtv"]) {
            
            // 点播
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
            //        SJVideoDetailViewController *detailVC = [[SJVideoDetailViewController alloc] init];
            detailVC.videoID = self.invitedMessageModel.contentModel.programSeriesId;
            
            viewcontroller = detailVC;
            
        }
        else if ([self.invitedMessageModel.contentModel.videoType isEqualToString:@"watchtv"]){
            
            // 看点
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeWatchTV];
            //        SJWatchTVDetailController *detailVC = [[SJWatchTVDetailController alloc] init];
            detailVC.categoryID = self.invitedMessageModel.contentModel.programSeriesId;
            detailVC.videoID = self.invitedMessageModel.contentModel.catgId;
            
            viewcontroller = detailVC;
            
        }
        else if ([self.invitedMessageModel.contentModel.videoType isEqualToString:@"live"] ){
            
            // 直播
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeLive];
            
            
            TVProgram *program = [[TVProgram alloc] init];
            program.programId = [self.invitedMessageModel.contentModel.programId doubleValue];
            program.programUrl = self.invitedMessageModel.contentModel.url;
            program.programName = self.invitedMessageModel.contentModel.programName;
            program.uuid = self.invitedMessageModel.contentModel.pId;
            program.startTime = self.invitedMessageModel.contentModel.startTime;
            program.endTime = self.invitedMessageModel.contentModel.endTime;
            
            TVStation *station = [[TVStation alloc] init];
            station.uuid = self.invitedMessageModel.contentModel.channelUuid;
            station.channelName = self.invitedMessageModel.contentModel.channelName;
            station.logo = self.invitedMessageModel.contentModel.channelLogo;
            
            detailVC.tvProgram = program;
            detailVC.tvStation = station;

            
            viewcontroller = detailVC;
            
        }
        else{
            
            // 直播
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeReplay];
            
            TVProgram *program = [[TVProgram alloc] init];
            program.programId = [self.invitedMessageModel.contentModel.programId doubleValue];
            program.programUrl = self.invitedMessageModel.contentModel.url;
            program.programName = self.invitedMessageModel.contentModel.programName;
            program.uuid = self.invitedMessageModel.contentModel.pId;
            program.startTime = self.invitedMessageModel.contentModel.startTime;
            program.endTime = self.invitedMessageModel.contentModel.endTime;
            
            TVStation *station = [[TVStation alloc] init];
            station.uuid = self.invitedMessageModel.contentModel.channelUuid;
            station.channelName = self.invitedMessageModel.contentModel.channelName;
            station.logo = self.invitedMessageModel.contentModel.channelLogo;
            
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
            if ([activecontroller isKindOfClass:[WatchListViewController class]] ||
                [activecontroller isKindOfClass:[VideoHomeViewController class]] ||
                [activecontroller isKindOfClass:[ChannelViewController class]] ||
                [activecontroller isKindOfClass:[SJMyViewController class]]||[activecontroller isKindOfClass:[MainViewController class]]) {
                
                activecontroller.hidesBottomBarWhenPushed = NO;
            }
        }

    }
    
    
}

- (void)leaveOldRoom
{
    if (![self.oldRoomId isEqualToString:self.roomId]) {
        //xmpp退出聊天室
        [TPIMGroup exitRoom:_oldRoom isPublicRoom:NO completionHandler:^(id responseObject, NSError *error) {
            //error == nil && !leaveRoom
            DDLogInfo(@"离开旧房间");
        }];
    }
}

//离开聊天室
- (void)leaveRoom
{
    //xmpp退出聊天室
    [TPIMGroup exitRoom:_currentRoom isPublicRoom:NO completionHandler:^(id responseObject, NSError *error) {
        //error == nil && !leaveRoom
        
    }];
    [self clearRoom];
}

//清除聊天室
- (void)clearRoom
{
    self.isInChatRoom = NO;
    createdRoom = NO;
    finishInvited = NO;
    self.currentRoom = nil;
    [self.roomMemberList removeAllObjects];
    
    [TPFileOperation clearPrivateVoiceMessageFile];
}

- (void)clearData
{
    self.video = nil;
    self.videoSource = nil;
    self.watchEntity = nil;
    self.watchProgramEntity = nil;
    self.tvProgram = nil;
    self.tvStation =  nil;
}

#pragma mark - Cache
//缓存用户头像
- (void)saveHeadImageUrl:(NSString *)imageUrl withUserJid:(NSString *)jid
{
    if (imageUrl == nil) {
        return;
    }
    NSString *headkey = [NSString stringWithFormat:@"UserHeader_%@",jid];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage *img = [UIImage imageWithData:data];
    [self saveHeadImage:img withUserJid:headkey];
    
}

- (void)saveHeadImage:(UIImage *)image withUserJid:(NSString *)jid
{
    if (image == nil) {
        return;
    }
    NSString *headkey = [NSString stringWithFormat:@"UserHeader_%@",jid];
    [self.cache setObject:image forKey:headkey];
    
}

//缓存用户昵称
- (void)saveNickname:(NSString *)nickname withUserJid:(NSString *)jid
{
    if (nickname.length == 0) {
        return;
    }
    NSString *namekey = [NSString stringWithFormat:@"UserNickname_%@",jid];
    [self.cache setObject:nickname forKey:namekey];
}

//获取用户头像
- (UIImage *)getHeadImageWithJid:(NSString *)jid
{
    if (jid.length == 0) {
        return nil;
    }
    
    //xmpp中获取不到，从xmpp vcard中获取
    UIImage *xmppHead = [TPIMUser getAvatarImageWithUsername:jid];
    if (xmppHead != nil) {
        [self saveHeadImage:xmppHead withUserJid:jid];
        return xmppHead;
    }
    else{
        xmppHead = [TPIMUser getAvatarImageWithUsername:jid];
        if (xmppHead != nil) {
            [self saveHeadImage:xmppHead withUserJid:jid];
            return xmppHead;
        }
    }
    
    return nil;
    
}

//获取用户昵称
- (NSString *)getNicknameWithJid:(NSString *)jid
{
    if (jid.length == 0) {
        return nil;
    }
    //获取jid前半段以及完整jid
    NSString *jidPre;
    NSString *jidBare;
    if ([jid rangeOfString:@"@"].location != NSNotFound) {
        //jidPre = [[jid componentsSeparatedByString:@"@"] firstObject];
        jidBare = jid;
    }
    else{
        jidPre = jid;
        jidBare = [NSString stringWithFormat:@"%@@%@",jidPre,[TPIMUser xmppHostName]];
    }
    
    NSString *nickname;
    
    //从缓存中读取
    NSString *namekey = [NSString stringWithFormat:@"UserNickname_%@",jidBare];
    nickname = (NSString *)[self.cache objectForKey:namekey];
    if (nickname.length != 0) {
        
        return nickname;
    }
    else{
        //xmpp中获取不到,从xmpp vcard中查找
        if (jidBare.length != 0) {
            nickname = [TPIMUser getNickNameWithUsername:jidBare];
        }
        
        if (nickname.length != 0) {
            
            return nickname;
        }
    }
    
    return jid;
    
}

- (void)showMyJoinRoomTip
{
    NSString *tip = [NSString stringWithFormat:@"%@ 已加入聊天室",[HiTVGlobals sharedInstance].nickName];
    
    int parameter1 = 12;
    
    float parameter2 = 144.1;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            DDLogInfo(@"parameter1: %d parameter2: %f", parameter1, parameter2);
            if (self.didReceiveMessage) {
                self.didReceiveMessage(tip, nil);
            }
            
        });
        
    });
}

#pragma mark - Notification
//处理新成员加入聊天室通知
- (void)groupInsertUser:(NSNotification *)notification
{
    //有成员加入聊天室
    if (_currentRoom == nil) {
        return;
    }
    
    // 判断是否为私聊房间
    NSString * groupName = [notification.userInfo valueForKey:TPIMNotification_GroupNameKey];
    
    if ([groupName rangeOfString:[_currentRoom.roomJID bare]].location == NSNotFound) {
        return;
    }
    
    BOOL added = NO;
    //BOOL modified = NO;
    
    // 获取加入房间成员信息
    TPIMUser *user = [notification.userInfo valueForKey:TPIMNotification_GroupMemberKey];
    NSString *jidPre;
   
    // 处理成员jid
    if (user.jid.length != 0) {
        if ([user.jid rangeOfString:@"@"].location != NSNotFound) {
            jidPre = [[user.jid componentsSeparatedByString:@"@"] firstObject];
            
        }
        else{
            jidPre = user.jid;
        }
    }
    
    //判断用户是否已在好友列表中
    NSArray *array = [NSArray arrayWithArray:self.roomMemberList];
    for (TPIMUser *data in array) {
        
        if ([data.username isEqualToString:user.username] || (data.jid.length != 0 &&  jidPre.length != 0 && [data.jid rangeOfString:jidPre].location != NSNotFound) || [data.jid rangeOfString:user.nickname].location != NSNotFound) {
            
            if (data.headImageUrl.length == 0 && user.headImageUrl.length > 0) {
                //modified = YES;
                NSInteger index = [array indexOfObject:data];
                [self.roomMemberList replaceObjectAtIndex:index withObject:user];
            }
            added = YES;
            break;
        }
        
    }
    
    if (user != nil && !added) {
        
    
        [self.roomMemberList addObject:user];
    
        NSString *tip = [NSString stringWithFormat:@"%@ 已加入聊天室",user.nickname];
    
    
        int parameter1 = 12;
    
        float parameter2 = 144.1;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                DDLogInfo(@"parameter1: %d parameter2: %f", parameter1, parameter2);
                if (self.didReceiveMessage) {
                    self.didReceiveMessage(tip, nil);
                }
                
            });
            
        });
        
        
        if (self.didUpdateUserList) {
            self.didUpdateUserList(self.roomMemberList);
        }
    }
}

//处理成员离开聊天室通知
- (void)groupDeleteUser:(NSNotification *)notification
{
    //成员离开聊天室
    if (_currentRoom == nil) {
        return;
    }
    
    NSString * groupName = [notification.userInfo valueForKey:TPIMNotification_GroupNameKey];
    
    if ([groupName rangeOfString:[_currentRoom.roomJID bare]].location == NSNotFound) {
        return;
    }

    BOOL remove = NO;
    TPIMUser *user = [notification.userInfo valueForKey:TPIMNotification_GroupMemberKey];
    TPIMUser *removedUser;
    
    //判断好友列表中是否存在该成员
    for (TPIMUser *data in self.roomMemberList) {
        
        if ([data.jid isEqualToString:user.jid]) {
            removedUser = data;
            remove = YES;
            break;
        }
    }
    
    if (user != nil && remove) {
        [self.roomMemberList removeObject:removedUser];
        if ([user.jid rangeOfString:[HiTVGlobals sharedInstance].xmppUserId].location == NSNotFound) {
            //[OMGToast showWithText:[NSString stringWithFormat:@"%@ 已离开聊天室",user.nickname]];
            NSString *tip = [NSString stringWithFormat:@"%@ 已离开聊天室",user.nickname];
            if (self.didReceiveMessage) {
                self.didReceiveMessage(tip, nil);
            }
        }
        
        if (self.didUpdateUserList) {
            self.didUpdateUserList(self.roomMemberList);
        }
    }
}

//处理远程通知
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DID_HANDLE_REMOTE_NOTIFICATION];
//    if (![HiTVGlobals sharedInstance].isWatchingVideo && ![HiTVGlobals sharedInstance].isChatRoomWatchingVideo && [HiTVGlobals sharedInstance].isLogin) {
//        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *controller = [delegate.window visibleViewController];

        if ([userInfo valueForKey:@"type"] != nil) {
            NSInteger type = [[userInfo valueForKey:@"type"] integerValue];
            switch (type) {
                case 5:
                case 8:
//                {
//                    //收视快报跳看单界面
//                    [controller backToWatchListViewController];
//                    
//                }
//                    break;
                case 6:
                case 7:
                case 11:
                {
                    //分享、约片、微视频跳至消息列表
                    SJMessageCenterViewController *msgCenter = [[SJMessageCenterViewController alloc] init];
                    
                    if (controller.navigationController != nil) {
                        //controller.hidesBottomBarWhenPushed = YES;
                        BOOL hide = NO;
                        if ([self isKindOfClass:[WatchListViewController class]] ||
                            [self isKindOfClass:[VideoHomeViewController class]] ||
                            [self isKindOfClass:[ChannelViewController class]] ||
                            [self isKindOfClass:[SJMyViewController class]] ||
                            [self isKindOfClass:[SJMessageCenterViewController class]]) {
                            
                            hide = NO;
                            controller.hidesBottomBarWhenPushed = NO;
                            
                        }
                        else{
                            hide = YES;
                            controller.hidesBottomBarWhenPushed = YES;
                        }
                        
                        [controller.navigationController pushViewController:msgCenter animated:YES];
                        
                        controller.hidesBottomBarWhenPushed = !hide;
                    }
                    else{
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:msgCenter];
                        [controller presentViewController:nav animated:YES completion:nil];
                    }
                }
                    break;
                default:
                    
                    break;
            }
        }
        
    //}
    
}

//处理收到的群聊消息
- (void)updateMessages:(NSNotification *)notification
{
    //更新未正确显示昵称和头像的用户数据
    if (_currentRoom == nil) {
        return;
    }
    
    TPIMMessage *msg = [notification.userInfo valueForKey:TPIMNotification_MessageKey];
    if ([msg.roomId rangeOfString:[_currentRoom.roomJID bare]].location == NSNotFound) {
        return;
    }
    for (TPIMUser *user in self.roomMemberList) {
        
        if (user.jid.length != 0 && msg.fromId.length != 0 && [user.jid rangeOfString:msg.fromId].location != NSNotFound) {
            user.nickname = msg.fromName;
            user.headImageUrl = msg.fromHeadUrl;
//            [self saveNickname:msg.fromName withUserJid:user.jid];
//            [self saveHeadImageUrl:msg.fromHeadUrl withUserJid:user.jid];
            break;
        }
        
    }
    
    //收到消息或发送消息成功，更新UI
    if ([msg isKindOfClass:[TPIMContentMessage class]]) {
        
        //----文字消息----
        TPIMContentMessage *contentMsg = (TPIMContentMessage *)msg;
        contentMsg.isPublicMessage = NO;
        
        //创建弹幕数据
        TPDanmakuData *data = [[TPDanmakuData alloc] init];
        data.message = contentMsg.contentText;
        data.isSender = NO;
        data.senderName = msg.fromName;
        
        if (StringNotEmpty([HiTVGlobals sharedInstance].xmppUserId) &&
            StringNotEmpty(contentMsg.fromId) &&
            ([[HiTVGlobals sharedInstance].xmppUserId rangeOfString:contentMsg.fromId].location != NSNotFound ||
             [contentMsg.fromId rangeOfString:[HiTVGlobals sharedInstance].xmppUserId].location != NSNotFound))
        {
            data.isSender = YES;
        }
        
        data.isVoiceMessage = NO;
        
        if (self.didReceiveMessage) {
            self.didReceiveMessage(contentMsg, data);
        }
        
    }
    else if ([msg isKindOfClass:[TPIMVoiceMessage class]]){
        
        //----语音消息----
        TPIMVoiceMessage *contentMsg = (TPIMVoiceMessage *)msg;
        contentMsg.isPublicMessage = NO;
        
        //创建弹幕数据
        TPDanmakuData *data = [[TPDanmakuData alloc] init];
        data.message = contentMsg.voiceString;
        data.senderName = msg.fromName;
        data.isSender = NO;
        
        if (StringNotEmpty([HiTVGlobals sharedInstance].xmppUserId) &&
            StringNotEmpty(contentMsg.fromId) &&
            ([[HiTVGlobals sharedInstance].xmppUserId rangeOfString:contentMsg.fromId].location != NSNotFound ||
             [contentMsg.fromId rangeOfString:[HiTVGlobals sharedInstance].xmppUserId].location != NSNotFound))
        {
            data.isSender = YES;
        }
        
        data.recordUrlStr = contentMsg.resourcePath;
        data.recordDuration = contentMsg.duration;
        data.isVoiceMessage = YES;
        
        
        if (self.didReceiveMessage) {
            self.didReceiveMessage(contentMsg, data);
        }
    }
    
}

- (void)receiveDeclineMessage:(NSNotification *)sender
{
    NSString *reason = [sender.userInfo objectForKey:TPIMNotification_DeclineReasonKey];
    [MBProgressHUD show:reason icon:@"img_failed" view:nil];
}

#pragma mark - observer
- (void)startObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupInsertUser:) name:TPIMNotification_GroupChange_OccupantDidJoin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupDeleteUser:) name:TPIMNotification_GroupChange_OccupantDidLeave object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessages:) name:TPIMNotification_ReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDeclineMessage:) name:TPIMNotification_GroupChange_DidDeclineInvitation object:nil];
    
    //监听发送消息结果通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSendMessage:) name:TPIMNotification_SendMessageResult object:nil];
}

#pragma mark - setter
- (void)setCurrentRoom:(XMPPRoom *)currentRoom
{
    //上一个房间id
    _oldRoom = _currentRoom;
    if (_currentRoom == nil) {
        self.oldRoomId = nil;
    }
    else{
        self.oldRoomId = [_currentRoom.roomJID bare];
        
    }
    
    //新房间id
    _currentRoom = currentRoom;
    
    if (currentRoom == nil) {
        
        self.isInChatRoom = NO;
        self.roomId = nil;
        
    }
    else{
        self.isInChatRoom = YES;
        
        self.roomId = [currentRoom.roomJID bare];
        
        [TogetherManager sharedInstance].deviceDetectedBlock = ^(){
            self.deviceArray = [NSArray arrayWithArray:[TogetherManager sharedInstance].detectedDevices];
        };
    }
    
}

#pragma mark - 播放地址解码
- (NSString *)encodeActionUrl:(NSString *)actionUrl
{
    NSString *key = @"36b9c7e8695468dc";
    
    NSString *resultUrl;
    
    if ([actionUrl rangeOfString:@"yst://"].location != NSNotFound) {
        NSString *strUrl = [actionUrl stringByReplacingOccurrencesOfString:@"yst://" withString:@""];
        
        resultUrl = [AES128Util AES128Decrypt:strUrl key:key];
        
    }
    else{
        resultUrl = actionUrl;
    }
    
    return resultUrl;
}

@end
