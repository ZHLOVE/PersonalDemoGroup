//
//  TPShortVideoPlayerView.m
//  HiTV
//
//  Created by yy on 15/10/28.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPShortVideoPlayerView.h"
#import "TPShortVideoProgressView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TPDownloadVideoManager.h"
#import "MBProgressHUD.h"
#import "TPFileOperation.h"

#define LightButtonBackgroundColor [UIColor colorWithRed:60/255.0 green:162/255.0 blue:221/255.0 alpha:1.0]
#define DarkButtonBackgroundColor [UIColor colorWithRed:44/255.0 green:106/255.0 blue:145/255.0 alpha:1.0]
// 监听TableView的contentOffset
#define kZFPlayerViewContentOffset          @"contentOffset"

static void * playerItemDurationContext = &playerItemDurationContext;
static void * playerItemStatusContext = &playerItemStatusContext;
static void * playerPlayingContext = &playerPlayingContext;

@interface TPShortVideoPlayerView ()

@property (nonatomic, strong) TPShortVideoProgressView *progressView;

@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIImageView *videoBackImgView;
@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSURL *videoPathURL;

@property (nonatomic, assign) BOOL playing; // 是否正在播放
@property (nonatomic, assign) BOOL canPlay; // 是否可以播放
@property (nonatomic, assign) BOOL playFinish;//播放结束标志
@property (nonatomic, assign) CMTime duration; // 视频总时间
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, assign) BOOL downloaded;//视频下载标志位
@property (nonatomic, assign) BOOL autoPlay;

@property (nonatomic, assign)Album_Type mediaType;

//监听播放起状态的监听者
@property (nonatomic ,strong) id playbackTimeObserver;

#pragma mark - UITableViewCell PlayerView

/** palyer加到tableView */
//@property (nonatomic, strong) UITableView            *tableView;
@property (nonatomic, strong) UICollectionView       *collectionView;

/** player所在cell的indexPath */
@property (nonatomic, strong) NSIndexPath            *indexPath;
/** cell上imageView的tag */
@property (nonatomic, assign) NSInteger              cellImageViewTag;
/** ViewController中页面是否消失 */
@property (nonatomic, assign) BOOL                   viewDisappear;
/** 是否在cell上播放video */
@property (nonatomic, assign) BOOL                   isCellVideo;
/** 是否缩小视频在底部 */
@property (nonatomic, assign) BOOL                   isBottomVideo;



@end

@implementation TPShortVideoPlayerView
{
    dispatch_source_t _timer;
    TPDownloadVideoManager *manager;
}

#pragma mark - init
/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZFPlayer
 */
+ (instancetype)sharedPlayerView
{
    static TPShortVideoPlayerView *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[TPShortVideoPlayerView alloc] init];
    });
    return playerView;
}

