//
//  SJInviteUserViewModel.h
//  ShiJia
//
//  Created by yy on 16/5/17.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HiTVVideo;
@class VideoSource;

@interface SJInviteUserViewModel : NSObject

/**
 *  已加入聊天室的好友列表（注：用于聊天室中邀请好友时剔除已加入的好友）
 */
@property (nonatomic, retain) NSArray *disableUserList;

/**
 *  节目单数据
 */
@property (nonatomic, retain) HiTVVideo *video;

/**
 *  节目集数据
 */
@property (nonatomic, retain) VideoSource *videoSource;

/**
 *  视频开始时间
 */
@property (nonatomic, assign) NSTimeInterval startTime;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger currentVideoIndex;

/**
 *  聊天室name
 */
@property (nonatomic, copy) NSString *groupName;

/**
 *  是否为聊天室中邀请
 */
@property (nonatomic, assign) BOOL chatRoomInvited;

/**
 *  视频类型
 */
@property (nonatomic, copy) NSString *playerType;

- (void)sendInvitationMessageToUsers:(NSArray <UserEntity *> *)list;

@end
