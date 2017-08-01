//
//  TPShortVideoPlayerView.h
//  HiTV
//
//  Created by yy on 15/10/28.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//
/**
 * 微视频播放view
 */

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TPShortVideoPlayerView : UIView


@property (nonatomic, strong) ALAsset *localAsset;

/**
 *  初始化方法
 *
 *  @param url 视频url地址
 *
 *  @return 返回TPShortVideoPlayerView
 */
- (instancetype)initWithVideoUrl:(NSString *)url andVideoType:(Album_Type)type;

/**
 *  显示播放view
 */
- (void)show;

/**
 *  隐藏播放view
 */
- (void)hide;

/**
 *  清理播放器
 */
- (void)clearPlayer;

/**
 *  下载短视频到本地
 */
- (void)downloadShortVideoToAlbum;



#pragma mark - Cell
/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZFPlayer
 */
+ (instancetype)sharedPlayerView;

/**
 *  player添加到cell上
 *
 *  @param cell 添加player的cellImageView
 */
- (void)addPlayerToCell:(UICollectionViewCell *)cell;

/**
 *  重置player
 */
- (void)resetPlayer;

///**
// *  在当前页面，设置新的Player的URL调用此方法
// */
//- (void)resetToPlayNewURL;

/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

/** 设置URL的setter方法 */
- (void)setVideoURL:(NSURL *)videoURL;

///**
// *  用于cell上播放player
// *
// *  @param videoURL  视频的URL
// *  @param tableView tableView
// *  @param indexPath indexPath
// *  @param ImageViewTag ImageViewTag
// */
//- (void)setVideoURL:(NSURL *)videoURL
//      withTableView:(UITableView *)tableView
//        AtIndexPath:(NSIndexPath *)indexPath
//   withImageViewTag:(NSInteger)tag;


/**
 *  用于cell上播放player
 *
 *  @param videoURL  视频的URL
 *  @param tableView tableView
 *  @param indexPath indexPath
 *  @param ImageViewTag ImageViewTag
 */
- (void)setVideoURL:(NSURL *)videoURL
      withCollectionView:(UICollectionView *)collectionView
        AtIndexPath:(NSIndexPath *)indexPath
   withImageViewTag:(NSInteger)tag;
- (void)autoPlayTheVideo;





@end
