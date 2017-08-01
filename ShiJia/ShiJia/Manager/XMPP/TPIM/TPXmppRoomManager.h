//
//  TPXmppRoomManager.h
//  HiTV
//
//  Created by yy on 15/11/9.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPIMMessageModel.h"

@class XMPPRoom;
@class HiTVVideo;
@class VideoSource;
@class WatchFocusVideoEntity;
@class WatchFocusVideoProgramEntity;
@class TVProgram;
@class TVStation;
@class TPIMMessage;
@class TPDanmakuData;
@class WatchListEntity;

#pragma mark - Notification
extern NSString * const RoomMemberChangedNotification;      //房间成员变化通知
extern NSString * const RoomMessageReceivedNotification;    //收到消息通知
extern NSString * const RoomMessageModelKey;                //收到的消息mocel key，用于聊天室从通知中拿到消息model
extern NSString * const RoomDanmuMessageModelKey;           //弹幕model key，用于聊天室从通知中拿到弹幕消息model
extern NSString * const RoomOccupantInfoChangedNotification;//房间中某个成员信息改变通知
extern NSString * const RoomOccupantModelKey;               //用户信息更改的TPIMUSer key，用于聊天室从通知中拿到用户model

typedef NS_ENUM(NSInteger, TPChatRoomVideoType){
    
    TPChatRoomVideoTypeVOD,//点播
    TPChatRoomVideoTypeWatchTV,//看点
    TPChatRoomVideoTypeLive,//直播
    TPChatRoomVideoTypeReplay//回看
    
};

@interface TPXmppRoomManager : NSObject

/**
 *  当前加入的聊天室
 */
@property (nonatomic, strong) XMPPRoom *currentRoom;

/**
 *  约片消息
 */
@property (nonatomic, strong) TPIMMessageModel *invitedMessageModel;

/**
 *  聊天室好友列表
 */
@property (nonatomic, strong) NSMutableArray *roomMemberList;

#pragma mark - 以下参数用于投屏

@property (nonatomic, strong) NSArray *deviceArray;

#pragma mark - Room
@property (nonatomic, assign, readonly) BOOL isInChatRoom;//是否在聊天室中标志位
@property (nonatomic, strong, readonly) NSString *roomId; //房间id
@property (nonatomic, strong) NSArray *invitedUserList;   //邀请好友列表
@property (nonatomic, assign) TPChatRoomVideoType videoType;//视频源类型
@property (nonatomic, copy) void (^didFinishInvitation)();//完成邀请block
@property (nonatomic, copy) void (^didReceiveMessage)(id message, TPDanmakuData *danmuData);//收到消息、弹幕block
@property (nonatomic, copy) void (^didUpdateUserList)(NSArray *list);//更新房间成员列表block

@property (nonatomic, assign) CGFloat currentPlayedSeconds;//当前播放时长

//以下为几种视频源data
@property (nonatomic, strong) HiTVVideo *video;
@property (nonatomic, strong) VideoSource *videoSource;

@property (nonatomic, strong) WatchFocusVideoEntity *watchEntity;
@property (nonatomic, strong) WatchFocusVideoProgramEntity *watchProgramEntity;

@property (nonatomic, strong) TVProgram *tvProgram;
@property (nonatomic, strong) TVStation *tvStation;
@property (nonatomic, strong) WatchListEntity *watchListEntity;

@property (nonatomic, assign) NSString *stype;//noti 


#pragma mark - Message
//发送文字消息
- (void)sendMessage:(NSString *)msg;

//发送语音消息
- (void)sendRecordData:(NSData *)recordData recordString:(NSString *)recordString recordDuration:(CGFloat)recordDuration;

//发送邀请消息
- (void)sendInvitationMessageWithRoomId:(NSString *)roomId;

//发送邀请消息并创建房间
- (void)sendInvitationMessageAndCreateRoom;
- (void)sendFollowFriendMessage;

//显示加入房间成功提醒信息
- (void)showMyJoinRoomTip;

#pragma mark - Room Operation
/**
 *  加入聊天室
 */
- (void)joinRoom;

/**
 *  离开上一个房间
 *  加入新的聊天室
 */
- (void)leaveOldRoom;

/**
 *  离开聊天室
 */
- (void)leaveRoom;

/**
 *  清除聊天室
 */
- (void)clearRoom;

/**
 *  清除数据
 */
- (void)clearData;

/**
 *  处理远程推送消息
 *
 *  @param userInfo 消息体
 */
- (void)handleRemoteNotification:(NSDictionary *)userInfo;

#pragma mark - User
/**
 *  缓存用户名
 *
 *  @param nickname 用户名
 *  @param jid      用户jid
 */
- (void)saveNickname:(NSString *)nickname withUserJid:(NSString *)jid;

/**
 *  缓存用户头像
 *
 *  @param imageUrl 头像url
 *  @param jid      用户jid
 */
- (void)saveHeadImageUrl:(NSString *)imageUrl withUserJid:(NSString *)jid;

/**
 *  获取用户头像
 *
 *  @param jid 用户jid
 *
 *  @return 返回头像image
 */
- (UIImage *)getHeadImageWithJid:(NSString *)jid;

/**
 *  获取用户昵称
 *
 *  @param jid 用户jid
 *
 *  @return 返回用户昵称
 */
- (NSString *)getNicknameWithJid:(NSString *)jid;


#pragma mark - init
+ (TPXmppRoomManager *)defaultManager;
- (void)startObserving;

@end
