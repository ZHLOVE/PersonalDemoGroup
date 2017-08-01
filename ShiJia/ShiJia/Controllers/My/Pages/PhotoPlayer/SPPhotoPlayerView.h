//
//  SPPhotoPlayerView.h
//  InstagramPhotoPicker
//
//  Created by SeacCong on 15/1/14.
//  Copyright (c) 2015年 wenzhaot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPPhotoPlayerAction) {
    SPPhotoPlayerProjectionAction,
    SPPhotoPlayerProjectionStopAction,
    SPPhotoPlayerPreviousAction,
    SPPhotoPlayerClockwiseAction,
    SPPhotoPlayerContrarotateAction,
    SPPhotoPlayerNextAction,
    SPPhotoPlayerStartAction,
    SPPhotoPlayerStopAction,
};

@protocol SPPhotoPlayerViewDelegate <NSObject>

@required
-(void)playAction:(SPPhotoPlayerAction) action;
-(BOOL)hasPrevious;
-(BOOL)hasNext;
-(BOOL)canScreenProjection;
@optional


@end

@interface SPPhotoPlayerView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageShowView;
@property (weak, nonatomic) IBOutlet UILabel *imageNameView;

@property (weak, nonatomic) IBOutlet UIButton *screenProjectionBtn;

@property (weak, nonatomic) IBOutlet UIButton *contrarotateBtn;
@property (weak, nonatomic) IBOutlet UIButton *clockwiseBtn;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *topLayoutView;

@property (weak, nonatomic) IBOutlet UIView *bottomLayoutView;

@property (strong,nonatomic) UIImageView * topImageView;


@property(nonatomic, assign) id<SPPhotoPlayerViewDelegate> delegate;

- (void) setScreenProjectioState:(BOOL) connect;

/**
 *  播放图片
 *
 *  @param showImage  需要显示的图片
 *  @param imageName  显示的图片文件名
 *  @param firstIndex 是否为第一张图片
 *  @param lastIndex  是否为最后一张图片
 */
- (void) setShowImageData:(UIImage*) showImage ImageName:(NSString*) imageName;

/**
 *  得到当前显示的Image
 *
 *  @return 显示的Image
 */
- (UIImage*) getShowImage;

/**
 *  得到当前显示的图片名
 *
 *  @return 图片名
 */
- (NSString*) getShowImageFileName;

/**
 *  播放状态查询
 *
 *  @return YES为正在播放，否则为暂停播放
 */
- (BOOL) isPlaying;


/**
 *  投屏状态查询
 *
 *  @return YES为正在投屏播放状态，否则未投屏播放
 */
- (BOOL) isPhotoProjecting;

@end
