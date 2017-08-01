//
//  TPIMMessage.m
//  XmppDemo
//
//  Created by yy on 15/7/9.
//  Copyright (c) 2015年 yy. All rights reserved.
//

#import "TPIMMessage.h"
#import "TPXmppManager.h"
#import "XMPPMessage.h"
#import "XMPPJID.h"
#import "NSXMLElement+XMPP.h"
#import "TPIMContentModel.h"
#import "TPXmppRoomManager.h"
#import "TPIMUser.h"

/**
 *  发送消息返回通知（用来监听消息发送的结果）
 */
NSString * const TPIMNotification_SendMessageResult = @"TPIMNotification_SendMessageResult";

/**
 *  收取收到消息通知（用来接收所有收到的消息）
 */
NSString * const TPIMNotification_ReceiveMessage = @"TPIMNotification_ReceiveMessage";
NSString * const TPIMNotification_MessageKey = @"TPIMNotification_MessageKey";

/**
 *  收取事件消息通知（用来接收所有收到的Event事件）
 */
NSString * const TPIMNotification_EventMessage = @"TPIMNotification_EventMessage";
NSString * const TPIMNotification_EventKey = @"TPIMNotification_EventKey";
NSString * const TPIMNotification_WillStartPlayVoiceMessage = @"TPIMNotification_WillStartPlayVoiceMessage";
NSString * const TPIMNotification_DidFinishPlayingVoiceMessage = @"TPIMNotification_DidFinishPlayingVoiceMessage";

@interface TPIMMessage ()

@property(atomic, strong, readwrite) NSString *messageId;
@property(atomic, strong,readwrite) NSString *fromId;
//@property(atomic, strong,readwrite) NSString *fromName;
@property (atomic, strong, readwrite) NSString *roomId;
@property(nonatomic, strong, readwrite) NSString *displayName;
@property(assign, readwrite) TPIMMessageContentType contentType;
@property(atomic, strong, readwrite) NSNumber *timestamp;
@property(strong, readwrite) NSNumber *status;

@end

@implementation TPIMMessage
@synthesize messageId,targetId,targetName,fromId,fromName,displayName,extras,contentType,conversationType,timestamp,status;

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithXMPPMessage:(XMPPMessage *)msg
{
    self = [super init];
    if (self) {
        XMPPJID *tojid = [XMPPJID jidWithString:[msg attributeStringValueForName:@"to"]];
        self.targetId = [tojid bare];
        self.targetName = [tojid user];
        
        XMPPJID *fromjid = [XMPPJID jidWithString:[msg attributeStringValueForName:@"from"]];
        self.fromId = [fromjid bare];
        self.fromName = [fromjid user];
        
        
        if ([msg.type isEqualToString:@"chat"]) {
            self.conversationType = kTPIMSingle;
        }
        else if ([msg.type isEqualToString:@"groupchat"]){
            
            self.conversationType = kTPIMGroup;
            self.roomId = [fromjid bare];
            self.fromId = [fromjid resource];
            self.fromName = [fromjid resource];
            
            NSString *fid = [NSString stringWithFormat:@"%@@%@",[fromjid resource],[TPIMUser xmppHostName]];
            self.fromHeadImage = [[TPXmppRoomManager defaultManager] getHeadImageWithJid:fid];
            self.fromName = [[TPXmppRoomManager defaultManager] getNicknameWithJid:fid];
            //            self.fromId = [NSString stringWithFormat:@"%@@%@",[fromjid resource],XMPP_HostName];
            //            self.fromName = [[TPXmppRoomManager defaultManager] getNicknameWithJid:self.fromName];
        }
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return nil;
}


#pragma mark - message
+ (void)sendMessage:(TPIMMessage *)message
{
    if ([[message class] isSubclassOfClass:[TPIMContentMessage class]]) {
        [TPIMContentMessage sendMessage:message];
    }
    else if ([[message class] isSubclassOfClass:[TPIMVoiceMessage class]]){
        [TPIMVoiceMessage sendMessage:message];
    }
    else{
        NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
    }
    
}

+ (void)sendSingleTextMessage:(NSString *)content toUsername:(NSString *)targetId
{
    
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)sendSingleImageMessage:(NSData *)imageData toUsername:(NSString *)username
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)sendSingleVoiceMessage:(NSData *)voiceData toUsername:(NSString *)username
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)downloadOriginImage:(TPIMImageMessage *)message withProgress:(NSProgress *)progress completionHandler:(TPIMCompletionHandler)handler
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)downloadThumbImage:(TPIMImageMessage *)message withProgress:(NSProgress *)progress completionHandler:(TPIMCompletionHandler)handler
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)downloadVoice:(TPIMVoiceMessage *)message withProgress:(NSProgress *)progress completionHandler:(TPIMCompletionHandler)handler
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

