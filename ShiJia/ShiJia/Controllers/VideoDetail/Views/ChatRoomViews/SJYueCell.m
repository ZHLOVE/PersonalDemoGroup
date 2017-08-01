//
//  SJYueCell.m
//  ShiJia
//
//  Created by yy on 16/6/22.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJYueCell.h"
#import "AFNetworking.h"

NSString * const kSJYueCellIdentifier = @"SJYueCell";
//static CGFloat kAvatarNodeWidth = 44.0;

@interface SJYueCell ()

//@property (nonatomic, strong) ASNetworkImageNode  *avatarNode;
@property (nonatomic, weak) IBOutlet UIImageView *headImgView;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation SJYueCell

#pragma mark - Lifecycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    _avatarNode.frame = CGRectMake((self.frame.size.width - self.frame.size.width) / 2.0, 0, self.frame.size.width, self.frame.size.width);
    _headImgView.layer.cornerRadius = self.frame.size.width / 2.0;
    _headImgView.layer.masksToBounds = YES;
}

#pragma mark -  Public
- (void)showImage:(UIImage *)img name:(NSString *)name
{
//    [_headImgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
    _headImgView.image = img;
    _label.text = name;
}

- (void)showImgUrl:(NSString *)imgUrl name:(NSString *)name
{
    [_headImgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
   
    //    _label.text = name;
    
//    if (_avatarNode == nil) {
//        // user pic
//        _avatarNode = [[ASNetworkImageNode alloc] init];
//        _avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
//        _avatarNode.preferredFrameSize = CGSizeMake(kAvatarNodeWidth, kAvatarNodeWidth);
//        _avatarNode.cornerRadius = 2.0;
//        _avatarNode.defaultImage = [UIImage imageNamed:@"default_head"];
//        //        _avatarNode.URL = [NSURL URLWithString:@"https://avatars1.githubusercontent.com/u/8086633?v=3&s=96"];
//        //@weakify(self);
//        _avatarNode.imageModificationBlock = ^UIImage *(UIImage *image) {
//            //@strongify(self);
////            UIImage *newImage;
////            if (imgUrl.length == 0) {
////                newImage = image;
////            }
////            else{
////                //将UIImage转换成CGImageRef
////                CGImageRef sourceImageRef = [image CGImage];
////                
////                //按照给定的矩形区域进行剪裁
////                CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake((image.size.width - 60) / 2.0, (image.size.height - 60) / 2.0, 60, 60));
////                
////                //将CGImageRef转换成UIImage
////                newImage = [UIImage imageWithCGImage:newImageRef];
////            }
//            
//            
//            UIImage *modifiedImage;
//            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
//            
//            //image.size，[[UIScreen mainScreen] scale]
//            UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
//            
//            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:image.size.width / 2.0] addClip];
//            [image drawInRect:rect];
//            modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
//            
//            UIGraphicsEndImageContext();
//            
//            return modifiedImage;
//            
//        };
//        [self addSubnode:_avatarNode];
//    }
//    _avatarNode.URL = [NSURL URLWithString:imgUrl];
    
    _headImgView.layer.cornerRadius = self.frame.size.width / 2.0;
    _headImgView.layer.masksToBounds = YES;
}

#pragma mark - Setter
- (void)setStyle:(SJYueCellStyle)style
{
    if (style == SJYueCellStyleNormal) {
        _label.hidden = NO;
       // _headImgView.hidden = YES;
        //_avatarNode.hidden = NO;
        
    }
    else{
        _label.hidden = YES;
        _headImgView.image = [UIImage imageNamed:@"muc_invite_btn"];
       // _headImgView.hidden = NO;
        //_avatarNode.hidden = YES;
    }
}

@end
