//
//  TPIMConversation.h
//  XmppDemo
//
//  Created by yy on 15/7/9.
//  Copyright (c) 2015年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TPIMConstants.h"

@class TPIMMessage;

/**
 *  会话变更通知（用来当SDK后台更新会话信息时刷新界面使用）
 */
extern NSString * const TPIMNotification_ConversationInfoChanged;
extern NSString * const TPIMNotification_ConversationInfoChangedKey;

/**
 *  会话类型
 */
typedef NS_ENUM(NSInteger, TPIMConversationType){

    kTPIMSingle = 0, // 单聊
    kTPIMGroup,      // 群聊
    
};

/**
 *  消息的所有种类
 */
typedef NS_ENUM(NSInteger, TPIMMessageContentType) {
    kTPIMTextMessage = 0, // 文本消息
    kTPIMImageMessage,    // 图片消息
    kTPIMVoiceMessage,    // 语音消息
    kTPIMCustonMessage,   // 自定义消息
    kTPIMEventMessage,    // 时间通知消息。服务器端下发的事件通知，本地展示为这个类型的消息展示出来
    kTPIMTimeMessage,     // 会话时间。UI层可用于展示会话时间
};

/**
 *  消息状态
 */
typedef NS_ENUM(NSInteger, TPIMMessageStatusType) {
    kTPIMStatusNone = 0,
    kTPIMStatusSendSucceed,
    kTPIMStatusSendFail,
    kTPIMStatusSending,
    kTPIMStatusUploadSucceed,
    kTPIMStatusSendDraft,
    kTPIMStatusReceiving,
    kTPIMStatusReceiveSucceed,
    kTPIMStatusReceiveFailed,
    kTPIMStatusDownloadFailed
    
};

@interface TPIMConversation : NSObject

//------------------------------------------------------------------
// @name Conversation Basic Properties 会话基本属性
//------------------------------------------------------------------

/**
 * 聊天会话ID
 */
@property (nonatomic, copy) NSString *Id;

/**
 *  会话类型：单聊、群聊
 */
@property (nonatomic, assign) TPIMConversationType chatType;

/**
 *  会话对象ID。单聊时是 username，群聊时是groupId
 */
@property (nonatomic, copy) NSString *targetId;

/**
 *  会话对象昵称、单聊时是用户的displayName，群聊时是groupName
 */
@property (nonatomic, copy) NSString *targetName;

/**
 *  会话头像。单聊来自于聊天对象用户头像；群聊来自于群组头像
 */
@property (nonatomic, copy, getter=avatarThumb) UIImage *avatarThumb;


//------------------------------------------------------------------
// @name Last message about 最后一条消息
//------------------------------------------------------------------


/**
 *  最后消息的类型："text","voice","image","event"
 */
@property (nonatomic, copy) NSString *lastestType;

/**
 *  最后消息的文本描述：文本消息内容、"语音","图片",Event事件内容
 */
@property (nonatomic, copy) NSString *lastestText;

/**
 *  最后消息的时间（时间戳格式）
 */
@property (nonatomic, copy) NSString *lastestDate;

/**
 *  最后消息发送者
 */
@property (nonatomic, copy) NSString *lastestDisplayName;


//------------------------------------------------------------------
// @name Conversation State 会话状态
//------------------------------------------------------------------

/**
 *  未读消息数
 */
@property (nonatomic, strong) NSNumber *unreadCount;

/**
 *  最后一条消息发送状态
 */
@property (nonatomic, assign) TPIMMessageStatusType lastestMessageStatus;

//------------------------------------------------------------------
// @name Message Operations 消息相关操作
//------------------------------------------------------------------

/**
 *  获取指定消息id的消息
 *
 *  @param messageId 消息唯一识别Id
 *  @param handler   结果回调，resultObject对象类型为TPIMMessage
 */
- (void)getMessage:(NSString *)messageId
 completionHandler:(TPIMCompletionHandler)handler;

/**
 *  获取会话所有消息
 *
 *  @param handler 结果回调。resultObject对象类型为NSArray，使用时需要将NSArray的成员转换为TPIMMessage类型，再通过contentType属性判断消息的种类分别转换为TPIMImageMessage、TPIMVoiceMessage、TPIMTextMessage、TPIMEventMessage...
 */
- (void)getAllMessageWithCompletionHandler:(TPIMCompletionHandler)handler;

/**
 *  删除会话所有消息
 *
 *  @param handler 结果回调。resultObject值不需要关心，始终为nil
 */
- (void)deleteAllMessageWithCompletionHandler:(TPIMCompletionHandler)handler;

//------------------------------------------------------------------
// @name Conversation State Maintenance 会话状态维护
//------------------------------------------------------------------

/**
 *  将会话中的未读消息数清零
 *
 *  @param handler 结果回调。resultObject值不需要关心，始终为nil
 */
- (void)resetUnreadMessageCountWithCompletionHandler:(TPIMCompletionHandler)handler;


//------------------------------------------------------------------
// @name Conversation Operations 会话相关操作
//------------------------------------------------------------------

/**
 *  获取所有会话列表
 *
 *  @param handler 结果回调。resultObject对象类型为NSArray（数组成员为TPIMConversation类型）
 */
+ (void)getConversationListWithCompletionHandler:(TPIMCompletionHandler)handler;

/**
 *  获取已知的会话
 *
 *  @param targetId         会话对象Id（会话targetId属性）
 *  @param conversationType 会话类型（单聊还是群聊）
 *  @param handler          结果回调。resultObject对象类型为TPIMConversation
 */
+ (void)getConversation:(NSString *)targetId
               withType:(TPIMConversationType)conversationType
      completionHandler:(TPIMCompletionHandler)handler;

/**
 *  创建新会话
 *
 *  @param targetId         会话对象Id（会话TargetId属性）
 *  @param conversationType 会话类型（单聊还是群聊）
 *  @param handler          结果回调。resultObject对象类型为TPIMConversation
 */
+ (void)createConversation:(NSString *)targetId
                  withType:(TPIMConversationType)conversationType
         completionHandler:(TPIMCompletionHandler)handler;


/**
 *  删除会话
 *
 *  @param targetId         会话对象Id（会话targetId属性）
 *  @param conversationType 会话类型（单聊还是群聊）
 *  @param handler          结果回调。resultObject对象类型为TPIMConversation
 */
+ (void)deleteConversation:(NSString *)targetId
                  withType:(TPIMConversationType)conversationType
         completionHandler:(TPIMCompletionHandler)handler;

@end
