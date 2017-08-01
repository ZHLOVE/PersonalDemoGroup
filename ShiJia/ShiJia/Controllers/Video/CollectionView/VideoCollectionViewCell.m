//
//  VideoCollectionViewCell.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CornerEntity.h"

NSString * const cVideoCollectionViewCellID = @"VideoCollectionViewCell";

@interface VideoCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *t_leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *t_rightImg;
@property (weak, nonatomic) IBOutlet UIImageView *b_leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *b_rightImg;

@end

@implementation VideoCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];

    //self.imageView.contentMode = UIViewContentModeScaleToFill;
    [self.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.imageView.clipsToBounds  = YES;
}
- (void)setVideo:(VideoSummary *)video{
    _video = video;
    self.titleLabel.text = video.name;

    // self.imageView.layer.cornerRadius = 4;
    //self.imageView.layer.masksToBounds = YES;

    [self.imageView setImageWithURL:[NSURL URLWithString:video.imgUrl] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    /*if (![CHANNELID isEqualToString:taipanTest63]) {
     if (video.ppvId.length>0) {
     self.iconImg.image = [UIImage imageNamed:@"vipjiaobiao"];
     }
     else{
     self.iconImg.image = nil;
     }
     }*/
    self.t_leftImg.image = nil;
    self.t_rightImg.image = nil;
    self.b_leftImg.image = nil;
    self.b_rightImg.image = nil;

    for (CornerEntity *cornerEntity in video.cornerArray) {
        if (cornerEntity.position.intValue == 1) {
//            if (![cornerEntity.cornerImg isEqual:[NSNull null]]) {
                [self.t_leftImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
//            }

        }
        else if (cornerEntity.position.intValue == 2) {
            [self.b_leftImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
        }
        else if (cornerEntity.position.intValue == 3) {
            [self.t_rightImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
        }
        else if (cornerEntity.position.intValue == 4) {
            [self.b_rightImg setImageWithURL:[NSURL URLWithString:cornerEntity.cornerImg] placeholderImage:nil];
        }
    }

    // self.iconImg.image = [UIImage imageNamed:@"newlogo"];
    
}

@end
