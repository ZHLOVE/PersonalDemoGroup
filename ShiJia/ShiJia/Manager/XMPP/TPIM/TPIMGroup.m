//
//  TPIMGroup.m
//  XmppDemo
//
//  Created by yy on 15/7/10.
//  Copyright (c) 2015年 yy. All rights reserved.
//

#import "TPIMGroup.h"
#import "TPXmppManager.h"
#import "XMPPIQ.h"
#import "NSXMLElement+XMPP.h"
#import "TPIMUser.h"
#import "XMPPPresence.h"
#import "XMPPIQ.h"
#import "XMPPRoom.h"

NSString * const TPIMNotification_GroupChange = @"TPIMNotification_GroupChange";
NSString * const TPIMNotification_GroupChange_OccupantDidJoin = @"TPIMNotification_GroupChange_OccupantDidJoin";
NSString * const TPIMNotification_GroupChange_OccupantDidLeave = @"TPIMNotification_GroupChange_OccupantDidLeave";
NSString * const TPIMNotification_GroupMemberKey = @"TPIMNotification_GroupMemberKey";
NSString * const TPIMNotification_GroupNameKey = @"TPIMNotification_GroupNameKey";
NSString * const TPIMNotification_GroupChange_DidAcceptInvitation = @"TPIMNotification_GroupChange_DidAcceptInvitation";
NSString * const TPIMNotification_GroupChange_DidDeclineInvitation = @"TPIMNotification_GroupChange_DidDeclineInvitation";
NSString * const TPIMNotification_DeclineReasonKey = @"TPIMNotification_DeclineReasonKey";//拒绝理由
NSString * const TPIMNotification_GroupChange_DidLeave_ByDisconnection = @"TPIMNotification_GroupChange_DidLeave_ByDisconnection";
NSString * const TPIMNotification_LeaveChatRoom = @"TPIMNotification_LeaveChatRoom";

NSString * const TPChatRoomVideoIDKey = @"TPChatRoomVideoIDKey";
NSString * const TPChatRoomVideoStartTimeKey = @"TPChatRoomVideoStartTimeKey";
NSString * const TPChatRoomVideoNameKey = @"TPChatRoomVideoNameKey";
NSString * const TPChatRoomXmppRoomKey = @"TPChatRoomXmppRoomKey";

@interface TPIMGroup ()

@property (atomic,strong,readwrite) NSString *gid;
@property (atomic,strong,readwrite) NSString *groupOwner;
@property (atomic,assign,readwrite) NSInteger limitNum;
@property (atomic,assign,readwrite) NSInteger occupantNum;

@end

@implementation TPIMGroup

@synthesize gid,groupOwner,groupName,groupDescription,group_members;

+ (void)createGroup:(TPIMGroup *)group completionHandler:(TPIMCompletionHandler)handler
{
    if (group == nil || group.groupName.length == 0) {
        DDLogInfo(@"群组信息不能为空");
        return;
    }
    
    [[TPXmppManager defaultManager] joinRoom:group.groupName isPublicRoom:group.isPublicGroup];
    [[TPXmppManager defaultManager] setRoomManagerHandler:^(id responseObject, NSError *error){
    
        handler(responseObject, error);
    }];
}


+ (void)addMembers:(NSString *)groupId members:(NSString *)members message:(NSString *)message completionHandler:(TPIMCompletionHandler)handler
{

//    [[TPXmppManager defaultManager] addMembersToRoom:groupId members:members message:message];
//    [[TPXmppManager defaultManager] setOccupantManagerHandler:^(id responseObject, NSError *error) {
//        handler(responseObject, error);
//    }];
    
}


+ (void)deleteGroupMember:(NSString *)groupId members:(NSString *)members completionHandler:(TPIMCompletionHandler)handler
{

}


+ (void)exitRoom:(XMPPRoom *)room  isPublicRoom:(BOOL)isPublic completionHandler:(TPIMCompletionHandler)handler
{
    [[TPXmppManager defaultManager] leaveXmppRoom:room isPublicRoom:isPublic];
    [[TPXmppManager defaultManager] setRoomManagerHandler:^(id responseObject, NSError *error){
        handler(responseObject,error);
    }];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_LeaveChatRoom object:nil];
}

