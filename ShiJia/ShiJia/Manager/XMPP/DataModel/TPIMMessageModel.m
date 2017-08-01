//
//  TPIMMessageModel.m
//  HiTV
//
//  Created by yy on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPIMMessageModel.h"
#import "NSObject+MJKeyValue.h"
#import "TPMessageRequest.h"
#import "TPXmppManager.h"
#import "TPIMNodeModel.h"
#import "XMPPMessage.h"
#import "NSXMLElement+XMPP.h"
#import "TPIMEpgData.h"
#import "TPIMContentModel.h"

NSString * const TPIMNotification_ReceiveMessages = @"TPIMNotification_ReceiveMessages";
NSString * const TPIMNotification_ReceiveMessage_Type1 = @"TPIMNotification_ReceiveMessage_Type1";// 关联消息
NSString * const TPIMNotification_ReceiveMessage_Type2 = @"TPIMNotification_ReceiveMessage_Type2";// 开机快报消息
NSString * const TPIMNotification_ReceiveMessage_Type3 = @"TPIMNotification_ReceiveMessage_Type3";// 欢迎快报
NSString * const TPIMNotification_ReceiveMessage_Type4 = @"TPIMNotification_ReceiveMessage_Type4";// 投屏消息（远程投屏才提示）
NSString * const TPIMNotification_ReceiveMessage_Type5 = @"TPIMNotification_ReceiveMessage_Type5";// 看单提醒
NSString * const TPIMNotification_ReceiveMessage_Type6 = @"TPIMNotification_ReceiveMessage_Type6";// 分享消息
NSString * const TPIMNotification_ReceiveMessage_Type7 = @"TPIMNotification_ReceiveMessage_Type7";// 约片消息
NSString * const TPIMNotification_ReceiveMessage_Type8 = @"TPIMNotification_ReceiveMessage_Type8";// 手机快报
NSString * const TPIMNotification_ReceiveMessage_Type9 = @"TPIMNotification_ReceiveMessage_Type9";// 投屏消息
NSString * const TPIMNotification_ReceiveMessage_Type10 = @"TPIMNotification_ReceiveMessage_Type10";// 投屏反馈消息
NSString * const TPIMNotification_ReceiveMessage_Type11 = @"TPIMNotification_ReceiveMessage_Type11";// 短视频消息
NSString * const TPIMNotification_ReceiveMessage_Type12 = @"TPIMNotification_ReceiveMessage_Type12";// 赠片消息
NSString * const TPIMNotification_ReceiveMessage_Type26 = @"TPIMNotification_ReceiveMessage_Type26";// 图片分享
NSString * const TPIMNotification_ReceiveMessage_Type28 = @"TPIMNotification_ReceiveMessage_Type28";// 有料短视频分享
@interface TPIMMessageModel ()

@property (nonatomic, copy) NSString *content;

@end

@implementation TPIMMessageModel

#pragma mark - init
- (instancetype)initWithXMPPMessage:(XMPPMessage *)msg
{
    self = [super initWithXMPPMessage:msg];
    if (self) {
        self.title = [msg subject];
        
        NSError *error = nil;
        self.content = msg.body;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[msg.body dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
//        NSDictionary *epgDic = [dic valueForKey:@"epgData"];
        self.contentModel = [TPIMContentModel mj_objectWithKeyValues:dic];
//        self.contentModel.epgDataModel = [TPIMEpgData objectWithKeyValues:epgDic];
        
        NSXMLElement *yst = [msg elementForName:@"yst"];
        if (yst != nil) {
            
            NSXMLElement *fromE = [yst elementForName:@"from"];
            self.from = [[TPIMNodeModel alloc] initWithElement:fromE];
            
            NSXMLElement *toE = [yst elementForName:@"to"];
            TPIMNodeModel *toNode = [[TPIMNodeModel alloc] initWithElement:toE];
            self.to = [NSArray arrayWithObject:toNode];
            
            self.type = [yst elementForName:@"type"].stringValue;
            
            NSXMLElement *msgIdE = [yst elementForName:@"msgId"];
            if (msgIdE) {
                self.msgId = msgIdE.stringValue;
            }
            
            
        }
    }
    return self;
}

#pragma mark - send message
+ (void)sendMessage:(TPIMMessageModel *)message
{
    
    if (message.sentMethod == kTPMessageSentMethod_ByHttp) {
        
        [TPMessageRequest sendMessage:message completion:^(id responseObject, NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_SendMessageResult object:self];
        }];
    }
    else{
        if (message.to.count == 0) {
            return;
        }
        if (message.from == nil) {
            TPIMNodeModel *fromNode = [[TPIMNodeModel alloc] init];
            fromNode.uid = [HiTVGlobals sharedInstance].uid;
            fromNode.jid = [HiTVGlobals sharedInstance].xmppUserId;
            fromNode.nickname = [HiTVGlobals sharedInstance].nickName;
            //            fromNode.nickname = [[HiTVGlobals sharedInstance].nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            message.from = fromNode;
        }
        for (TPIMNodeModel *toNode in message.to) {
            XMPPMessage *msg = [[self class] convertMessageToXmppMessage:message toNode:toNode];
            
            NSString *subjectStr = message.title.length == 0 ? message.contentModel.content : message.title;
            NSXMLElement *subject = [NSXMLElement elementWithName:@"subject" stringValue:subjectStr];
            [msg addChild:subject];
            
            [[TPXmppManager defaultManager] sendMessage:msg];
        }
        
    }
    
}

