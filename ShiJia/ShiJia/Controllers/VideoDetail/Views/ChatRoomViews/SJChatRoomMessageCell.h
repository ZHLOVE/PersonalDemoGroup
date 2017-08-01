//
//  SJChatRoomMessageCell.h
//  ShiJia
//
//  Created by yy on 16/4/1.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class MLPlayVoiceButton;
@class TPIMMessage;
@class TPIMContentMessage;
@class TPIMVoiceMessage;
@class MLPlayVoiceButton;

extern CGFloat const kAvatarNodeWidth;

@interface SJChatRoomMessageCell : ASCellNode

/**
 *  头像
 */
@property (nonatomic, strong) ASNetworkImageNode *avatarNode;

@property (nonatomic, strong) UIView *avatarView;

/**
 *  昵称
 */
@property (nonatomic, strong) ASTextNode         *nameNode;

/**
 *  文字消息背景
 */
@property (nonatomic, strong) ASImageNode        *messageBackNode;

/**
 *  文字消息内容
 */
@property (nonatomic, strong) ASTextNode         *messageNode;

//@property (nonatomic, strong) ASButtonNode       *recordNode;

/**
 *  语音view
 */
@property (nonatomic, strong) IBOutlet UIView  *recordView;

/**
 *  语音消息背景image view
 */
@property (nonatomic, strong) IBOutlet UIImageView *recordBackImgView;

/**
 *  语音button
 */
@property (nonatomic, strong) IBOutlet MLPlayVoiceButton *playButton;

/**
 *  点击用户头像，进入用户资料界面
 */
@property (nonatomic, copy) void(^showUserInfoBlock)(SJChatRoomMessageCell *);

/**
 *  长按用户头像，输入框出现 "@用户昵称" 字样
 */
@property (nonatomic, copy) void(^atUserNameBlock)(SJChatRoomMessageCell *);

/**
 *  语音消息开始播放block
 */
@property (nonatomic, copy) void(^voiceMessageWillStartPlayingBlock)();

/**
 *  语音消息播放结束block
 */
@property (nonatomic, copy) void(^voiceMessageDidFinishPlayingBlock)();

/**
 *  显示文字消息
 *
 *  @param message
 */
- (void)showMessage:(TPIMContentMessage *)message;

/**
 *  显示语音消息
 *
 *  @param data
 */
- (void)showRecordMessage:(TPIMVoiceMessage *)data;

- (NSDictionary *)nameAttributes;
- (NSDictionary *)messageAttributes;


@end