@end


///----------------------------------------------------
/// @name Message Children class 消息子类（根据消息类型的不同）
///----------------------------------------------------

///-----------------------------------------------------------------
/// TPIMMediaMessage 多媒体消息的抽象类,Message对象需要使用具体类来实例化
///-----------------------------------------------------------------
@implementation TPIMMediaMessage

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return nil;
}


#pragma mark - message
+ (void)sendMessage:(TPIMMessage *)message
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)sendSingleImageMessage:(NSData *)imageData toUsername:(NSString *)username
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)sendSingleVoiceMessage:(NSData *)voiceData toUsername:(NSString *)username
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)downloadOriginImage:(TPIMImageMessage *)message withProgress:(NSProgress *)progress completionHandler:(TPIMCompletionHandler)handler
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)downloadThumbImage:(TPIMImageMessage *)message withProgress:(NSProgress *)progress completionHandler:(TPIMCompletionHandler)handler
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

+ (void)downloadVoice:(TPIMVoiceMessage *)message withProgress:(NSProgress *)progress completionHandler:(TPIMCompletionHandler)handler
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}


@end


///-----------------------------------------------------------------
/// TPIMContentMessage 纯文本消息.发送时必须填写:contentText、targetId、contentType
///                    接收时通过contentText获取消息内容
///-----------------------------------------------------------------
@implementation TPIMContentMessage