- (instancetype)initWithVideoUrl:(NSString *)url andVideoType:(Album_Type)type{

    self = [super init];
    self.mediaType = type;

    if (self) {

        self.videoURL = [NSURL URLWithString:url];
        [self setupSubview];
        self.autoPlay = NO;

        //        if (_playerLayer == nil) {
        //
        //            switch (self.mediaType) {
        //                case CLOUD_TYPE:
        //                    self.playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
        //                    break;
        //                case LOCAL_TYPE:{
        //                    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
        //                    self.playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
        //                }
        //                    break;
        //                default:
        //                    break;
        //            }
        //
        //
        //            self.player = [AVPlayer playerWithPlayerItem:_playerItem];
        //
        //            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        //
        //            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //            self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        //            [_playerLayer setBackgroundColor:[UIColor blackColor].CGColor];
        //
        //        }
        //
        //         //判断视频是否已下载
        //         NSString *videoPath = [TPFileOperation getShortVideoPathWithURL:self.videoURL];
        //         _videoPathURL = [NSURL fileURLWithPath:videoPath];
        //
        //         [self.midView.layer addSublayer:self.playerLayer];
        //         [self.midView addSubview:self.playButton];
        //         [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        //         make.center.equalTo(self.midView);
        //         make.width.mas_equalTo(60);
        //         make.height.mas_equalTo(60);
        //         }];
        [self configZFPlayer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _playerLayer.frame = self.midView.bounds;
    _videoBackImgView.frame = self.midView.bounds;
}

- (void)dealloc
{
    if (self.player != nil) {
        [self.player pause];


        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;

        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

        self.player = nil;
        self.playerItem = nil;
        if (_playbackTimeObserver) {
            [_player removeTimeObserver:_playbackTimeObserver];
            _playbackTimeObserver = nil;
        }
    }

}

#pragma mark - subview
- (void)setupSubview
{
    //add subviews

    [self addSubview:self.midView];

    [self.midView addSubview:self.videoBackImgView];

    [self.midView addSubview:self.activityView];


    self.playButton.hidden = YES;

    [self.midView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.midView).with.offset(0);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
}

- (void)setupTopAndBottomView
{
    //set autolayout
    [self addSubview:self.backgroundButton];
    [self sendSubviewToBack:self.backgroundButton];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];

    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self.topView addSubview:self.backButton];

    [self.bottomView addSubview:self.saveButton];

    //top view
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(64);
    }];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).with.offset(20);
        make.left.equalTo(self.topView).with.offset(0);
        make.width.mas_equalTo(51);
        make.height.mas_equalTo(44);
    }];

    //bottom view
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(50);
    }];

    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(self.bottomView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];


    //mid view
    [self.midView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(0);
    }];

    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.midView).with.offset(0);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
}

/**
 *  player添加到cellImageView上
 *
 *  @param cell 添加player的cellImageView
 */
- (void)addPlayerToCell:(UICollectionViewCell *)cell
{
    [cell addSubview:self];
    [cell bringSubviewToFront:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(cell);
    }];
    [self setupSubview];

}

/**
 *  回到cell显示
 */
- (void)updatePlayerViewToCell
{
    if (!self.isBottomVideo) { return; }
    self.isBottomVideo     = NO;

    // 显示控制层
    [self setOrientationPortrait];

}

/**
 *  KVO TableViewContentOffset
 *
 *  @param dict void
 */
- (void)handleScrollOffsetWithDict:(NSDictionary*)dict
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.indexPath];
    NSArray *visableCells = self.collectionView.visibleCells;

    if ([visableCells containsObject:cell]) {
        //在显示中
        [self updatePlayerViewToCell];
    }
    else{
        [self removeFromSuperview];
        [self pause];
    }
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortrait
{
    if (self.isCellVideo) {

        [self removeFromSuperview];
        UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:self.indexPath];
        NSArray *visableCells = self.collectionView.visibleCells;
        self.isBottomVideo = NO;
        if (![visableCells containsObject:cell]) {

        }else {
            // 根据tag取到对应的cellImageView
            //UIImageView *cellImageView = [cell viewWithTag:self.cellImageViewTag];
            [self addPlayerToCell:cell];
        }
    }
}

/**
 *  设置Player相关参数
 */
- (void)configZFPlayer
{
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:self.videoURL];
    // 初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    //        self.playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];

    // 初始化playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];

    // 此处为默认视频填充模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;


    [self.midView.layer addSublayer:self.playerLayer];
    [self.midView addSubview:self.playButton];
    [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.midView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];


    if (self.autoPlay) {
        // 开始播放
        [self play];
        self.playButton.hidden = YES;
    }
    else{
        self.playButton.hidden = NO;
    }



    // 强制让系统调用layoutSubviews 两个方法必须同时写
    [self setNeedsLayout]; //是标记 异步刷新 会调但是慢
    [self layoutIfNeeded]; //加上此代码立刻刷新
}

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo
{
    // 设置Player相关参数
    self.autoPlay = YES;
    [self configZFPlayer];
}

