//
//  SJChatRoomIncomingMessageCell.m
//  ShiJia
//
//  Created by yy on 16/4/5.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJChatRoomIncomingMessageCell.h"
#import "TPIMMessage.h"
#import "MLPlayVoiceButton.h"

static CGFloat kInnerPadding = 10.0;
static CGFloat kMaxVoiceTime = 60.0;

@implementation SJChatRoomIncomingMessageCell

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
                
        self.nameNode.alignSelf = ASStackLayoutAlignSelfStart;
//        self.nameNode.attributedString = [[NSAttributedString alloc] initWithString: @"爹爹"
//                                                                         attributes: [self nameAttributes]];
        
        self.messageNode.alignSelf = ASStackLayoutAlignSelfStart;
//        self.messageNode.attributedString = [[NSAttributedString alloc] initWithString: @"msg"
//                                                                            attributes: [self messageAttributes]];
        
        self.messageBackNode.image = [[UIImage imageNamed:@"muc_bubble_incoming_white"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                                 resizingMode:UIImageResizingModeStretch];
        
        self.playButton.hidden = YES;
        self.playButton.type = MLPlayVoiceButtonTypeLeft;
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(kInnerPadding, kInnerPadding, kInnerPadding, kInnerPadding)
                                                                          child: self.messageNode];
   
    ASBackgroundLayoutSpec *backSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild: insetSpec
                                                                                  background: self.messageBackNode];
    
    ASStackLayoutSpec *verSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical
                                                                         spacing: 5.0
                                                                  justifyContent: ASStackLayoutJustifyContentStart alignItems: ASStackLayoutAlignItemsStart
                                                                        children: @[self.nameNode,backSpec]];
    
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(kInnerPadding, kInnerPadding * 2 + kAvatarNodeWidth, kInnerPadding, kInnerPadding * 2 + kAvatarNodeWidth)
                                                  child: verSpec];
    
}

- (void)layout
{
    [super layout];
    self.avatarNode.frame = CGRectMake(kInnerPadding, kInnerPadding, kAvatarNodeWidth, kAvatarNodeWidth);
    self.avatarView.frame = self.avatarNode.frame;
    
    CGFloat originx = self.avatarNode.frame.origin.x + self.avatarNode.frame.size.width + 10;
    CGFloat originy = self.nameNode.frame.origin.y + self.nameNode.frame.size.height + kInnerPadding / 2.0;
    
    CGFloat width = self.frame.size.width - originx - kInnerPadding;
    CGFloat voiceWidth = width * self.playButton.voiceTime / kMaxVoiceTime;
    
    if (voiceWidth <= 40.0) {
        voiceWidth = 40.0;
    }
    
    self.playButton.frame = CGRectMake(originx, originy, voiceWidth, self.frame.size.height - originy - kInnerPadding);
    CGFloat backwidth = self.playButton.frame.size.width + self.playButton.voiceTime;
    self.recordBackImgView.frame = CGRectMake(self.playButton.frame.origin.x + self.playButton.voiceTime / 2.0, self.playButton.frame.origin.y, backwidth, self.playButton.frame.size.height);
    self.playButton.frame = self.recordBackImgView.frame;
    
}

#pragma mark - Data
- (void)showMessage:(TPIMContentMessage *)message
{
    self.playButton.hidden = YES;
    self.recordBackImgView.hidden = YES;
    self.messageNode.hidden = NO;
    self.messageBackNode.hidden = NO;
    
    if (message.fromName.length > 0) {
        self.nameNode.attributedString = [[NSAttributedString alloc] initWithString: message.fromName
                                                                         attributes: [self nameAttributes]];
    }
    if (message.contentText.length > 0) {
        self.messageNode.attributedString = [[NSAttributedString alloc] initWithString: message.contentText
                                                                            attributes: [self messageAttributes]];
    }
    self.avatarNode.URL = [NSURL URLWithString:message.fromHeadUrl];
//    self.avatarNode.image = message.fromHeadImage;
//    if (self.avatarNode.image == nil) {
//        self.avatarNode.image = [UIImage imageNamed:@"default_head"];
//    }
}

- (void)showRecordMessage:(TPIMVoiceMessage *)data
{
    self.playButton.hidden = NO;
    self.recordBackImgView.hidden = NO;
    self.messageNode.hidden = YES;
    self.messageBackNode.hidden = YES;
    
    if (data.fromName.length > 0) {
        self.nameNode.attributedString = [[NSAttributedString alloc] initWithString: data.fromName
                                                                         attributes: [self nameAttributes]];
    }
    self.avatarNode.URL = [NSURL URLWithString:data.fromHeadUrl];
//    self.avatarNode.image = data.fromHeadImage;
//    if (self.avatarNode.image == nil) {
//        self.avatarNode.image = [UIImage imageNamed:@"default_head"];
//    }
    self.playButton.isPublicVoice = data.isPublicMessage;
    self.playButton.voiceTime = [data.duration floatValue];
    [self.playButton setVoiceWithURL:[NSURL URLWithString:data.resourcePath]];
    
    
    self.recordBackImgView.image = [[UIImage imageNamed:@"muc_bubble_incoming_white"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                                     resizingMode:UIImageResizingModeStretch];
    [self setNeedsLayout];
}

@end
