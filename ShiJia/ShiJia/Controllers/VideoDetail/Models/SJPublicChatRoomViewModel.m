
//
//  SJPublicChatRoomViewModel.m
//  ShiJia
//
//  Created by yy on 16/7/18.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPublicChatRoomViewModel.h"
#import "TPIMGroup.h"
#import "XMPPRoom.h"
#import "TPIMGroup.h"
#import "TPIMUser.h"
#import "TPIMMessage.h"
#import "TPIMContentModel.h"
#import "TPMessageRequest.h"
#import "TPDanmakuData.h"
#import "TPFileOperation.h"

@interface SJPublicChatRoomViewModel ()

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, assign, readwrite) NSInteger onlineNum;
@property (nonatomic, strong) XMPPRoom *currentRoom;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSThread *thread;

@property (nonatomic, strong) NSTimer *threadTimer;

@end

@implementation SJPublicChatRoomViewModel

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
//        [self startCounting];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoom) name:TPXMPPReconnectNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Room operation
- (void)joinRoom
{
    //进入房间
    TPIMGroup *group = [[TPIMGroup alloc] init];
    group.groupName = _roomId;
    group.isPublicGroup = YES;
    
    [TPIMGroup createGroup:group completionHandler:^(id responseObject, NSError *error) {
        
        
        if (error == nil) {
            
            //进入房间成功
            if ([responseObject isKindOfClass:[XMPPRoom class]]) {
                
                //创建房间成功发送邀请消息
                XMPPRoom *room = (XMPPRoom *)responseObject;
                
                if (room) {
                    
                    if (!self.currentRoom) {
                        DDLogInfo(@"成功加入群聊");
                        self.currentRoom = room;
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessages:) name:TPIMNotification_ReceiveMessage object:nil];
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupInsertUser:) name:TPIMNotification_GroupChange_OccupantDidJoin object:nil];
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupDeleteUser:) name:TPIMNotification_GroupChange_OccupantDidLeave object:nil];
                    }
                    
                }
            }
            else{
                //进入房间失败
                 DDLogError(@"加入群聊失败");
            }
            
        }
        else{
            //进入房间失败
             DDLogError(@"加入群聊失败");
        }
    }];
}

//离开聊天室
- (void)leaveRoom
{
    //xmpp退出聊天室
    
    [TPIMGroup exitRoom:_currentRoom isPublicRoom:YES completionHandler:^(id responseObject, NSError *error) {
        //error == nil && !leaveRoom
        
    }];
    [self clearRoom];
}

//清除聊天室
- (void)clearRoom
{
    self.currentRoom = nil;
    self.roomId = nil;

    if (self.threadTimer) {
        
        [self.threadTimer invalidate];
        
        self.threadTimer = nil;
    }
    [TPFileOperation clearPublicVoiceMessageFile];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)groupInsertUser:(NSNotification *)notification
{
    //有成员加入聊天室
    if (_currentRoom == nil) {
        return;
    }
    
    NSString * groupName = [notification.userInfo valueForKey:TPIMNotification_GroupNameKey];
    if ([groupName rangeOfString:[_currentRoom.roomJID bare]].location == NSNotFound) {
        return;
    }
   
    //加载在线用户人数
    [self queryRoomNumsWithRoomId:_roomId  success:^(NSInteger num) {
        self.onlineNum = num;
    } failed:^(NSString *error) {
        
    }];
    
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
    
    //加载在线用户人数
    [self queryRoomNumsWithRoomId:_roomId  success:^(NSInteger num) {
        self.onlineNum = num;
    } failed:^(NSString *error) {
        
    }];
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
    
    //收到消息或发送消息成功，更新UI
    if ([msg isKindOfClass:[TPIMContentMessage class]]) {
        
        //----文字消息----
        TPIMContentMessage *contentMsg = (TPIMContentMessage *)msg;
        contentMsg.isPublicMessage = YES;
        
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
        contentMsg.isPublicMessage = YES;
        
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

#pragma mark - Message operation
//发送消息
- (void)publicRoomSendMessage:(NSString *)msg
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

- (void)publicRoomSendRecordData:(NSData *)recordData recordString:(NSString *)recordString recordDuration:(CGFloat)recordDuration
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

#pragma mark -  Download Data
//获取群聊房间id
- (void)getChanelRoomWithChanelId:(NSString *)channelid
                          success:(void (^)(NSString *))success
                           failed:(void (^)(NSString *))failure
{
    
    if (channelid.length == 0) {
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:channelid forKey:@"channelId"];
    [parameters setObject:BIMS_DOMAIN forKey:@"area"];

    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/getChanelRoom" forParameters:parameters  completion:^(id responseObject) {
        
        
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            
            _roomId = [resultDic objectForKey:@"roomId"];
            [self joinRoom];
            [self startCounting];
            [self queryRoomNumsWithRoomId:_roomId  success:^(NSInteger num) {
                self.onlineNum = num;
            } failed:^(NSString * error) {
                
            }];
            success(_roomId);
            
        }
    }failure:^(NSString *error) {
        
        DDLogError(@"fail");
        failure(error);
        
    }];
}

- (void)queryRoomNumsWithRoomId:(NSString *)roomid
                        success:(void (^)(NSInteger))success
                           failed:(void (^)(NSString *))failure
{
    if (roomid.length == 0) {
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:roomid forKey:@"roomId"];
    [parameters setObject:BIMS_DOMAIN forKey:@"area"];

    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/queryRoomNums" forParameters:parameters  completion:^(id responseObject) {
        
        
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            
            NSNumber *num = [resultDic objectForKey:@"onlineNum"];
            self.onlineNum = [num integerValue];
            
            success([num integerValue]);
            
        }
    }failure:^(NSString *error) {
        
        DDLogError(@"fail");
        failure(error);
        
    }];
}

#pragma mark - Timer
- (void)startCounting
{
//    if (_timer == nil) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
//    }
//    [_timer fire];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            
            strongSelf.thread = [NSThread currentThread];
            [strongSelf.thread setName:@"线程A"];
            strongSelf.threadTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:strongSelf selector:@selector(handleTimer:) userInfo:nil repeats:YES];
            NSRunLoop *runloop = [NSRunLoop currentRunLoop];
            [runloop addTimer:strongSelf.threadTimer forMode:NSDefaultRunLoopMode];
            [runloop run];
        }
    });
}

- (void)handleTimer:(NSTimer *)sender
{
    
    [self queryRoomNumsWithRoomId:_roomId  success:^(NSInteger num) {
        self.onlineNum = num;
        
    } failed:^(NSString *error) {
        
    }];
}

//- (void)startCounting
//{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    
//    dispatch_source_set_event_handler(timer, ^{ @autoreleasepool {
//        
//        DDLogInfo(@"计时");
//    }});
//    
//    dispatch_time_t fireTime = dispatch_time(DISPATCH_TIME_NOW, (1.0 * NSEC_PER_SEC));
//    
//    dispatch_source_set_timer(timer, fireTime, DISPATCH_TIME_FOREVER, 1.0);
//    dispatch_resume(timer);
//    __block int count = 1;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.1 * NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            DDLogInfo(@"计时");
//            
//            if (count < 160) {
//
////                count++;
//                count = 1;
//            
//                [self queryRoomNumsWithSuccess:^(NSInteger num) {
//                    
//                    _onlineNum = num + 1;
////                    dispatch_resume(_timer);
//                    
//                } failed:^(NSString *error) {
//                    
//                }];
//            }
//            else{
//                count ++;
//            }
//            
//            
//        });
//        
//    });
//    dispatch_resume(_timer);
//    
//}

@end