#pragma mark - Download video
- (void)downloadVideo
{
    [self.activityView startAnimating];

    manager = [[TPDownloadVideoManager alloc] init];
    [manager downloadMp4FileWithURL:self.videoURL success:^(NSURL *videoPath) {
        [self.activityView stopAnimating];
        if (videoPath != nil) {
            self.downloaded = YES;
            [self.midView.layer addSublayer:self.playerLayer];
            [self.midView addSubview:self.playButton];
            [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.midView).with.offset(0);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(60);
            }];
        }
        else{
            self.downloaded = NO;
            [self.midView.layer addSublayer:self.playerLayer];
            [self.midView addSubview:self.playButton];
            [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.midView).with.offset(0);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(60);
            }];
        }


    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self.activityView stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"视频无法播放" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }];

}

#pragma mark - show & hide
- (void)show
{
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));

    }];
    [self setupTopAndBottomView];
    [UIView animateWithDuration:0.08f animations:^{

        self.transform = CGAffineTransformMakeScale(0.0f, 0.0f);


    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

            self.transform = CGAffineTransformMakeScale(.5f, .05f);

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

                self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                [self setNeedsLayout];

            } completion:^(BOOL finished) {
                //                [self removeFromSuperview];
                //                [super removeFromSuperview];
            }];
        }];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.08f animations:^{

        self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);


    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

                self.transform = CGAffineTransformMakeScale(0.0f, 0.0f);

            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [super removeFromSuperview];
            }];
        }];
    }];
}

#pragma mark - notification
/**
 *  添加观察者、通知
 */
- (void)addNotifications
{
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];


}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    //    AVPlayerItem *p = [notification object];
    //    [p seekToTime:kCMTimeZero];
    self.playing = NO;
    self.playButton.hidden = NO;
    self.playFinish = YES;
}

- (void)moviePlayDidFail:(NSNotification *)notification
{

}

- (void)appDidEnterBackground
{
    [self pause];
}

- (void)appDidEnterPlayGround
{
    [self play];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                // 视频准备就绪
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initTimer];
                    [self readyToPlay];
                });
            } else {
                // 如果一个不能播放的视频资源加载进来会进到这里
                DDLogInfo(@"视频无法播放");
                // 延迟dismiss播放器视图控制器
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"视频无法播放" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];

            }
        }
        else if ([keyPath isEqualToString:NSStringFromSelector(@selector(loadedTimeRanges))]){
            DDLogInfo(@"loadedTimeRanges");

            if (self.player.currentItem.playbackBufferEmpty) {
                DDLogInfo(@"self.playerItem.playbackBufferEmpty");
                [self.midView bringSubviewToFront:self.activityView];
                self.activityView.hidden = NO;
                [self.activityView startAnimating];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.playing) {
                        [self.player play];
                    };
                });
            }

            if (self.player.currentItem.playbackLikelyToKeepUp){
                DDLogInfo(@"self.playerItem.playbackLikelyToKeepUp");
                [self.activityView stopAnimating];
                self.activityView.hidden = YES;
                if (self.playing) {
                    [self.player play];
                }
            }


        }
        else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){

            if (self.player.currentItem.playbackBufferEmpty) {
                DDLogInfo(@"playbackBufferEmpty");
                [self.midView bringSubviewToFront:self.activityView];
                self.activityView.hidden = NO;
                [self.activityView startAnimating];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.playing) {
                        [self.player play];
                    }

                });
            }

        }
        else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){

            if (self.player.currentItem.playbackLikelyToKeepUp){
                DDLogInfo(@"playbackLikelyToKeepUp");
                [self.activityView stopAnimating];
                self.activityView.hidden = YES;
                if (self.playing) {
                    [self.player play];
                }
            }

        }

    }
    else if (object == self.collectionView) {
        if ([keyPath isEqualToString:kZFPlayerViewContentOffset]) {
            if (([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)) { return; }
            // 当tableview滚动时处理playerView的位置
            [self handleScrollOffsetWithDict:change];
        }
    }

}

