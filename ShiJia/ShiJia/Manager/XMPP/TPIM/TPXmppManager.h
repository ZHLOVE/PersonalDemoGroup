//
//  TPXmppServiceManager.h
//  XmppDemo
//
//  Created by yy on 7/2/15.
//  Copyright (c) 2015 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TPIMConstants.h"
#import "XMPPMessage.h"


@class TPIMGroup;
@class XMPPvCardTemp;
@class XMPPvCardAvatarModule;
@class XMPPRoom;
@class XMPPJID;
@class XMPPPresence;
@class XMPPIQ;
@class XMPPStream;
@class TPIMUser;

@interface TPXmppManager : NSObject

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, copy) TPIMCompletionHandler loginHandler;   //登录回调
@property (nonatomic, copy) TPIMCompletionHandler registerHandler;//注册回调
@property (nonatomic, copy) TPIMCompletionHandler logoutHandler;  //登出回调
@property (nonatomic, copy) TPIMCompletionHandler userManagerHandler; //用户管理回调（添加、删除、获取好友列表）
@property (nonatomic, copy) TPIMCompletionHandler roomManagerHandler; //房间管理回调（创建、销毁、邀请好友...）
@property (nonatomic, copy) TPIMCompletionHandler messageHandler;//消息管理回调
@property (nonatomic, copy) TPIMCompletionHandler occupantManagerHandler;//出席房间回调
@property (nonatomic, copy) TPIMCompletionHandler sendMessageHandler;//发送消息回调
@property (nonatomic, copy) TPIMCompletionHandler vcardHandler;//vcard回调

#pragma mark - init
/* Returns the default singleton instance.
 */
+ (TPXmppManager *)defaultManager;

#pragma mark - login
/**
 *  用户登录接口
 *
 *  @param account  用户名
 *  @param password 用户密码
 *  @param hostName 主机名
 *  @param hostPort 端口号
 *  @param resource 资源
*/
- (void)connectWithAccount:(NSString *)account password:(NSString *)password host:(NSString *)host hostName:(NSString *)hostName hostPort:(UInt16)hostPort resource:(NSString *)resource;


#pragma mark - logout
/**
 *  登出接口
 */
- (void)disconnect;

#pragma mark - register
/**
 *  用户注册接口
 *
 *  @param account  用户名
 *  @param password 用户密码
 *  @param hostName 主机名
 *  @param hostPort 端口号
 *  @param resource 资源
 */
- (void)registerWithAccount:(NSString *)account password:(NSString *)password host:(NSString *)host hostName:(NSString *)hostName hostPort:(UInt16)hostPort resource:(NSString *)resource;

#pragma mark - user info
/**
 *  获取用户信息
 *
 *  @param username 用户名
 *
 *  @return 返回XMPPvCardTemp数据
 */
- (XMPPvCardTemp *)getUservCardTempWithUsername:(NSString *)username;

/**
 *  获取登录用户头像
 *
 *  @return 返回 XMPPvCardTemp
 */
- (XMPPvCardTemp *)getMyvCardTemp;

/**
 *  获取登录用户信息
 *
 *  @return 返回Dictionary
 */
- (NSDictionary *)getMyInfo;

- (void)updateMyInfo;

/**
 *  获取nickname
 *
 *  @param username 登录用户名
 *
 *  @return nickname
 */
- (NSString *)getNickNameWithUsername:(NSString *)username;

/**
 *  获取用户头像
 *
 *  @param username 用户uid/jid
 *
 *  @return 返回头像image
 */
- (UIImage *)getAvatarImageWithUsername:(NSString *)username;

- (NSString *)getAvatarImageUrlWithUsername:(NSString *)username;
- (TPIMUser *)getUserInfoWithUsername:(NSString *)username;


/**
 *  获取用户头像
 *
 *  @param username 用户uid/jid
 */
- (void)getAvatarWithUsername:(NSString *)username;

/**
 *  获取用户jid
 *
 *  @param username 用户name
 *
 *  @return 返回jid
 */
- (XMPPJID *)jidWithUsername:(NSString *)username;


#pragma mark - message
/**
 *  获取消息列表
 */
- (void)getMessageList;

/**
 *  获取对话列表
 *
 *  @return 返回列表
 */
- (NSArray *)getConversationList;

/**
 *  获取某用户的消息列表
 *
 *  @param user       用户名
 *  @param completion 回调
 */
- (void)getMessageListOfUser:(NSString *)user completion:(void(^)(NSArray* result,NSError *error))completion;

/**
 *  发送消息
 *
 *  @param message 消息内容
 *  @param type    消息类型
 *  @param user    接收用户的name
 */
- (void)sendMessage:(NSString *)message type:(NSString *)type to:(NSString *)user;

/**
 *  发送消息
 *
 *  @param message
 */
- (void)sendMessage:(XMPPMessage *)message;

/**
 *  发送消息
 *
 *  @param message
 *  @param count   消息个数
 */
- (void)sendMessage:(XMPPMessage *)message totalCount:(NSInteger)count;

#pragma mark - group
/**
 *  创建聊天室/主动加入聊天室
 *
 *  @param roomname 聊天室名称
 */
- (void)joinRoom:(NSString *)roomname isPublicRoom:(BOOL)isPublic;

/**
 *  离开聊天室
 *
 *  @param room 聊天室
 *  @param isPublic 是否为公共房间
 */
- (void)leaveXmppRoom:(XMPPRoom *)room isPublicRoom:(BOOL)isPublic;

/**
 *  销毁聊天室
 *
 *  @param roomname 聊天室名称
 */
- (void)destoryRoom:(NSString *)roomname;

/**
 *  获取聊天室成员列表
 *
 *  @param roomname 聊天室名称
 */
- (void)getMemberListInRoom:(NSString *)roomname;

- (void)getMemberListInXmppRoom:(XMPPRoom *)room;

///**
// *  更新聊天室信息
// *
// *  @param room 聊天室
// */
//- (void)updateRoom:(XMPPRoom *)room;

/**
 *  获取聊天室信息
 *
 *  @param roomname 聊天室名称
 */
- (void)getRoomInfo:(NSString *)roomname;

/**
 *  获取房间jid
 *
 *  @param name 房间名
 *
 *  @return 房间jid
 */
- (XMPPJID *)roomJidWithRoomName:(NSString *)name;

- (XMPPRoom *)xmppRoomWithRoomName:(NSString *)name isPublicRoom:(BOOL)isPublic;

#pragma mark - presence
/**
 *  发送presence
 *
 *  @param presence
 */
- (void)sendPresence:(XMPPPresence *)presence;

#pragma mark - iq
/**
 *  发送iq
 *
 *  @param iq
 */
- (void)sendIQ:(XMPPIQ *)iq;

@end
