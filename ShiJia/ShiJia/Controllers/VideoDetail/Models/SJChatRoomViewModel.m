//
//  SJChatRoomViewModel.m
//  ShiJia
//
//  Created by yy on 16/5/17.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJChatRoomViewModel.h"

#import "TPXmppManager.h"
#import "TPXmppRoomManager.h"
#import "TPIMContentModel.h"
#import "TPIMMessage.h"
#import "TPMessageRequest.h"
#import "TPIMUser.h"
#import "TPIMNodeModel.h"
#import "TPIMEpgData.h"
#import "TPIMGroup.h"

#import "NSString+Conversion.h"
#import "XMPPRoom.h"
#import "AES128Util.h"
#import "TPFileOperation.h"

#import "HiTVVideo.h"
#import "VideoSource.h"
#import "UserEntity.h"
#import "WatchListEntity.h"
#import "WatchFocusVideoProgramEntity.h"
#import "TVProgram.h"
#import "TVStation.h"

@interface SJChatRoomViewModel ()
{
    BOOL createdRoom;
    BOOL finishInvited;
}
@property (nonatomic, strong, readwrite) NSMutableArray *userList;
@property (nonatomic, strong, readwrite) NSMutableArray *messageList;
@property (nonatomic, strong, readwrite) NSString *roomId;

@end

@implementation SJChatRoomViewModel

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self addObservers];
        
        _messageList = [[NSMutableArray alloc] init];
        _userList = [NSMutableArray arrayWithArray:[TPXmppRoomManager defaultManager].roomMemberList];
        
        
    }
    return self;
}

#pragma mark - Public
//发送消息
- (void)sendMessage:(NSString *)msg
{
    //发消息
    TPIMContentMessage *message = [[TPIMContentMessage alloc] init];
    message.conversationType = kTPIMGroup;
    
    //设置消息内容
    TPIMContentModel *content = [[TPIMContentModel alloc] init];
    content.content = msg;
    
    
    message.contentText = [content mj_JSONString];
    
    XMPPJID *jid = [XMPPJID jidWithString:self.roomId];
    message.targetId = [jid bare];
    
    [TPIMMessage sendMessage:message];
}

- (void)sendRecordData:(NSData *)recordData recordDuration:(CGFloat)recordDuration
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
            msg.duration = [NSString stringWithFormat:@"%.f",recordDuration];
            msg.targetId = self.roomId;
            [TPIMMessage sendMessage:msg];
        }
    }];
    
}

