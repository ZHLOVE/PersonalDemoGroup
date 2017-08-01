//
//  SJChatRoomViewModel.h
//  ShiJia
//
//  Created by yy on 16/5/17.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HiTVVideo;
@class VideoSource;
@class WatchListEntity;
@class WatchFocusVideoProgramEntity;
@class TVProgram;
@class TVStation;
@class TPIMMessage;

typedef NS_ENUM(NSInteger, ChatRoomVideoType){

    ChatRoomVideoTypeVOD,//点播
    ChatRoomVideoTypeWatchTV,//看点
    ChatRoomVideoTypeLive,//直播
    ChatRoomVideoTypeReplay//回看

};

@interface SJChatRoomViewModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *userList;
@property (nonatomic, strong, readonly) NSMutableArray *messageList;
@property (nonatomic, strong, readonly) NSString *roomId;
@property (nonatomic, strong) NSArray *invitedUserList;
@property (nonatomic, assign) ChatRoomVideoType videoType;
@property (nonatomic, copy) void (^didFinishInvitation)();
@property (nonatomic, copy) void (^didReceiveMessage)(TPIMMessage *message);


@property (nonatomic, strong) HiTVVideo *video;
@property (nonatomic, strong) VideoSource *videoSource;
@property (nonatomic, strong) WatchListEntity *watchEntity;
@property (nonatomic, strong) WatchFocusVideoProgramEntity *watchProgramEntity;
@property (nonatomic, strong) TVProgram *tvProgram;
@property (nonatomic, strong) TVStation *tvStation;

- (void)sendMessage:(NSString *)msg;
- (void)sendRecordData:(NSData *)recordData recordDuration:(CGFloat)recordDuration;
- (void)sendInvitationMessageWithRoomId:(NSString *)roomId;
- (void)sendInvitationMessageAndCreateRoom;
- (void)createRoom;

@end
