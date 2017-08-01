//
//  SJChatRoomHeaderCell.m
//  ShiJia
//
//  Created by yy on 16/3/31.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJChatRoomHeaderCell.h"

@interface SJChatRoomHeaderCell ()

@property (nonatomic, strong) ASNetworkImageNode *avatarNode;

@end

@implementation SJChatRoomHeaderCell

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        // 头像
        _avatarNode = [[ASNetworkImageNode alloc] init];
        _avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _avatarNode.preferredFrameSize = CGSizeMake(44, 44);
        _avatarNode.cornerRadius = 2.0;
        _avatarNode.defaultImage = [UIImage imageNamed:@"default_head"];
        _avatarNode.URL = [NSURL URLWithString:@"https://avatars1.githubusercontent.com/u/8086633?v=3&s=96"];
        _avatarNode.imageModificationBlock = ^UIImage *(UIImage *image) {
            
            UIImage *modifiedImage;
            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
            
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:image.size.height] addClip];
            [image drawInRect:rect];
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return modifiedImage;
            
        };
        [self addSubnode:_avatarNode];
        
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:_avatarNode];
}

- (void)layout
{
    [super layout];
    
    _avatarNode.cornerRadius = _avatarNode.frame.size.height / 2.0;
//    _avatarNode.frame = self.bounds;
}

#pragma mark - Setter
- (void)setAvatarUrlString:(NSString *)avatarUrlString
{
    _avatarUrlString = avatarUrlString;
    
    if (avatarUrlString.length == 0) {
        _avatarNode.image = [UIImage imageNamed:@"default_head"];
        return;
    }
    
    _avatarNode.URL = [NSURL URLWithString:avatarUrlString];
    
}

- (void)setAvatarImage:(UIImage *)avatarImage
{
    _avatarNode.URL = nil;
    _avatarNode.image = avatarImage;
}

@end
