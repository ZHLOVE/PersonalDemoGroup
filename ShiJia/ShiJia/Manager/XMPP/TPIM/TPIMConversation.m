//
//  TPIMConversation.m
//  XmppDemo
//
//  Created by yy on 15/7/9.
//  Copyright (c) 2015年 yy. All rights reserved.
//

#import "TPIMConversation.h"
#import "TPXmppManager.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "TPIMMessage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardAvatarModule.h"

/**
 *  会话变更通知（用来当SDK后台更新会话信息时刷新界面使用）
 */
NSString * const TPIMNotification_ConversationInfoChanged = @"TPIMNotification_ConversationInfoChanged";
NSString * const TPIMNotification_ConversationInfoChangedKey = @"TPIMNotification_ConversationInfoChangedKey";

@implementation TPIMConversation

#pragma mark -
- (void)getMessage:(NSString *)messageId completionHandler:(TPIMCompletionHandler)handler
{
    [[TPXmppManager defaultManager] getMessageListOfUser:self.targetId completion:^(NSArray *result, NSError *error) {
        
    }];
}

- (void)getAllMessageWithCompletionHandler:(TPIMCompletionHandler)handler
{
    
    if (self.targetId == nil) {
        if (self.chatType == kTPIMGroup) {
            self.targetId = [[TPXmppManager defaultManager] roomJidWithRoomName:self.targetName].full;
            
        }
        else{
            self.targetId = [[TPXmppManager defaultManager] jidWithUsername:self.targetName].full;
        }
    }
    [[TPXmppManager defaultManager] getMessageListOfUser:self.targetId completion:^(NSArray *result, NSError *error)
     {
         NSMutableArray *array = [[NSMutableArray alloc] init];
         for (XMPPMessageArchiving_Message_CoreDataObject *msgObject in result) {
             
             TPIMContentMessage *msg = [[TPIMContentMessage alloc] initWithXMPPMessage:msgObject.message];
             if (msg.fromId.length != 0 && msg.fromName.length != 0 && [msg.contentText rangeOfString:@"Room is locked"].location == NSNotFound && [msg.contentText rangeOfString:@"Room is now unlocked"].location == NSNotFound) {
                 [array addObject:msg];
             }
             
         }
         handler(array,error);
         
     }];
}

- (void)deleteAllMessageWithCompletionHandler:(TPIMCompletionHandler)handler
{

}

- (void)resetUnreadMessageCountWithCompletionHandler:(TPIMCompletionHandler)handler
{

}

#pragma mark -
+ (void)getConversationListWithCompletionHandler:(TPIMCompletionHandler)handler
{
    NSArray *conversations = [[TPXmppManager defaultManager] getConversationList];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    //取最后一条消息
    for (XMPPMessageArchiving_Message_CoreDataObject *object in conversations) {
        XMPPMessageArchiving_Message_CoreDataObject *data = [dic valueForKey:object.bareJidStr];
        if (data != nil) {
            NSTimeInterval dataTimeInterval = [data.timestamp timeIntervalSince1970];
            NSTimeInterval objectTimeInterval = [object.timestamp timeIntervalSince1970];
            
            if (objectTimeInterval > dataTimeInterval) {
                [dic setValue:object forKey:object.bareJidStr];
            }
        }
        else{
            [dic setValue:object forKey:object.bareJidStr];
        }
        
    }
    
    //将 XMPPMessageArchiving_Message_CoreDataObject 转换成 TPIMConversation
    for (XMPPMessageArchiving_Message_CoreDataObject *object in dic.allValues) {
        TPIMConversation *conversation = [[TPIMConversation alloc] init];
        conversation.targetId = object.bareJidStr;
        
        conversation.targetName = [object.bareJid user];
        if ([object.message.type isEqualToString:@"groupchat"]) {
            conversation.chatType = kTPIMGroup;
        }
        else if([object.message.type isEqualToString:@"chat"]){
            conversation.chatType = kTPIMSingle;
        }
        conversation.lastestType = [object.message attributeStringValueForName:@"bodyType"];
        conversation.avatarThumb = [[TPXmppManager defaultManager] getAvatarImageWithUsername:object.bareJidStr];
        conversation.lastestText = object.body;
        conversation.lastestDisplayName = [object.bareJid user];
        conversation.lastestDate = [NSString stringWithFormat:@"%@",object.timestamp];
        if (object.isOutgoing) {
            conversation.lastestDisplayName = [object.bareJid user];
        }
        else{
//            conversation.lastestDisplayName = 
        }
        [array addObject:conversation];
    }

    handler(array, nil);
}

+ (void)getConversation:(NSString *)targetId withType:(TPIMConversationType)conversationType completionHandler:(TPIMCompletionHandler)handler
{

}

+ (void)createConversation:(NSString *)targetId withType:(TPIMConversationType)conversationType completionHandler:(TPIMCompletionHandler)handler
{

}

+ (void)deleteConversation:(NSString *)targetId withType:(TPIMConversationType)conversationType completionHandler:(TPIMCompletionHandler)handler
{

}

@end