- (instancetype)initWithXMPPMessage:(XMPPMessage *)msg
{
    self = [super initWithXMPPMessage:msg];
    if (self) {
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[msg.body dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        TPIMContentModel *content = [TPIMContentModel mj_objectWithKeyValues:dic];
        self.contentText = content.content;
        self.fromName = content.from;
        self.fromHeadUrl = content.icon;
        self.uid = content.uid;
        self.fromphone = content.fromphone;
        
        if (self.contentText.length == 0) {
            self.contentText = msg.body;
        }
        
        self.contentType = kTPIMTextMessage;
    }
    return self;
}

+ (void)sendMessage:(TPIMContentMessage *)message
{
    NSString *type = @"chat";
    if (message.conversationType == kTPIMGroup) {
        type = @"groupchat";
    }
    [[TPXmppManager defaultManager] sendMessage:message.contentText type:type to:message.targetId];
    
}

+ (void)sendSingleTextMessage:(NSString *)content toUsername:(NSString *)targetId
{
    [[TPXmppManager defaultManager] sendMessage:content type:@"chat" to:targetId];
    
}

@end

///-----------------------------------------------------------------
/// TPIMEventMessage Event消息具体类，通过TPIMNotification_EventMessage来接收
///                  使用contentText来获取具体的event需要展示的内容,不需要根据具体信息来自己拼接展示内容
///-----------------------------------------------------------------
@implementation TPIMEventMessage



@end


///-----------------------------------------------------------------
/// TPIMCustomMessage 自定义消息.发送时必须填写:custom、targetId、contentType
///                   发送自定义消息时需要传的对象
///                   用户可以发送接收自定义格式的内容(custom字段)
///-----------------------------------------------------------------
@implementation TPIMCustomMessage

+ (void)sendMessage:(TPIMCustomMessage *)message
{
    NSString *type = @"chat";
    if (message.conversationType == kTPIMGroup) {
        type = @"groupchat";
    }
    [[TPXmppManager defaultManager] sendMessage:nil type:type to:message.targetId];
}

@end

///-----------------------------------------------------------------
/// TPIMImageMessage 图片消息,发送时必须填写:mediaData、targetId、contentType、imgSize
///                  发送图片消息时需要传的对象
///                  接收时通过thumbPath展示缩略图,图片不存在时需要调用downloadThumbImage重新获取
//                   完整大图需要调用downloadOriginImage接口获取
///-----------------------------------------------------------------
@implementation TPIMImageMessage

+ (void)sendMessage:(TPIMImageMessage *)message
{
    NSString *type = @"chat";
    if (message.conversationType == kTPIMGroup) {
        type = @"groupchat";
    }
    NSString *datastring = [[NSString alloc] initWithData:message.mediaData encoding:NSUTF8StringEncoding];
    [[TPXmppManager defaultManager] sendMessage:datastring type:type to:message.targetId];
}

+ (void)sendSingleImageMessage:(NSData *)imageData toUsername:(NSString *)username
{
    
    NSString *datastring = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
    [[TPXmppManager defaultManager] sendMessage:datastring type:@"chat" to:username];
}


+ (void)downloadOriginImage:(TPIMImageMessage *)message withProgress:(NSProgress *)progress completionHandler:(TPIMCompletionHandler)handler
{
    
}

+ (void)downloadThumbImage:(TPIMImageMessage *)message withProgress:(NSProgress *)progress completionHandler:(TPIMCompletionHandler)handler
{
    
}

@end

///-----------------------------------------------------------------
/// TPIMVoiceMessage 语音消息,发送时必须填写:duration、mediaData 、targetId、contentType、imgSize
///                  发送语音消息时需要传的对象
///                  接收时通过resourcePath获取语音消息,图片不存在时需要调用downloadVoice重新获取
///-----------------------------------------------------------------
@implementation TPIMVoiceMessage

- (instancetype)initWithXMPPMessage:(XMPPMessage *)msg
{
    self = [super initWithXMPPMessage:msg];
    
    if (self) {
        
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[msg.body dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        TPIMContentModel *content = [TPIMContentModel mj_objectWithKeyValues:dic];
        self.resourcePath = content.video_url;
        self.voiceString = content.content;
        self.duration = content.seconds;
        self.fromName = content.from;
        self.fromHeadUrl = content.icon;
        //        self.toTV = content.toTV;
        self.uid = content.uid;
        self.fromphone = content.fromphone;
        self.contentType = kTPIMVoiceMessage;
        
    }
    return self;
}

+ (void)sendMessage:(TPIMVoiceMessage *)message
{
    NSString *type = @"chat";
    if (message.conversationType == kTPIMGroup) {
        type = @"groupchat";
    }
    TPIMContentModel *contentModel = [[TPIMContentModel alloc] init];
    if (message.voiceString.length == 0) {
        contentModel.content = @"。";
    }
    else{
        contentModel.content = message.voiceString;
    }
    contentModel.video_url = message.resourcePath;
    contentModel.seconds = message.duration;
    contentModel.from = [HiTVGlobals sharedInstance].nickName;
    contentModel.icon = [HiTVGlobals sharedInstance].faceImg;
    contentModel.uid = [HiTVGlobals sharedInstance].uid;
    contentModel.fromphone = [HiTVGlobals sharedInstance].phoneNo;
    
    [[TPXmppManager defaultManager] sendMessage:[contentModel mj_JSONString] type:type to:message.targetId];
}

+ (void)sendSingleVoiceMessage:(NSData *)voiceData toUsername:(NSString *)username
{
    
}

+ (void)downloadVoice:(TPIMVoiceMessage *)message withProgress:(NSProgress *)progress completionHandler:(TPIMCompletionHandler)handler
{
    
}

@end