//发送邀请消息
- (void)sendInvitationMessageWithRoomId:(NSString *)roomId
{
    if (!self.video) {
        return;
    }
    
    TPIMMessageModel *message = [[TPIMMessageModel alloc] init];
    
    //保存消息标志位
    message.ext = @"1";
    
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
    message.title = [NSString stringWithFormat:@"%@ 约你一起看《%@》",[HiTVGlobals sharedInstance].nickName,self.videoSource.name];
    message.summary = message.title;
    
    //content Model
    TPIMContentModel *content = [[TPIMContentModel alloc] init];
    /*
     约片content定义:
     content:{
     url:[string]节目播放地址url，
     datePoint:[string]节目断点时间，原来的"startTime",
     roomId:[string]聊天室ID，
     content:[string]html描述“<font color='#e6e6e6'>wlmYsten约你一起看<\\/font><font color='#005d70'>《[HD]入侵华尔街》<\\/font>”
     videoType:[string]视频类型vod,watchtv,live,replay,
     thumPath:[string]海报url，
     ------新增加字段------
     channelUuid:[string]频道uuid，
     programId:[string]节目ID，
     programSeriesId:[string]节目集ID，
     programName:[string]节目名称，
     startTime:[string]节目开始时间，
     endTime:[string]节目结束时间,
     directors:[string]导演，
     actors:[string]主演
     }
     */
    
    switch (self.videoType) {
        // 点播
        case ChatRoomVideoTypeVOD:
        {
            content.url = [self encodeActionUrl:self.videoSource.actionURL];
            content.videoType = @"vod";
            content.thumPath = self.video.picurl;
            content.programSeriesId = self.video.videoID;
            content.programName = self.videoSource.name;
            content.directors = self.video.director;
            content.actors = self.video.actor;
        
        }
            break;
        // 看点
        case ChatRoomVideoTypeWatchTV:
        {
            
            content.url = [self encodeActionUrl:self.watchProgramEntity.programUrl];
            content.videoType = @"watchtv";
            content.thumPath = self.watchEntity.posterAddr;
            content.programSeriesId = self.watchEntity.programSeriesId;
            content.programName = self.watchEntity.programSeriesName;
            content.programId = self.watchProgramEntity.programId;
            content.directors = self.video.director;
            content.actors = self.video.actor;
        }
            break;
        case ChatRoomVideoTypeLive:
        {
            content.url = self.tvProgram.programUrl;
            content.videoType = @"live";
            content.thumPath = self.tvProgram.desImg;
            content.channelUuid = self.tvStation.uuid;
            content.startTime = self.tvProgram.startTime;
            content.endTime = self.tvProgram.endTime;
        
        }
            break;
        case ChatRoomVideoTypeReplay:
        {
        
        }
            break;
            
        default:
            break;
    }
    
        
    content.datePoint = @"0";
    content.roomId = roomId;
    content.content = [NSString stringWithFormat:@"<font color='#e6e6e6'>%@ 约你一起看</font> <font color='#005d70'>《%@》</font> <font color='#e6e6e6'>,要不要马上就约起来，一起边看边聊呢？</font>",[HiTVGlobals sharedInstance].nickName,self.videoSource.name];
    
    
    //消息发送方式
    message.sentMethod = kTPMessageSentMethod_ByHttp;
    
    message.contentModel = content;
    
    //发送消息
    [TPIMMessageModel sendMessage:message];
//    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
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

//退出聊天室
- (void)leaveChatRoom
{
    //xmpp退出聊天室
    [TPIMGroup exitRoom:[TPXmppRoomManager defaultManager].currentRoom  isPublicRoom:NO completionHandler:^(id responseObject, NSError *error) {
        
    }];
//    if (!leaveRoom) {
//        
//        [self leaveChatRoomSuccess];
//    }
}

#pragma mark - NSNotification
- (void)addObservers
{
    //监听成员列表变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserList) name:RoomMemberChangedNotification object:nil];
    
    //监听某个成员信息发生变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUser:) name:RoomOccupantInfoChangedNotification object:nil];
    
    //监听群聊消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessages:) name:RoomMessageReceivedNotification object:nil];
    
    //监听发送消息结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSendMessage:) name:TPIMNotification_SendMessageResult object:nil];
    
    
    //离开聊天室通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveChatRoom) name:TPIMNotification_GroupChange_DidLeave_ByDisconnection object:nil];
//
//    //投屏通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenView:) name:kTPWillScreenViewNotification object:nil];
//    
//    //xmpp下线通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveChatRoom) name:TPXMPPOfflineNotification object:nil];
}

- (void)updateUserList
{
    NSArray *list = [TPXmppRoomManager defaultManager].roomMemberList;

    if (self.userList.count > 0) {
        
        if (list.count > self.userList.count) {
            
            //加入房间
            for (TPIMUser *data in list) {
                if (![self.userList containsObject:data]) {
                    [self showHUDWithMessage:[NSString stringWithFormat:@"%@已加入聊天室，可以聊天了",data.nickname]];
                }
            }
            
        }
        else{
            //离开房间
            NSArray *totalList = [NSArray arrayWithArray:self.userList];
            for (TPIMUser *data in totalList) {
                if (![list containsObject:data]) {
                    [self showHUDWithMessage:[NSString stringWithFormat:@"%@已离开聊天室",data.nickname]];
                }
            }
        }
    }
    else{
        
        //好友排序，房间创建者排最前面
        NSArray *array = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            TPIMUser *user1 = (TPIMUser *)obj1;
            TPIMUser *user2 = (TPIMUser *)obj2;
            if ([user1.affiliation isEqualToString:@"owner"]) {
                return NSOrderedAscending;
            }
            else{
                if ([user2.affiliation isEqualToString:@"owner"]) {
                    return NSOrderedDescending;
                }
                else{
                    return NSOrderedSame;
                }
            }
            return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
            
        }];
        
        self.userList = [NSMutableArray arrayWithArray:array];
        
    }
    
}

//更新成员信息
- (void)updateUser:(NSNotification *)notification
{
    TPIMUser *user = [notification.userInfo valueForKey:RoomOccupantModelKey];
    for (TPIMUser *data in self.userList) {
        if ([data.jid rangeOfString:user.jid].location != NSNotFound) {

            break;
        }
    }
    self.userList = [NSMutableArray arrayWithArray:[TPXmppRoomManager defaultManager].roomMemberList];
    
}

//更新消息列表，发送弹幕
- (void)updateMessages:(NSNotification *)notification
{
    //收到的消息数据
    TPIMMessage *msg = [notification.userInfo valueForKey:RoomMessageModelKey];
    
    //弹幕数据
//    TPDanmakuData *data = [notification.userInfo valueForKey:RoomDanmuMessageModelKey];
    
    //生成弹幕
//    [self.videoPlayerViewController sendBarrage:data];
    
    if (self.didReceiveMessage) {
        self.didReceiveMessage(msg);
    }
}

//消息发送结果通知
- (void)didSendMessage:(NSNotification *)notification
{
    
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    if (!finishInvited) {
        
        finishInvited = YES;
        [self showHUDWithMessage:@"发送邀请成功"];
        self.userList = [NSMutableArray arrayWithArray:[TPXmppRoomManager defaultManager].roomMemberList];
        if (self.didFinishInvitation) {
            self.didFinishInvitation();
        }
    }
}

#pragma mark - hud
- (void)showHUDWithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    [hud show:YES];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
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
