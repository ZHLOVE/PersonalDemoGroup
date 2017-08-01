//
//  SJVideoPlayerView.h
//  ShiJia
//
//  Created by yy on 16/3/16.
//  Copyright © 2016年 yy. All rights reserved.
//  播放器

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <UIKit/UIKit.h>

@class SJVideoPlayerView;
@class TPDanmakuData;

@protocol SJVideoPlayerViewDelegate <NSObject>

@optional

// 点击返回
- (void)playerViewDidClickBack:(SJVideoPlayerView *)playerview;

// 点击弹幕
- (void)playerViewDidClickDanmu:(SJVideoPlayerView *)playerview;

// 点击剧集
- (void)playerView:(SJVideoPlayerView *)playerview didClickSeriesAtIndex:(NSInteger)index;

// 点击播放
- (void)playerViewDidClickPlay:(SJVideoPlayerView *)playerview;

// 点击暂停
- (void)playerViewDidClickPause:(SJVideoPlayerView *)playerview;

// 点击分享
- (void)playerViewDidClickShare:(SJVideoPlayerView *)playerview;

// 点击投屏
- (void)playerViewDidClickScreen:(SJVideoPlayerView *)playerview;

// 取消投屏
- (void)playerViewDidCancelScreen:(SJVideoPlayerView *)playerview;

// 点击收藏
- (void)playerViewDidClickStar:(SJVideoPlayerView *)playerview;

// 全屏
- (void)playerViewDidFullScreen:(SJVideoPlayerView *)playerview;

// 小屏
- (void)playerViewDidMiniScreen:(SJVideoPlayerView *)playerview;

// 拖动进度条
- (void)playerView:(SJVideoPlayerView *)playerview didSlideToSeconds:(CGFloat)seconds;

// 无Wifi时点击继续播放影片
- (void)playerViewDidClickContinueWithoutWifi:(SJVideoPlayerView *)playerview;

// 网络连接失败时，点击重试
- (void)playerViewDidClickRetry:(SJVideoPlayerView *)playerview;

- (void)playerViewWillChangeFrame;

@end


typedef NS_ENUM(NSInteger, SJVideoPlayerViewStyle){
    
    SJVideoPlayerViewStyleMini,       // 小屏
    SJVideoPlayerViewStyleFullScreen, // 全屏
    SJVideoPlayerViewStyleCustom      // 自定义大小
    
};//播放器样式

typedef NS_ENUM(NSInteger, SJVideoPlayerViewStatus){
    
    SJVideoPlayerViewStatusReadyToPlay,//准备播放
    SJVideoPlayerViewStatusPlaying,    // 正在播放
    SJVideoPlayerViewStatusPaused,     // 暂停中
    SJVideoPlayerViewStatusFinished,   // 播放结束
    SJVideoPlayerViewStatusCaching,    // 正在缓存
    SJVideoPlayerViewStatusScreening,  // 正在投屏
    SJVideoPlayerViewStatusFailed,     // 播放失败
    SJVideoPlayerViewStatusOnlyTvPlay      // 仅TV播放
    
    
};//播放器状态

typedef NS_ENUM(NSInteger, SJVideoPlayerSeriesViewStyle){
    
    SJVideoPlayerSeriesViewStyleCollectionView,
    SJVideoPlayerSeriesViewStyleTableView
    
};//选集样式

@interface SJVideoPlayerView : UIView

@property (nonatomic, weak) id<SJVideoPlayerViewDelegate> delegate;

@property (nonatomic, strong          ) AVPlayer                     *player;

@property (nonatomic, assign          ) CGPoint                      origin;///< Shortcut for frame.origin.

@property (nonatomic, readonly        ) CGSize                       size;///< Shortcut for frame.size.

@property (nonatomic, assign          ) SJVideoPlayerViewStyle       style;// 播放器样式


@property (nonatomic, assign          ) NSInteger                    currentVideoIndex;//当前播放索引

@property (nonatomic, assign          ) SJVideoPlayerViewStatus      status;// 播放状态
@property (nonatomic, assign, readonly) BOOL                         locked;// 屏幕锁定标志位
@property (nonatomic, assign, readonly) BOOL                         showBarrage;//显示弹幕标志位

@property (nonatomic, copy            ) NSString                     *title;// 当前播放节目名称
@property (nonatomic, assign          ) NSInteger                    seriesCount;// 节目集数

@property (nonatomic, assign          ) SJVideoPlayerSeriesViewStyle seriesStyle;//选集样式
@property (nonatomic, strong          ) NSArray                      *seriesList;
@property (nonatomic, assign          ) BOOL                          seriesDescending;//选集是否倒序
@property (nonatomic, assign          ) BOOL                         isCollected;//是否已收藏
@property (nonatomic, assign          ) BOOL                         showWithoutWifiView;//显示无wifiview
@property (nonatomic, assign          ) BOOL                         showWithoutNetworkView;//显示无网络view
@property (nonatomic, assign)           BOOL                         isSliding;
@property (nonatomic, copy) void (^didFinishRecoverMiniScreen)();

/**
 *  隐藏所有控件
 */
@property (nonatomic, assign) BOOL allControlsHidden;

@property (nonatomic, assign) BOOL showDanmuSwitch;
//add by jhl 20160802
@property (nonatomic, assign) BOOL isScreening;
//end
@property (nonatomic, assign) BOOL noFree;  //收费节目

@property (nonatomic, assign) CGFloat trialDura;//试看时长

@property (nonatomic, assign) float volume;

#pragma mark - Init
- (instancetype)initWithOrigin:(CGPoint)viewOrigin;

#pragma mark - Player state
- (void)updateCacheTime:(CGFloat)cacheTime;
- (void)updateTotalTime:(CGFloat)totalTime;
- (void)updatePlayedTime:(CGFloat)playerTime;
- (void)recoverFullScreen;
- (void)recoverMiniScreen;
- (void)handle_dealloc;
#pragma mark - Danmu
- (void)sendBarrage:(TPDanmakuData *)data;

#pragma mark - 收费节目
- (void)showFullPayTipView:(NSString *)title;
//进度条重置
- (void)resetPlayedTime;
@end






