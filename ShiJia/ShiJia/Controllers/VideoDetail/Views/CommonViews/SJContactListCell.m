//
//  SJContactListCell.m
//  ShiJia
//
//  Created by yy on 16/3/11.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJContactListCell.h"

static CGFloat kAvatarNodeWidth = 40.0;
static CGFloat kAvatarNodeOriginX = 2.0;

@interface SJContactListCell ()

@property (nonatomic, strong) ASNetworkImageNode  *avatarNode;
@property (nonatomic, strong) ASTextNode   *usernameNode;
@property (nonatomic, strong) ASButtonNode *buttonNode;
@property (nonatomic, strong) ASImageNode  *checkNode;

@end

@implementation SJContactListCell

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        // username node
        _usernameNode = [[ASTextNode alloc] init];
//        _usernameNode.attributedString = [[NSAttributedString alloc] initWithString:@"小明"
//                                                                         attributes:[self textAttributes]];
        _usernameNode.flexShrink = NO; //if name and username don't fit to cell width, allow username shrink
        _usernameNode.truncationMode = NSLineBreakByTruncatingTail;
        _usernameNode.maximumNumberOfLines = 1;
        
        [self addSubnode:_usernameNode];
        
        // user pic
        _avatarNode = [[ASNetworkImageNode alloc] init];
//        _avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _avatarNode.preferredFrameSize = CGSizeMake(kAvatarNodeWidth, kAvatarNodeWidth);
        //_avatarNode.cornerRadius = 2.0;

        _avatarNode.defaultImage = [UIImage imageNamed:@"头像默认"];

        _avatarNode.imageModificationBlock = ^UIImage *(UIImage *image) {

            
            UIImage *modifiedImage;
            CGFloat width = image.size.width;
            if (image.size.width > image.size.height) {
                width = image.size.height;
            }
            CGRect rect = CGRectMake(0, 0, width, width);
            
            //image.size，[[UIScreen mainScreen] scale]
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), false, [[UIScreen mainScreen] scale]);
            
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:width / 2.0] addClip];
            [image drawInRect:rect];
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return modifiedImage;
            
        };
        [self addSubnode:_avatarNode];
        
        
        _checkNode = [[ASImageNode alloc] init];
        _checkNode.contentMode = UIViewContentModeCenter;
        _checkNode.image = [UIImage imageNamed:@"contact_list_checked"];
        [self addSubnode:_checkNode];
        _checkNode.hidden = YES;
    
    }
    return self;
}

//- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
//{
//    ASStackLayoutSpec *vSpec2 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5.0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsCenter children:@[_avatarNode,_usernameNode]];
//    
//    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:vSpec2];
//    
//}

- (void)layout
{
    [super layout];
    CGSize imgSize = _checkNode.image.size;
    
    _avatarNode.frame = CGRectMake(kAvatarNodeOriginX, 0, self.frame.size.width - kAvatarNodeOriginX * 2, self.frame.size.width - kAvatarNodeOriginX * 2);
    
    _usernameNode.frame = CGRectMake(0, _avatarNode.frame.origin.y + _avatarNode.frame.size.height + 5, self.frame.size.width, 20);
    
    _checkNode.frame = CGRectMake( _avatarNode.frame.origin.x + _avatarNode.frame.size.width - imgSize.width,
                                   _avatarNode.frame.origin.y + _avatarNode.frame.size.height - imgSize.height,
                                  imgSize.width,
                                  imgSize.height);
}



#pragma mark - Public
- (void)showData:(UserEntity *)data
{
    _avatarNode.URL = [NSURL URLWithString:data.faceImg];
    NSString *name = data.nickName.length > 0 ? data.nickName : data.name;
    
    if (name.length > 0) {
        _usernameNode.attributedString = [[NSAttributedString alloc] initWithString:name
                                                                         attributes:[self textAttributes]];
    }
    
}

#pragma mark - Setter
- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    _checkNode.hidden = !checked;
}

#pragma mark -  Getter
- (NSDictionary *)textAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    return @{
             NSFontAttributeName: [UIFont systemFontOfSize:14.0],
             NSForegroundColorAttributeName: [UIColor darkGrayColor],
             NSParagraphStyleAttributeName: paragraphStyle
             };
}

@end