#pragma mark - AVPlayerItemStatusReadyToPlay
/**
 *  用于cell上播放player
 *
 *  @param videoURL  视频的URL
 *  @param tableView tableView
 *  @param indexPath indexPath
 */
- (void)setVideoURL:(NSURL *)videoURL
 withCollectionView:(UICollectionView *)collectionView
        AtIndexPath:(NSIndexPath *)indexPath
   withImageViewTag:(NSInteger)tag
{
    // 如果页面没有消失，并且playerItem有值，需要重置player(其实就是点击播放其他视频时候)
    if (!self.viewDisappear && self.playerItem) { [self resetPlayer]; }
    // 在cell上播放视频
    self.isCellVideo      = YES;
    // viewDisappear改为NO
    self.viewDisappear    = NO;
    // 设置imageView的tag
    self.cellImageViewTag = tag;
    // 设置tableview
    self.collectionView   = collectionView;
    // 设置indexPath
    self.indexPath        = indexPath;
    // 设置视频URL
    [self setVideoURL:videoURL];
}

/**
 *  videoURL的setter方法
 *
 *  @param videoURL videoURL
 */
- (void)setVideoURL:(NSURL *)videoURL
{
    //videoURL = [NSURL URLWithString:@"http://ysten.b0.upaiyun.com/uploads/20160920/gzu0cro5u22s8b8i0cc4d2m562yy7rr7.mp4"];
    _videoURL = videoURL;


    // 每次加载视频URL都设置重播为NO
    //    self.repeatToPlay = NO;
    //    self.playDidEnd   = NO;

    // 添加通知
    [self addNotifications];


    //    self.isPauseByUser = YES;
    //    self.controlView.playeBtn.hidden = NO;
    //    [self.controlView hideControlView];
}

- (void)readyToPlay
{
    // 视频可以播放时隐藏activityView，显示playbutton
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;

    // 可以播放
    self.canPlay = YES;
    //    self.playButton.hidden = NO;
}


#pragma mark - button click
- (void)backButtonClicked:(id)sender{


    [self clearPlayer];
    [self hide];
}

//保存视频到相册
- (void)saveButtonClicked:(id)sender
{
    if (self.videoURL != nil) {

        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:HUD];

        if (self.downloaded) {
            //已下载
            [HUD hide:YES];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

            [library writeVideoAtPathToSavedPhotosAlbum:_videoPathURL
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            HUD.mode = MBProgressHUDModeText;
                                            HUD.labelText = @"已保存到相册";
                                            [HUD show:YES];
                                            [HUD hide:YES afterDelay:2.0];

                                            [[NSFileManager defaultManager] removeItemAtURL:_videoPathURL error:NULL];

                                        }];
        }
        else{
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"正在保存...";
            [HUD show:YES];
            //未下载
            manager = [[TPDownloadVideoManager alloc] init];
            [manager downloadMp4FileWithURL:self.videoURL success:^(NSURL *videoPath) {

                if (videoPath != nil) {
                    self.downloaded = YES;
                    [HUD hide:YES];
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

                    [library writeVideoAtPathToSavedPhotosAlbum:videoPath
                                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                                    HUD.mode = MBProgressHUDModeText;
                                                    HUD.labelText = @"已保存到相册";
                                                    [HUD show:YES];
                                                    [HUD hide:YES afterDelay:2.0];

                                                    [[NSFileManager defaultManager] removeItemAtURL:_videoPathURL error:NULL];

                                                }];
                }
                else{
                    [self.activityView stopAnimating];
                    [HUD hide:YES];
                    HUD.mode = MBProgressHUDModeText;
                    HUD.labelText = @"保存失败";
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:1.0];
                }


            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                [self.activityView stopAnimating];
                [HUD hide:YES];
                HUD.mode = MBProgressHUDModeText;
                HUD.labelText = @"保存失败";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1.0];
            }];
        }

    }
}
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
- (void)playButtonClicked:(id)sender{
    DDLogInfo(@"play button clicked");
    if (self.playFinish) {
        self.playButton.hidden = YES;

        [self.player.currentItem seekToTime:kCMTimeZero];
        [self.player play];
        self.playing = NO;
        self.playFinish=NO;
        return;
    }
    if (!self.playing) {
        DDLogInfo(@"play");
        //[self.player play];
        self.playButton.hidden = YES;
        self.playing = YES; // KVO观察playing属性的变化

        //[self.player.currentItem seekToTime:kCMTimeZero];
        [self.player play];
    } else {
        DDLogInfo(@"pause");
        [self.player pause];
        self.playButton.hidden = NO;
        self.playing = NO;
    }
}