+ (void)destroyGroup:(NSString *)groupId completionHandler:(TPIMCompletionHandler)handler
{
    /*
     <iq from='crone1@shakespeare.lit/desktop'
     id='begone'
     to='heath@chat.shakespeare.lit'
     type='set'>
     <query xmlns='http://jabber.org/protocol/muc#owner'>
     <destroy jid='darkcave@chat.shakespeare.lit'>
     <reason>Macbeth doth come.</reason>
     </destroy>
     </query>
     </iq>
     */
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:[[TPXmppManager defaultManager] roomJidWithRoomName:groupId]];
    NSXMLElement *query = [[NSXMLElement alloc] initWithName:@"query" xmlns:XMPPMUCOwnerNamespace];
    NSXMLElement *destroy = [[NSXMLElement alloc] initWithName:@"destroy"];
    [destroy addAttributeWithName:@"jid" stringValue:[[[TPXmppManager defaultManager] roomJidWithRoomName:groupId] bare]];
    NSXMLElement *reason = [[NSXMLElement alloc] initWithName:@"reason" stringValue:@"Room is Empty"];
    
    [destroy addChild:reason];
    [query addChild:destroy];
    [iq addChild:query];
    [[TPXmppManager defaultManager] sendIQ:iq];
//    [[TPXmppManager defaultManager] destoryRoom:groupId];
    [[TPXmppManager defaultManager] setRoomManagerHandler:^(id responseObject, NSError *error){
        handler(responseObject,error);
    }];
}

+ (void)updateGroupInfo:(TPIMGroup *)group completionHandler:(TPIMCompletionHandler)handler
{
//    [[TPXmppManager defaultManager] updateRoom:nil];
    [[TPXmppManager defaultManager] setRoomManagerHandler:^(id responseObject, NSError *error){
    
    }];

}

+ (void)getGroupMemberList:(NSString *)groupId completionHandler:(TPIMCompletionHandler)handler
{
    
}

+ (void)getGroupMemberListInRoom:(XMPPRoom *)room completionHandler:(TPIMCompletionHandler)handler
{
    [[TPXmppManager defaultManager] getMemberListInXmppRoom:room];
    [[TPXmppManager defaultManager] setRoomManagerHandler:^(NSArray *responseObject, NSError *error){
        if (error == nil) {
            NSMutableArray *users = [[NSMutableArray alloc] init];
            for (NSXMLElement *item in responseObject) {
                TPIMUser *user = [[TPIMUser alloc] init];
                user.nickname = [item attributeStringValueForName:@"nick"];
                user.username = [item attributeStringValueForName:@"nick"];
                XMPPJID *jid = [XMPPJID jidWithString:[item attributeStringValueForName:@"jid"]];
                user.jid = [jid bare];
                
                if (jid.bare.length != 0) {
                    user.headImage = [[TPXmppManager defaultManager] getAvatarImageWithUsername:[jid bare]];
                }
                
                [users addObject:user];
                
            }
            handler(users,error);
        }
        else{
            //error
            handler(responseObject,error);
        }
    }];
}


+ (void)getGroupListWithCompletionHandler:(TPIMCompletionHandler)handler
{
    //[[TPXmppManager defaultManager] getRoomList];
}

+ (void)getGroupInfo:(NSString *)groupId completionHandler:(TPIMCompletionHandler)handler
{
    [[TPXmppManager defaultManager] getRoomInfo:groupId];
    [[TPXmppManager defaultManager] setRoomManagerHandler:^(id responseObject, NSError *error){
        
        if (error == nil) {
            
            if ([responseObject isKindOfClass:[XMPPIQ class]]) {
                //返回xmppiq
                XMPPIQ *iq = (XMPPIQ *)responseObject;
                TPIMGroup *group = [[TPIMGroup alloc] init];
                
                //jid
                group.gid = [iq attributeStringValueForName:@"from"];
                
                //name
                NSXMLElement *query = [iq elementForName:@"query"];
                NSXMLElement *identity = [query elementForName:@"identity"];
                group.groupName = [identity attributeStringValueForName:@"name"];
                
                
                NSXMLElement *x = [query elementForName:@"x"];
                for (NSXMLElement *field in x.children) {
                    NSXMLElement *value = [field elementForName:@"value"];
                    NSString *var = [field attributeStringValueForName:@"var"];
                    if ([var isEqualToString:@"muc#roominfo_description"]) {
                        //description
                        group.groupDescription = [value stringValue];
                        
                    }
                    else if ([var isEqualToString:@"muc#roominfo_occupants"]){
                        //occupant number
                        group.occupantNum = [[value stringValue] integerValue];
                    }
                }
                handler(group, error);
            }
            else{
                //返回其他内容
                handler(responseObject, error);
            }
            
        }
        else{
            handler(responseObject,error);
        }
        
    }];
}

@end
