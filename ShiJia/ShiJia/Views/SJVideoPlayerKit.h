//
//  SJVideoPlayerKit.h
//  ShiJia
//
//  Created by yy on 16/3/16.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@class SJVideoPlayerKit;

@class SJVideoPlayerView;

@protocol SJVideoPlayerDelegate <NSObject>

@optional

- (void)playerWillChangeFrame;
- (void)playerDidFinishFullScreen;//播放器全屏
- (void)playerDidFinishMinimumScreen;//播放器小屏
- (void)playerDidClickShare;//分享
- (void)playerDidClickScreen;//投屏
- (void)playerDidCancelScreen;//取消投屏
- (void)playerDidClickCollect;//收藏/取消收藏
- (void)playerDidPlayToEnd;//播放结束
- (void)playerDidPauseInScreening;//投屏操作：暂停
- (void)playerDidResumeInScreening;//投屏操作：继续
- (void)playerDidSeekToSecondsInScreening:(CGFloat)seconds;//投屏操作：seek
- (void)playerDidPlayToCacheVideo;//播放结束用于添加播放过缓存

@end

@interface SJVideoPlayerKit : NSObject

@property (nonatomic, weak) id<SJVideoPlayerDelegate>delegate;

/**
 *  播放器视图
 */
@property (nonatomic, strong, readonly) SJVideoPlayerView *view;

/**
 *  播放地址
 */
@property (nonatomic, strong) NSURL *actionUrl; //播放地址

/**
 *  UA头
 */
@property (nonatomic,   copy) NSString *userAgent;//UA头

/**
 *  当前播放的索引号
 */
@property (nonatomic, assign) NSInteger currentVideoIndex;//当前播放的索引号

/**
 *  当前播放时间（秒）
 */
@property (nonatomic, assign, readonly) CGFloat currentPlayedSeconds;

/**
 *  影片时长
 */
@property (nonatomic, assign, readonly) CGFloat videoDuration;
/**
 *  缓冲平均时长
 */
@property (nonatomic, assign, readonly) NSTimeInterval avgTotalBuffer;
/**
 *  缓冲次数
 */
@property (nonatomic, assign, readonly) NSInteger countBuffer;

/**
 *  暂停次数
 */
@property (nonatomic, assign, readonly) NSInteger countPause;
/**
 *  播放器所在的controller
 */
@property (nonatomic, strong) UIViewController *activeController;

@property (nonatomic, assign) CGFloat datePoint;
@property (nonatomic, assign) CGFloat videoStartFrom;
@property (nonatomic, assign) BOOL isScreening;
@property (nonatomic, assign) BOOL isTVPlay;
@property (nonatomic, assign) BOOL noFree;
@property (nonatomic, assign) CGFloat trialDura;//试看时长
@property (nonatomic, assign) NSInteger pauseCount;

@property (nonatomic, assign) BOOL isDidClickSeries; //是否是点击选集（修改点击选集与自动播放的bug）

/**
 *  返回按钮点击事件
 */
@property (nonatomic, copy)   void (^didClickBack)();

@property (nonatomic, copy)   void (^didClickDanmu)(BOOL showBarrage);

- (void)stop;
- (void)play;
- (void)seekToTime:(CGFloat)seconds;
- (void)clearPlayer;
- (void)clearPlayerWithCompletion:(void(^)())completion;
- (void)addPlayerTimeObservers:(void (^)(CMTime time))block;
- (void)showFullPayTipView;
- (long long)getReceivedBytes;
- (void)mutePlayer;
- (void)recoverPlayerVolume;


@end
