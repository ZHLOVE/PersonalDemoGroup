//
//  TPIMMessageModel.h
//  HiTV
//
//  Created by yy on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPIMMessage.h"
#import "TPIMConstants.h"

/**
 *  接收消息通知
 */
extern NSString * const TPIMNotification_ReceiveMessages;       // xmpp消息（无论什么消息）
extern NSString * const TPIMNotification_ReceiveMessage_Type1;  // 关联消息
extern NSString * const TPIMNotification_ReceiveMessage_Type2;  // 开机快报消息
extern NSString * const TPIMNotification_ReceiveMessage_Type3;  // 欢迎快报
extern NSString * const TPIMNotification_ReceiveMessage_Type4;  // 投屏消息（远程投屏才提示）
extern NSString * const TPIMNotification_ReceiveMessage_Type5;  // 看单提醒
extern NSString * const TPIMNotification_ReceiveMessage_Type6;  // 分享消息
extern NSString * const TPIMNotification_ReceiveMessage_Type7;  // 约片消息
extern NSString * const TPIMNotification_ReceiveMessage_Type8;  // 手机快报
extern NSString * const TPIMNotification_ReceiveMessage_Type9;  // 投屏消息
extern NSString * const TPIMNotification_ReceiveMessage_Type10; // 投屏反馈消息
extern NSString * const TPIMNotification_ReceiveMessage_Type11; // 短视频消息
extern NSString * const TPIMNotification_ReceiveMessage_Type12; // 赠片消息
extern NSString * const TPIMNotification_ReceiveMessage_Type26; // 图片消息
extern NSString * const TPIMNotification_ReceiveMessage_Type28; // 有料短视频分享

//消息发送方式
typedef NS_ENUM(NSInteger, TPMessageSentMethod)
{
    kTPMessageSentMethod_ByHttp,//http发送
    kTPMessageSentMethod_ByXmpp//xmpp点对点消息
};

@class TPIMNodeModel;
@class TPIMContentModel;

@interface TPIMMessageModel : TPIMCustomMessage

/**
 *  消息id
 */
@property (nonatomic, copy) NSString *msgId;

/**
 *  from节点
 */
@property (nonatomic, retain) TPIMNodeModel *from;

/**
 *  存放to节点的数组
 */
@property (nonatomic, retain) NSArray *to;

/**
 *  消息类型
 */
@property (nonatomic, copy)   NSString *type;

/**
 *  消息标题
 */
@property (nonatomic, copy)   NSString *title;

/**
 *  用于远程推送
 */
@property (nonatomic, copy)   NSString *summary;

/**
 *  消息内容数据类型
 */
@property (nonatomic, retain) TPIMContentModel *contentModel;

/**
 *  保存消息标志位：1为保存，0为不保存
 */
@property (nonatomic, copy)   NSString *ext;

@property (nonatomic, copy)   NSString *persistent;


/**
 *  消息发送方式：http发送->kTPMessageSentMethod_ByHttp, xmpp点对点消息->kTPMessageSentMethod_ByXmpp
 */
@property (nonatomic, assign) TPMessageSentMethod sentMethod;

/**
 *  影片名称，用于聊天室约片
 */
@property (nonatomic, copy) NSString *videoname;

/**
 *  用XMPPMessage初始化
 *
 *  @param msg XMPPMessage
 *
 *  @return TPIMMessageModel
 */
- (instancetype)initWithXMPPMessage:(XMPPMessage *)msg;

/**
 *  发送消息
 *
 *  @param message 消息类型为TPIMMessageModel，消息发送结果通过监听通知TPIMNotification_SendMessageResult获得
 */
+ (void)sendMessage:(TPIMMessageModel *)message;

/**
 *  发送消息
 *
 *  @param message 消息类型为TPIMMessageModel
 *  @param handler 消息发送结果回调
 */
+ (void)sendMessage:(TPIMMessageModel *)message completionHandler:(TPIMCompletionHandler)handler;


@end
