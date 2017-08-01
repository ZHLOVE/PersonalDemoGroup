//
//  SJMediaCollectionCell.m
//  ShiJia
//
//  Created by 峰 on 16/9/18.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMediaCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "TPShortVideoPlayerView.h"
#import "UIImage+Orientation.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"



@interface SJMediaCollectionCell ()

@property (nonatomic, strong) UIImageView             *photoImageV;
@property (nonatomic, strong) UIButton                *centerButton;
@property (nonatomic, strong) TPShortVideoPlayerView  *playerview;

@end

@implementation SJMediaCollectionCell

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.photoImageV];
        [self addSubview:self.centerButton];

    }

    return self;
}

#pragma  mark 视频中间按钮
-(UIButton *)centerButton{
    if (!_centerButton) {
        _centerButton = [UIButton new];
        [_centerButton setImage:[UIImage imageNamed:@"shortvideo_play_btn"] forState:UIControlStateNormal];
        _centerButton.size = CGSizeMake(60, 60);
        _centerButton.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-50-NAVIGATION_BAR_HEIGHT)/2);
        _centerButton.hidden = YES;
        [_centerButton addTarget:self action:@selector(playIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerButton;
}

//imageview
-(UIImageView *)photoImageV{
    if (!_photoImageV) {
        _photoImageV = [UIImageView new];
        _photoImageV.frame = self.bounds;
        [_photoImageV setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _photoImageV;
}

#pragma mark 获取图片---本地图片
-(void)initImageViewWithlocalPhotoModel:(ALAsset *)alasset{
    CGImageRef imageRef = alasset.defaultRepresentation.fullScreenImage;
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:alasset.defaultRepresentation.scale
                                   orientation:(UIImageOrientation)alasset.defaultRepresentation.orientation];
    _photoImageV.image = [image imageRotate:image rotation:UIImageOrientationUp];
}

#pragma mark 获取图片---本地视频
-(void)initImageViewWithlocalVideoModel:(ALAsset *)alasset{
    _photoImageV.image=[UIImage imageWithCGImage:[alasset thumbnail]];
}
#pragma mark 获取图片--云端图片
-(void)initImageViewWithCloudModel:(CloudPhotoModel *)cloudModel{

    [_photoImageV setImageWithURL:[NSURL URLWithString:cloudModel.resourceUrl]
                 placeholderImage:[UIImage imageNamed:@"default_image"]
      usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}
#pragma  mark 获取图片--云端视频
-(void)initImageViewWithCloudVideoModel:(CloudPhotoModel *)cloudModel{
    [_photoImageV sd_setImageWithURL:[NSURL URLWithString:cloudModel.thumbnailUrl]
                    placeholderImage:[UIImage imageNamed:@"default_image"]
                             options:SDWebImageCacheMemoryOnly];
}
#pragma mark UI 创建--- 本地资源
-(void)creatWithLocalModel:(ALAsset *)local
             andSourceType:(Media_TYPE )type {

    switch (type) {
        case Media_Photo:{
//            [self addSubview:self.photoImageV];
            [self initImageViewWithlocalPhotoModel:local];
            _centerButton.hidden = YES;
//            [_centerButton removeFromSuperview];
        }
            break;
        case Media_Vedio:{
//            [self addSubview:self.photoImageV];
//            [self addSubview:self.centerButton];
             _centerButton.hidden = NO;
            [self initImageViewWithlocalVideoModel:local];
        }
            break;
        default:
            break;
    }

}
#pragma mark UI 创建--- 云资源
-(void)creatWithCloudModel:(CloudPhotoModel *)cloud
             andSourceType:(Media_TYPE )type {
    switch (type) {
        case Media_Photo:
            [self initImageViewWithCloudModel:cloud];
            _centerButton.hidden = YES;
            break;
        case Media_Vedio:
            [self initImageViewWithCloudVideoModel:cloud];
            _centerButton.hidden = NO;
            break;
        default:
            break;
    }
}
#pragma mark 播放视频
- (void)playIndex:(id)sender {
    if (_playVideo) {
        self.playVideo(self.currentIndex);
    }
}




@end