#pragma mark - Operation
- (void)play
{
    self.playing = YES;
    self.playButton.hidden = YES;
    [self.midView bringSubviewToFront:self.activityView];
    self.activityView.hidden = NO;
    [self.activityView startAnimating];

    [_player play];
}

- (void)pause
{
    self.playing = NO;
    self.playButton.hidden = NO;
    [_player pause];
}

- (void)clearPlayer
{
    // 播放器暂停
    [self.player pause];

    // 停止加载，清空数据
    [_playerItem cancelPendingSeeks];
    [_playerItem.asset cancelLoading];
    [_player.currentItem cancelPendingSeeks];
    [_player.currentItem.asset cancelLoading];

    [_playerLayer.player.currentItem cancelPendingSeeks];
    [_playerLayer.player.currentItem.asset cancelLoading];
    [_playerLayer.player.currentItem cancelPendingSeeks];
    [_playerLayer.player.currentItem.asset cancelLoading];

    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;

    [self.player replaceCurrentItemWithPlayerItem:nil];


    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    self.player = nil;
    self.playerItem = nil;
}

/**
 *  重置player
 */
- (void)resetPlayer
{
    // 改为为播放完
    //self.playDidEnd         = NO;
    self.playerItem         = nil;
    //self.didEnterBackground = NO;

    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];

    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.player = nil;

    // cell上播放视频 && 不是重播时
    if (self.isCellVideo) {
        // vicontroller中页面消失
        self.viewDisappear = YES;
        self.isCellVideo   = NO;
        self.collectionView= nil;
        self.indexPath     = nil;
    }
}

- (void)downloadShortVideoToAlbum
{
    [self saveButtonClicked:nil];
}

#pragma  mark - 定时器
- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = _playerItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}

- (void)initTimer
{
    if (_playbackTimeObserver) {
        [_player removeTimeObserver:_playbackTimeObserver];
        _playbackTimeObserver = nil;
    }
    //    double interval = .1f;
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }


    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver =  [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)  queue:dispatch_get_main_queue() /* If you pass NULL, the main queue is used. */
                                                                          usingBlock:^(CMTime time){

                                                                              float current = CMTimeGetSeconds(time);

                                                                              if (current > 0 ) {

                                                                                  [self.activityView stopAnimating];
                                                                                  self.activityView.hidden = YES;

                                                                                  //                                                                                  if (!self.playing) {
                                                                                  //                                                                                      self.playing = YES;
                                                                                  //                                                                                      self.playButton.hidden = YES;
                                                                                  //                                                                                  }

                                                                              }
                                                                          }];

}


#pragma mark - Setter & Getter
/**
 *  根据tableview的值来添加、移除观察者
 *
 *  @param tableView tableView
 */
//- (void)setTableView:(UITableView *)tableView
//{
//    if (_tableView == tableView) { return; }
//
//    if (_tableView) { [_tableView removeObserver:self forKeyPath:kZFPlayerViewContentOffset]; }
//    _tableView = tableView;
//    if (tableView) { [tableView addObserver:self forKeyPath:kZFPlayerViewContentOffset options:NSKeyValueObservingOptionNew context:nil]; }
//}