+ (void)sendMessage:(TPIMMessageModel *)message completionHandler:(TPIMCompletionHandler)handler
{
    if (message.sentMethod == kTPMessageSentMethod_ByHttp) {
        //通过http发消息
        [TPMessageRequest sendMessage:message completion:^(id responseObject, NSError *error) {
            handler(responseObject,error);
        }];
    }
    else{
        if (message.to.count == 0) {
            return;
        }
        if (message.from == nil) {
            TPIMNodeModel *fromNode = [[TPIMNodeModel alloc] init];
            fromNode.uid = [NSString stringWithFormat:@"%@",[HiTVGlobals sharedInstance].uid];
            fromNode.jid = [HiTVGlobals sharedInstance].xmppUserId;
            fromNode.nickname = [HiTVGlobals sharedInstance].nickName;
            //            fromNode.nickname = [[HiTVGlobals sharedInstance].nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            message.from = fromNode;
        }
        for (TPIMNodeModel *toNode in message.to) {
            XMPPMessage *msg = [[self class] convertMessageToXmppMessage:message toNode:toNode];
            
            NSString *subjectStr = message.title.length == 0 ? message.contentModel.content : message.title;
            NSXMLElement *subject = [NSXMLElement elementWithName:@"subject" stringValue:subjectStr];
            [msg addChild:subject];
            
            [[TPXmppManager defaultManager] sendMessage:msg];
            
        }
        [[TPXmppManager defaultManager] setSendMessageHandler:^(id responseObject, NSError *error){
            handler(responseObject, error);
        }];
    }
}

+ (XMPPMessage *)convertMessageToXmppMessage:(TPIMMessageModel *)message toNode:(TPIMNodeModel *)toNode
{
    
    if (toNode.jid.length == 0) {
        return nil;
    }
    
    XMPPMessage *xmppmessage = [[XMPPMessage alloc] init];
    
    [xmppmessage addAttributeWithName:@"to" stringValue:toNode.jid];
    
    [xmppmessage addBody:[message.content mj_JSONString]];
    [xmppmessage addSubject:message.title];
    
    //yst
    NSXMLElement *yst = [[NSXMLElement alloc] initWithName:@"yst"];
    
    //from
    if (message.from == nil) {
        [xmppmessage addAttributeWithName:@"from" stringValue:[HiTVGlobals sharedInstance].xmppUserId];
        
        TPIMNodeModel *fromNode = [[TPIMNodeModel alloc] init];
        fromNode.uid = [HiTVGlobals sharedInstance].uid;
        fromNode.jid = [HiTVGlobals sharedInstance].xmppUserId;
        
        fromNode.nickname = [HiTVGlobals sharedInstance].nickName;
        
        NSXMLElement *from = [[NSXMLElement alloc] initWithName:@"from"];
        [from addAttributeWithName:@"uid" stringValue:fromNode.uid];
        [from addAttributeWithName:@"nickname" stringValue:fromNode.nickname];
        //        [from addAttributeWithName:@"nickname" stringValue:[fromNode.nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [from addAttributeWithName:@"jid" stringValue:fromNode.jid];
        [yst addChild:from];
    }
    else{
        
        NSXMLElement *from = [[NSXMLElement alloc] initWithName:@"from"];
        [from addAttributeWithName:@"uid" stringValue:message.from.uid];
        [from addAttributeWithName:@"nickname" stringValue:message.from.nickname];
        //        [from addAttributeWithName:@"nickname" stringValue:[message.from.nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [from addAttributeWithName:@"jid" stringValue:message.from.jid];
        [yst addChild:from];
    }
    
    //to
    NSXMLElement *to = [[NSXMLElement alloc] initWithName:@"to"];
    [to addAttributeWithName:@"uid" stringValue:toNode.uid];
    [to addAttributeWithName:@"nickname" stringValue:toNode.nickname];
    [to addAttributeWithName:@"jid" stringValue:toNode.jid];
    
    [yst addChild:to];
    
    //type
    NSXMLElement *type = [[NSXMLElement alloc] initWithName:@"type" stringValue:message.type];
    [yst addChild:type];
    
    [xmppmessage addChild:yst];
    return xmppmessage;
}

- (void)setContentModel:(TPIMContentModel *)contentModel
{
    _contentModel = contentModel;
    self.content = [contentModel mj_JSONString];
}

#pragma mark - MJExtension
+ (NSArray *)mj_ignoredPropertyNames
{
    
    return @[@"sentMethod",@"messageId",@"targetId",@"targetName",@"fromId",@"fromName",@"displayName",@"extras",@"conversationType",@"contentType",@"timestamp",@"status",@"custom",@"contentModel",@"videoname"];
}

@end
