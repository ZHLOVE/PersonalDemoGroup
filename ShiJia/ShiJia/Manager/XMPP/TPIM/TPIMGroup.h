//
//  TPIMGroup.h
//  XmppDemo
//
//  Created by yy on 15/7/10.
//  Copyright (c) 2015年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPIMConstants.h"
@class XMPPRoom;

/**
 * 收取收到群成员变更通知和key,用以更新当前会话展示的群组信息
 */
extern NSString * const TPIMNotification_GroupChange;
extern NSString * const TPIMNotification_GroupChange_OccupantDidJoin;
extern NSString * const TPIMNotification_GroupChange_OccupantDidLeave;
extern NSString * const TPIMNotification_GroupMemberKey;
extern NSString * const TPIMNotification_GroupChange_DidAcceptInvitation;//接受邀请通知
extern NSString * const TPIMNotification_GroupChange_DidDeclineInvitation;//拒绝邀请通知
extern NSString * const TPIMNotification_DeclineReasonKey;//拒绝理由
extern NSString * const TPIMNotification_GroupNameKey;
extern NSString * const TPIMNotification_LeaveChatRoom;

extern NSString * const TPChatRoomVideoIDKey;
extern NSString * const TPChatRoomVideoStartTimeKey;
extern NSString * const TPChatRoomVideoNameKey;
extern NSString * const TPChatRoomXmppRoomKey;
extern NSString * const TPIMNotification_GroupChange_DidLeave_ByDisconnection;


@interface TPIMGroup : NSObject
/**
 *  群组的gid,即jid
 */
@property (atomic,strong,readonly) NSString *gid;

/**
 *  群组的拥有者
 */
@property (atomic,strong,readonly) NSString *groupOwner;

/**
 *  群组的名称
 */
@property (atomic,strong) NSString *groupName;

/**
 *  群组的描述
 */
@property (atomic,strong) NSString *groupDescription;

/**
 *  群组成员,由每个成员的username,通过,(逗号)来分隔组成
 */
@property (atomic,strong) NSString *group_members;

/**
 *  房间人数上限
 */
@property (atomic, assign, readonly) NSInteger limitNum;

/**
 *  房间成员数量
 */
@property (atomic, assign, readonly) NSInteger occupantNum;

/**
 *  是否为公共房间
 */
@property (atomic, assign) BOOL isPublicGroup;

/**
 *  创建一个群组
 *  group对象可填写信息为:groupName,groupDescription,group_flag(暂时无用处)
 *  创建群组SDK自动会被自己加入group_members中,不需要自己做处理
 *
 *  @param group             待创建的群组
 *  @param completionHandler 结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)createGroup:(TPIMGroup *)group
  completionHandler:(TPIMCompletionHandler)handler;

/**
 *  向群组中添加成员
 *
 *  @param groupId       群组ID
 *  @param members       需要加入的群组成员(username)。多个成员时使用,(逗号)隔开。
 *  @param message       邀请理由
 *  @param callbackBlock 结果回调。resultObject值不需要关心,始终为nil
  */
+ (void)addMembers:(NSString *)groupId
           members:(NSString *)members
           message:(NSString *)message
 completionHandler:(TPIMCompletionHandler)handler;

/**
 * 群组删除成员
 *
 *  @param groupID       群组的ID
 *  @param members       需要删除的群组成员(username)。多个成员时使用,(逗号)隔开。
 *  @param callbackBlock 结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)deleteGroupMember:(NSString *)groupId
                  members:(NSString *)members
        completionHandler:(TPIMCompletionHandler)handler;

/**
 *  用户退出群组
 *
 *  @param room          待退出的room
 *  @param isPublic      是否为公共房间
 *  @param callbackBlock 结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)exitRoom:(XMPPRoom *)room  isPublicRoom:(BOOL)isPublic completionHandler:(TPIMCompletionHandler)handler;

/**
 *  更新群组信息
 *
 *  @param group         待更新的群组,目前支持的变更支持groupName,groupDescription,group_flag(暂时无用处)
 *  @param handler       结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)updateGroupInfo:(TPIMGroup *)group
      completionHandler:(TPIMCompletionHandler)handler;

/**
 *  获取一个群的所有组成员列表
 *
 *  @param handler       结果回调。正常返回时resultObject对象类型为NSArray,成员为TPIMUser类型。
 */
+ (void)getGroupMemberList:(NSString *)groupId
         completionHandler:(TPIMCompletionHandler)handler;

+ (void)getGroupMemberListInRoom:(XMPPRoom *)room
               completionHandler:(TPIMCompletionHandler)handler;
/**
 *  获取当前登录用户（我）的所有群组列表
 *
 *  @param handler       结果回调。正常返回时resultObject对象类型为NSArray,成员为TPIMGroup类型。
 *
 */
+ (void)getGroupListWithCompletionHandler:(TPIMCompletionHandler)handler;

/**
 * 获取群组信息
 *
 * @param groupId        群组ID。
 * @param handler        结果回调。正常返回时resultObject对象类型为TPIMGroup。
 *
 */
+ (void)getGroupInfo:(NSString *)groupId
   completionHandler:(TPIMCompletionHandler)handler;

/**
 *  销毁群组
 *
 *  @param groupId 群组ID
 *  @param handler 结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)destroyGroup:(NSString *)groupId
   completionHandler:(TPIMCompletionHandler)handler;

@end
