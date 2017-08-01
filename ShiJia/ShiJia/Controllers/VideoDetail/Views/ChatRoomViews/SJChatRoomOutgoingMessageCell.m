//
//  SJChatRoomOutgoingMessageCell.m
//  ShiJia
//
//  Created by yy on 16/4/1.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJChatRoomOutgoingMessageCell.h"

#import "TPIMMessage.h"
#import "MLPlayVoiceButton.h"

static CGFloat kInnerPadding = 10.0;
static CGFloat kMaxVoiceTime = 60.0;

@implementation SJChatRoomOutgoingMessageCell

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.nameNode.alignSelf = ASStackLayoutAlignSelfEnd;
//        self.nameNode.attributedString = [[NSAttributedString alloc] initWithString: @"陆贞"
//                                                                         attributes: [self nameAttributes]];
       
        self.messageNode.alignSelf = ASStackLayoutAlignSelfEnd;
//        self.messageNode.attributedString = [[NSAttributedString alloc] initWithString: @"msg"
//                                                                            attributes: [self messageAttributes]];
        
        self.messageBackNode.image = [[UIImage imageNamed:@"muc_bubble_outgoing_blue"] resizableImageWithCapInsets: UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                                 resizingMode:UIImageResizingModeStretch];
        self.playButton.type = MLPlayVoiceButtonTypeRight;
        
        
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(kInnerPadding, kInnerPadding, kInnerPadding, kInnerPadding)
                                                                          child: self.messageNode];
   
    ASBackgroundLayoutSpec *backSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:insetSpec
                                                                                  background:self.messageBackNode];
    
    ASStackLayoutSpec *verSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical
                                                                         spacing: 5.0
                                                                  justifyContent: ASStackLayoutJustifyContentStart alignItems: ASStackLayoutAlignItemsEnd
                                                                        children: @[self.nameNode,backSpec]];
    
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(kInnerPadding, kInnerPadding * 2 + kAvatarNodeWidth, kInnerPadding, kInnerPadding * 2 + kAvatarNodeWidth)
                                                  child: verSpec];
    
}

- (void)layout
{
    [super layout];
    self.avatarNode.frame = CGRectMake(self.frame.size.width - kInnerPadding - kAvatarNodeWidth,
                                       kInnerPadding,
                                       kAvatarNodeWidth,
                                       kAvatarNodeWidth);
    self.avatarView.frame = self.avatarNode.frame;
    
    CGFloat originx = self.avatarNode.frame.origin.x - kInnerPadding;
    CGFloat originy = self.nameNode.frame.origin.y + self.nameNode.frame.size.height + kInnerPadding / 2.0;
    CGFloat width = originx - kInnerPadding;
    CGFloat voiceWidth = width * self.playButton.voiceTime / kMaxVoiceTime;
    
    if (voiceWidth <= 40.0) {
        voiceWidth = 40.0;
    }
    self.playButton.frame = CGRectMake(originx - voiceWidth,
                                       originy,
                                       voiceWidth,
                                       self.frame.size.height - kInnerPadding - originy);
    CGFloat backwidth = self.playButton.frame.size.width + self.playButton.voiceTime;
    self.recordBackImgView.frame = CGRectMake(self.playButton.frame.origin.x - self.playButton.voiceTime / 2.0, self.playButton.frame.origin.y, backwidth, self.playButton.frame.size.height);
    self.playButton.frame = self.recordBackImgView.frame;
    
}

#pragma mark - Data
- (void)showMessage:(TPIMContentMessage *)message
{
    // 文本消息
    if (message.fromName.length > 0) {
        self.nameNode.attributedString = [[NSAttributedString alloc] initWithString: message.fromName
                                                                         attributes: [self nameAttributes]];
    }
    if (message.contentText.length > 0) {
        self.messageNode.attributedString = [[NSAttributedString alloc] initWithString: message.contentText
                                                                            attributes: [self messageAttributes]];
    }
//    self.avatarNode.image = message.fromHeadImage;
//
//    if (self.avatarNode.image == nil) {
//        self.avatarNode.image = [UIImage imageNamed:@"default_head"];
//    }
    self.avatarNode.URL = [NSURL URLWithString:message.fromHeadUrl];
    self.playButton.hidden = YES;
    self.recordBackImgView.hidden = YES;
    self.messageNode.hidden = NO;
    self.messageBackNode.hidden = NO;
}

- (void)showRecordMessage:(TPIMVoiceMessage *)data
{
    // 语音消息
    if (data.fromName.length > 0) {
        self.nameNode.attributedString = [[NSAttributedString alloc] initWithString: data.fromName
                                                                         attributes: [self nameAttributes]];
    }
//    self.avatarNode.image = data.fromHeadImage;
//    if (self.avatarNode.image == nil) {
//        self.avatarNode.image = [UIImage imageNamed:@"default_head"];
//    }
    self.avatarNode.URL = [NSURL URLWithString:data.fromHeadUrl];
    self.playButton.isPublicVoice = data.isPublicMessage;
    self.playButton.voiceTime = [data.duration floatValue];
    [self.playButton setVoiceWithURL:[NSURL URLWithString:data.resourcePath]];
    
    self.playButton.hidden = NO;
    self.recordBackImgView.hidden = NO;
    self.messageNode.hidden = YES;
    self.messageBackNode.hidden = YES;
    
    self.recordBackImgView.image = [[UIImage imageNamed:@"muc_bubble_outgoing_blue"] resizableImageWithCapInsets: UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                                    resizingMode:UIImageResizingModeStretch];
    [self setNeedsLayout];
}


@end
