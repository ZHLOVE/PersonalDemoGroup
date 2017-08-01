//
//  SJChatRoomMessageCell.m
//  ShiJia
//
//  Created by yy on 16/4/1.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJChatRoomMessageCell.h"
#import "MLPlayVoiceButton.h"

CGFloat const kAvatarNodeWidth = 36.0;

@implementation SJChatRoomMessageCell

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // avatar node
        _avatarNode = [[ASNetworkImageNode alloc] init];
        _avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _avatarNode.preferredFrameSize = CGSizeMake(kAvatarNodeWidth, kAvatarNodeWidth);
        _avatarNode.cornerRadius = 18.0;
        _avatarNode.defaultImage = [UIImage imageNamed:@"default_head"];
//        _avatarNode.URL = [NSURL URLWithString:@"https://avatars1.githubusercontent.com/u/8086633?v=3&s=96"];
        _avatarNode.imageModificationBlock = ^UIImage *(UIImage *image) {
            
            UIImage *modifiedImage;
            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
            
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:kAvatarNodeWidth] addClip];
            [image drawInRect:rect];
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return modifiedImage;
            
        };
        [self addSubnode:_avatarNode];
        
        
        _avatarView = [[UIView alloc] init];
        _avatarView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_avatarView];
        
        // name
        _nameNode = [[ASTextNode alloc] init];
        _nameNode.flexShrink = NO;
        _nameNode.truncationMode = NSLineBreakByTruncatingTail;
        _nameNode.maximumNumberOfLines = 1;
        [self addSubnode:_nameNode];
        
        // message background node
        _messageBackNode = [[ASImageNode alloc] init];
        [self addSubnode:_messageBackNode];
        
        // post node
        _messageNode = [[ASTextNode alloc] init];
        _messageNode.maximumNumberOfLines = MAXFLOAT;
        _nameNode.flexShrink = YES;
        _nameNode.truncationMode = NSLineBreakByTruncatingTail;
        _messageNode.alignSelf = ASStackLayoutAlignSelfCenter;
        [self addSubnode:_messageNode];
        
        // record Background Image View
        _recordBackImgView = [[UIImageView alloc] init];
        [self.view addSubview:_recordBackImgView];
        
        _playButton = [[MLPlayVoiceButton alloc] init];
       
        @weakify(self);
        [_playButton setVoiceWillPlayBlock:^(MLPlayVoiceButton *sender){
            @strongify(self);
            if (self.voiceMessageWillStartPlayingBlock) {
                self.voiceMessageWillStartPlayingBlock();
            }
        }];
        
        [_playButton setVoiceDidFinishPlayingBlock:^(MLPlayVoiceButton *sender){
            @strongify(self);
            if (self.voiceMessageDidFinishPlayingBlock) {
                self.voiceMessageDidFinishPlayingBlock();
            }
        }];
        
        [self.view addSubview:_playButton];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [_avatarView addGestureRecognizer:tapGesture];
        
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
        //longGesture.minimumPressDuration = 1.0;
        [_avatarView addGestureRecognizer:longGesture];
        
    }
    
    return self;
}

#pragma mark - Data
- (void)showMessage:(TPIMContentMessage *)message
{

}

- (void)showRecordMessage:(TPIMVoiceMessage *)data
{

}

#pragma mark - Event
- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    if (self.showUserInfoBlock) {
        self.showUserInfoBlock(self);
    }
}

- (void)handleLongGesture:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.atUserNameBlock) {
            self.atUserNameBlock(self);
        }
    }
    
}

#pragma mark - Style
- (NSDictionary *)nameAttributes
{
    return @{
             NSFontAttributeName: [UIFont systemFontOfSize:12.0],
             NSForegroundColorAttributeName: [UIColor darkGrayColor]
             };
}

- (NSDictionary *)messageAttributes
{
    NSMutableParagraphStyle*paragraph = [[NSMutableParagraphStyle alloc]init
                                         ];
    paragraph.alignment = NSTextAlignmentJustified;
    paragraph.lineSpacing = 7;
    paragraph.hyphenationFactor = 1.0;
    
    return @{
             NSFontAttributeName: [UIFont systemFontOfSize:14.0],
             NSForegroundColorAttributeName: [UIColor darkGrayColor],
             NSParagraphStyleAttributeName : paragraph
             };
}

@end