- (void)setCollectionView:(UICollectionView *)collectionView
{
    if (_collectionView == collectionView) {
        return;
    }
    if (_collectionView) { [_collectionView removeObserver:self forKeyPath:kZFPlayerViewContentOffset]; }
    _collectionView = collectionView;
    if (_collectionView) { [_collectionView addObserver:self forKeyPath:kZFPlayerViewContentOffset options:NSKeyValueObservingOptionNew context:nil]; }
}

- (UIButton *)backgroundButton
{
    if (!_backgroundButton) {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundButton.backgroundColor = [UIColor blackColor];
        _backgroundButton.alpha = 0.5;

    }
    return _backgroundButton;
}

- (UIImageView *)videoBackImgView
{
    if (!_videoBackImgView) {
        _videoBackImgView = [[UIImageView alloc] init];
        _videoBackImgView.backgroundColor = [UIColor blackColor];
        //_videoBackImgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    }
    return _videoBackImgView;
}

//- (AVPlayerLayer *)playerLayer
//{
//    if (_playerLayer == nil) {
//
//        switch (self.mediaType) {
//            case CLOUD_TYPE:
//                self.playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
//                break;
//            case LOCAL_TYPE:{
//                AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
//                self.playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
//            }
//                break;
//            default:
//                break;
//        }
//
//
//        self.player = [AVPlayer playerWithPlayerItem:_playerItem];
//
//        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
//
//        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
//        [_playerLayer setBackgroundColor:[UIColor blackColor].CGColor];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(playerItemDidReachEnd:)
//                                                     name:AVPlayerItemDidPlayToEndTimeNotification
//                                                   object:[self.player currentItem]];
//        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:playerItemStatusContext];
//
//    }
//    return _playerLayer;
//}

/**
 *  根据playerItem，来添加移除观察者
 *
 *  @param playerItem playerItem
 */
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem == playerItem) {return;}

    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges))];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        if (_playbackTimeObserver) {
            [_player removeTimeObserver:_playbackTimeObserver];
            _playbackTimeObserver = nil;
        }

    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidFail:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges)) options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self
                     forKeyPath:@"playbackBufferEmpty"
                        options:NSKeyValueObservingOptionNew
                        context:nil];

        [playerItem addObserver:self
                     forKeyPath:@"playbackLikelyToKeepUp"
                        options:NSKeyValueObservingOptionNew
                        context:nil];

    }
}

- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = kColorBlueTheme;
    }
    return _topView;
}

- (UIButton *)backButton
{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"white_back_btn"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIView *)midView
{
    if (_midView == nil) {
        _midView = [[UIView alloc] init];
        _midView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonClicked:)];
        tapGesture.numberOfTapsRequired = 1;
        [_midView addGestureRecognizer:tapGesture];
    }
    return _midView;
}

- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kColorLightGrayBackground;

    }
    return _bottomView;
}

- (UIButton *)playButton
{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //shortvideo_close_btn  shortvideo_play_btn
        [_playButton setBackgroundImage:[UIImage imageNamed:@"shortvideo_play_btn"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [_saveButton setTitle:@"下载到本地" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_saveButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton setBackgroundColor:[UIColor whiteColor]];

    }
    return _saveButton;
}

- (TPShortVideoProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[TPShortVideoProgressView alloc] init];
        //        _progressView.trackTintColor = [UIColor colorWithRed:55/255.0 green:143/255.0 blue:206/255.0 alpha:1.0];
        //        _progressView.progressTintColor = [UIColor colorWithRed:74/255.0 green:97/255.0 blue:117/255.0 alpha:1.0];
    }
    return _progressView;
}

- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _activityView;
}

- (UILabel *)durationLabel
{
    if (_durationLabel == nil) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.backgroundColor = [UIColor clearColor];
        _durationLabel.font = [UIFont systemFontOfSize:14.0];
        _durationLabel.textColor = [UIColor colorWithRed:55/255.0 green:145/255.0 blue:209/255.0 alpha:1.0];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _durationLabel;
}

@end
