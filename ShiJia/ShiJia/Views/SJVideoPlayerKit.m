//
//  SJVideoPlayerKit.m
//  ShiJia
//
//  Created by yy on 16/3/16.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJVideoPlayerKit.h"

#import "SJVideoPlayerView.h"

#import "AES128Util.h"
#import "TPXmppRoomManager.h"
#import "MLPlayVoiceButton.h"

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;
static NSString * const PlayerPreloadObserverContext = @"PlayerPreloadObserverContext";

@interface SJVideoPlayerKit ()<SJVideoPlayerViewDelegate>
{
    NSTimeInterval totalBuffer;
    RACDisposable *handler;
}
@property (nonatomic, strong) SJVideoPlayerView *playerView;
@property (nonatomic, strong) AVPlayer          *player;
@property (nonatomic, strong) AVPlayerItem      *playerItem;
//监听播放起状态的监听者
@property (nonatomic ,strong) id playbackTimeObserver;
@property (readwrite, strong) id                scrubberTimeObserver;
@property (readwrite, strong) id                playClockTimeObserver;
@property (nonatomic, assign) BOOL              isSeeking;
@property (nonatomic, assign) BOOL              isAddObserver;
@property (nonatomic, assign, readwrite) CGFloat currentPlayedSeconds;
@property (nonatomic, assign, readwrite) CGFloat videoDuration;
@property (nonatomic, assign) SJVideoPlayerViewStyle lastStyle;


@end

@implementation SJVideoPlayerKit

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
   
    if (self) {
        
        
        //player view
        _playerView = [[SJVideoPlayerView alloc] initWithOrigin:CGPointMake(0, 0)];
        _playerView.backgroundColor = [UIColor blackColor];
        _playerView.delegate = self;
        
        
        // 监听播放器全屏/小屏
        handler = [RACObserve(_playerView, style) subscribeNext:^(NSNumber *style) {
            
            if (style.integerValue == SJVideoPlayerViewStyleFullScreen && [self.delegate respondsToSelector:@selector(playerDidFinishFullScreen)])
            {
                // 播放器全屏
                [self.delegate playerDidFinishFullScreen];
            }
            else if(style.integerValue == SJVideoPlayerViewStyleMini && [self.delegate respondsToSelector:@selector(playerDidFinishMinimumScreen)])
            {
                // 播放器小屏
                [self.delegate playerDidFinishMinimumScreen];
            }
        }];
        
        // 监听网络状态改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:TPIMNotification_NetReachability object:nil];
        
        // 监听播放器被中断通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerWasInterrupted:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];

        // 获取当前网络状态
        [self handleNetwork:[self currentNetWorkStates]];
        
        _videoStartFrom = 0.00f;
    }
    
    return self;
}

- (void)dealloc
{
    DDLogInfo(@"########## VideoPlayerKit dealloc");
}

#pragma mark - Operation
- (void)clearPlayer
{
    // 播放器暂停
    //[_playerView recoverMiniScreen];
//    if (_playerView.style == SJVideoPlayerViewStyleFullScreen) {
//        [_playerView recoverMiniScreen];
//    }

    [self stop];
    
    [_playerView handle_dealloc];
    // 停止加载，清空数据
    [_playerItem cancelPendingSeeks];
    [_playerItem.asset cancelLoading];
    [_player.currentItem cancelPendingSeeks];
    [_player.currentItem.asset cancelLoading];
    [_player removeTimeObserver:_playbackTimeObserver];
    [_player replaceCurrentItemWithPlayerItem:nil];
    
    
    _playerView.player = nil;
    [_playerView removeFromSuperview];
    _playerView = nil;
    _player = nil;
    _playerItem = nil;
    
    _actionUrl = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _delegate = nil;
    _activeController = nil;
    
    [handler dispose];
}

- (void)clearPlayerWithCompletion:(void (^)())completion
{
    if (_playerView.style == SJVideoPlayerViewStyleFullScreen) {
        [_playerView setDidFinishRecoverMiniScreen:^{
            
            completion();
        }];
        
        [_playerView recoverMiniScreen];
    }
    else{
        completion();
    }
}

- (void)play
{
    if (self.noFree &&self.currentPlayedSeconds>=self.trialDura && self.trialDura>=0) {
        return;
    }

    if (_playerView.showWithoutWifiView ||  _playerView.showWithoutNetworkView) {
        
        // 无WiFi或网络时，暂停播放、暂停加载
        _playerView.status = SJVideoPlayerViewStatusPaused;
        [_player pause];
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
        
    }
    else{
        // 其他状态开始播放
        if (!_isAddObserver) {
            //重新注册KVO、KVC
            [self addObservers];
//            [self addPlayerTimeObservers];
        }
        
        [_player play];
        if (_playerView.status == SJVideoPlayerViewStatusPaused) {
            _playerView.status = SJVideoPlayerViewStatusPlaying;
        }
    }

}

- (void)stop
{
    if (_isAddObserver) {
        //删除监听
        [self removeObservers];
        //[self removePlayerTimeObservers];
    }
    
    //播放器暂停
    [_player pause];
    _playerView.status = SJVideoPlayerViewStatusPaused;
}

- (void)seekToTime:(CGFloat)seconds
{
    if (!_isAddObserver) {
        [self addObservers];
        //[self addPlayerTimeObservers];
    }
    
    //    [_player play];
    //    _playerView.status = SJVideoPlayerViewStatusPlaying;
    if (_player.status == AVPlayerStatusReadyToPlay) {
        
        CMTime time = CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
        [_player pause];
        _playerView.status = SJVideoPlayerViewStatusPaused;
        _isSeeking = YES;
        
        [_player seekToTime:time completionHandler:^(BOOL finished) {
            if (finished) {
                _isSeeking = NO;
                _playerView.status = SJVideoPlayerViewStatusPlaying;
            }
        }];
    }
    
    
}

- (void)mutePlayer
{
    self.player.volume = 0.0;
}

- (void)recoverPlayerVolume
{

    self.player.volume  = 1.0;
}

#pragma mark - SJVideoPlayerViewDelegate
// 返回
- (void)playerViewDidClickBack:(SJVideoPlayerView *)playerview
{
    if (self.didClickBack) {
        self.didClickBack();
    }
    else{
        [self clearPlayer];
        [self.activeController.navigationController popViewControllerAnimated:YES];
    }
}

// 播放
- (void)playerViewDidClickPlay:(SJVideoPlayerView *)playerview
{
    if (self.isScreening) {
        if ([self.delegate respondsToSelector:@selector(playerDidResumeInScreening)]) {
            [self.delegate playerDidResumeInScreening];
        }
    }
    else{
        if (_player.status == AVPlayerStatusReadyToPlay) {
            _playerView.status = SJVideoPlayerViewStatusPlaying;
            [_player play];
        }
    }
    
}

// 暂停
- (void)playerViewDidClickPause:(SJVideoPlayerView *)playerview
{
    if (self.isScreening) {
        if ([self.delegate respondsToSelector:@selector(playerDidPauseInScreening)]) {
            [self.delegate playerDidPauseInScreening];
        }
    }
    else{
        _playerView.status = SJVideoPlayerViewStatusPaused;
        _player.rate = 0.0;
        [_player pause];
        DDLogInfo(@"%f",_player.rate);
    }
    
}

// 分享
- (void)playerViewDidClickShare:(SJVideoPlayerView *)playerview
{
    if (self.actionUrl!=nil/*&&[[self.actionUrl  description] containsString:@".m3u8"]*/) {
        if ([self.delegate respondsToSelector:@selector(playerDidClickShare)]) {
            [self.delegate playerDidClickShare];
        }
    }
}

// 收藏
- (void)playerViewDidClickStar:(SJVideoPlayerView *)playerview
{
    if ([self.delegate respondsToSelector:@selector(playerDidClickCollect)]) {
        [self.delegate playerDidClickCollect];
    }
}

// 弹幕开关
- (void)playerViewDidClickDanmu:(SJVideoPlayerView *)playerview
{
    if (self.didClickDanmu) {
        self.didClickDanmu(_playerView.showBarrage);
    }
}

// 投屏
- (void)playerViewDidClickScreen:(SJVideoPlayerView *)playerview
{
    if ([self.delegate respondsToSelector:@selector(playerDidClickScreen)]) {
        [self.delegate playerDidClickScreen];
    }
}

// 取消投屏
- (void)playerViewDidCancelScreen:(SJVideoPlayerView *)playerview
{
    if ([self.delegate respondsToSelector:@selector(playerDidCancelScreen)]) {
        [self.delegate playerDidCancelScreen];
    }
}

// 选集
- (void)playerView:(SJVideoPlayerView *)playerview didClickSeriesAtIndex:(NSInteger)index
{
    self.isDidClickSeries = YES;
    self.currentVideoIndex = index;
}

// seek
- (void)playerView:(SJVideoPlayerView *)playerview didSlideToSeconds:(CGFloat)seconds
{
    if (self.isScreening) {
        // 正在投屏
        CMTime time = CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
        [_player seekToTime:time completionHandler:^(BOOL finished) {
            if (finished) {
                //_playerView.status = SJVideoPlayerViewStatusPlaying;
                if ([self.delegate respondsToSelector:@selector(playerDidSeekToSecondsInScreening:)]) {
                    [self.delegate playerDidSeekToSecondsInScreening:seconds];
                }
            }
        }];
        
    }
    else{
        float total = CMTimeGetSeconds([_playerItem duration]);
        if (seconds >= total) {
            
            //进度条拖动到影片最后时自动切换下一集
            if (_playerView.seriesCount > (_currentVideoIndex + 1)) {
                self.currentVideoIndex += 1;
                //_playerView.currentVideoIndex = _currentVideoIndex;
                //[_playerView resetPlayedTime];
            }
            //add by jhl 20170314
            if (_player.status == AVPlayerStatusReadyToPlay) {
                //拖动进度条
                CMTime time = CMTimeMakeWithSeconds(1, NSEC_PER_SEC);
                [_player pause];
                _isSeeking = YES;
                [_player seekToTime:time completionHandler:^(BOOL finished) {
                    if (finished) {
                        _isSeeking = NO;
                        _playerView.status = SJVideoPlayerViewStatusPlaying;
                    }
                }];
            }
            //end
            
        }
        else{
            if (_player.status == AVPlayerStatusReadyToPlay) {
                
                //拖动进度条
                CMTime time = CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
                [_player pause];
                _isSeeking = YES;
                [_player seekToTime:time completionHandler:^(BOOL finished) {
                    if (finished) {
                        _isSeeking = NO;
                        _playerView.status = SJVideoPlayerViewStatusPlaying;
                    }
                }];
            }
            
        }
    }
    
}

// 无WiFi时点击继续播放
- (void)playerViewDidClickContinueWithoutWifi:(SJVideoPlayerView *)playerview
{

    [self removePlayerTimeObservers];
    [self initTimer];
    //_playerView.status = SJVideoPlayerViewStatusPlaying;
    [self play];
}

// 无网络时点击重新加载
- (void)playerViewDidClickRetry:(SJVideoPlayerView *)playerview
{
//    AFNetworkReachabilityStatus status = [self currentNetWorkStates];
//    
//    if (status == AFNetworkReachabilityStatusNotReachable) {
//        [self handleNetwork:status];
//    }
//    else{
        [self play];
//    }
    
}

// 播放器frame即将发生改变
- (void)playerViewWillChangeFrame
{
    if ([self.delegate respondsToSelector:@selector(playerWillChangeFrame)]) {
        [self.delegate playerWillChangeFrame];
    }
}

#pragma mark - Private
- (void)addPlayerTimeObservers:(void (^)(CMTime time))block
{
    if (_scrubberTimeObserver) {
        [_player removeTimeObserver:_scrubberTimeObserver];
        _scrubberTimeObserver = nil;
    }
    _scrubberTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(60 * 5.0, 1.0) queue:NULL usingBlock:block];
}

-(void)removePlayerTimeObservers
{
    if (_scrubberTimeObserver) {
        [_player removeTimeObserver:_scrubberTimeObserver];
        _scrubberTimeObserver = nil;
    }
    
    if (_playClockTimeObserver) {
        [_player removeTimeObserver:_playClockTimeObserver];
        _playClockTimeObserver = nil;
    }
    
    if (_playbackTimeObserver) {
        [_player removeTimeObserver:_playbackTimeObserver];
        _playbackTimeObserver = nil;
    }
}

- (void)addObservers
{
    // 监听影片状态
    _isAddObserver = YES;
    [_playerItem addObserver:self forKeyPath:NSStringFromSelector(@selector(status)) options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    [_playerItem addObserver:self forKeyPath:NSStringFromSelector(@selector(error)) options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    
    // 监听缓冲进度
    [_playerItem addObserver:self forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges)) options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(PlayerPreloadObserverContext)];
    
    [_playerItem addObserver:self
                  forKeyPath:@"playbackBufferEmpty"
                     options:NSKeyValueObservingOptionNew
                     context:PlayViewStatusObservationContext];
    
    [_playerItem addObserver:self
                  forKeyPath:@"playbackLikelyToKeepUp"
                     options:NSKeyValueObservingOptionNew
                     context:PlayViewStatusObservationContext];
    
    [_playerItem addObserver:self
                  forKeyPath:NSStringFromSelector(@selector(duration))
                     options:NSKeyValueObservingOptionNew
                     context:PlayViewStatusObservationContext];
  
    [_playerView addObserver:self
                  forKeyPath:NSStringFromSelector(@selector(status))
                     options:NSKeyValueObservingOptionNew
                     context:PlayViewStatusObservationContext];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeGround)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidFail:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:_playerItem];
    
}

- (void)removeObservers
{
    
    _isAddObserver = NO;
    
    [_playerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(status))];
    [_playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(status))];
    [_playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(error))];
    [_playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(loadedTimeRanges))];
    [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [_playerItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(duration))];
#if 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:_playerItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
#endif
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
   // [self removePlayerTimeObservers];
}

/**
 *  缓冲回调
 */
- (void)loadedTimeRanges
{
    _playerView.status = SJVideoPlayerViewStatusCaching;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!_isScreening) {
            [self play];
        }
    });
}

- (void)updatePlayerUrl:(NSString *)url
{
    NSMutableDictionary * headers = [NSMutableDictionary dictionary];
    totalBuffer = 0;
    // 频道 user agent
    //if (_userAgent.length != 0) {
        [headers setObject:@"010121###MOBILE" forKey:@"User-Agent"];
        [headers setObject:@"010121###MOBILE" forKey:@"yid"];
        //[headers setObject:_userAgent forKey:@"User-Agent"];
   // }
    
    self.playerItem = nil;
    AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    //elf.playerItem.asset.
    self.player = nil;
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    _playerView.player = _player;
}

- (void)handleNetwork:(AFNetworkReachabilityStatus)networkStatus
{
    switch (networkStatus) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            // 蜂窝网络
            if (self.playerView.allControlsHidden) {
                break;
            }
            _playerView.showWithoutWifiView = YES;
            [_player pause];
            [_player.currentItem cancelPendingSeeks];
            [_player.currentItem.asset cancelLoading];
            
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            // 无线网
            if (self.playerView.allControlsHidden) {
                break;
            }
            
            if (_playerView.showWithoutWifiView || _playerView.showWithoutNetworkView) {
                [self stop];
            }
            _playerView.showWithoutWifiView = NO;
            _playerView.showWithoutNetworkView = NO;
            
            [self play];
        }
            break;
        case AFNetworkReachabilityStatusNotReachable:
        {
            // 无可用网络
            if (self.playerView.allControlsHidden) {
                break;
            }
            if (totalBuffer < (self.currentPlayedSeconds + 5)) {
                self.playerView.showWithoutNetworkView = YES;
            }
            //_playerView.showWithoutNetworkView = YES;
        }
            break;
        case AFNetworkReachabilityStatusUnknown:
        {
            
        }
            break;
            
        default:
            break;
    }

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
-(void)setTrialDura:(CGFloat)trialDura{
    _trialDura = trialDura;
    _playerView.trialDura = trialDura;
}
- (void)initTimer
{
    if (_playbackTimeObserver) {
        [_player removeTimeObserver:_playbackTimeObserver];
        _playbackTimeObserver = nil;
    }
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }

    float total = CMTimeGetSeconds([_playerItem duration]);
    if (total > 0 ) {
        // 如果影片总时长为0，更新
        [_playerView updateTotalTime:total];
        self.videoDuration = total;
    }
    
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver =  [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)  queue:dispatch_get_main_queue() /* If you pass NULL, the main queue is used. */usingBlock:^(CMTime time){
    float current = CMTimeGetSeconds(time);
    if (self.noFree) {
        if (!self.trialDura) {
            float total = CMTimeGetSeconds([_playerItem duration]);
            if (total >600) {
                self.trialDura = 360;
            }
            else{
                self.trialDura = total/2;
            }
        }
        if (current>self.trialDura) {
            [self.playerView showFullPayTipView:@"付费内容，观看完整版请开通会员"];
            [self stop];
        }
        self.currentPlayedSeconds = current;
    }
        if (current > 0 && !_isSeeking) {
            if (!self.playerView.isSliding) {
                //更新播放时间
                [self.playerView updatePlayedTime:current];
                self.currentPlayedSeconds = current;
            }
        }
    }];
    
}


#pragma mark - KVO & NSNotification
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (object == _playerView) {
        NSString* val = [change objectForKey:@"new"];
        if ([val intValue] == SJVideoPlayerViewStatusPaused) {
            _countPause ++;
        }
    }
    
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(status))])
    {
        // 播放状态
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        
        if ([playerItem status] == AVPlayerStatusReadyToPlay)
        {
            // 准备播放
            if (_datePoint > 0) {
                
                _videoStartFrom = _datePoint;
                // 断点播放
                CMTime time = CMTimeMakeWithSeconds(_datePoint, NSEC_PER_SEC);
                [_player seekToTime:time completionHandler:^(BOOL finished) {
                    if (finished) {
                        _playerView.status = SJVideoPlayerViewStatusPlaying;
                        [_player play];
                        _datePoint = 0;
                    }
                }];
            }
            else{
            
                if (!_playerView.showWithoutNetworkView & !_playerView.showWithoutWifiView) {
                    // 非无网络或无WiFi状态下，开始播放
                    _playerView.status = SJVideoPlayerViewStatusReadyToPlay;
                    [self initTimer];
                    [_player play];
                }
                
            }
            
            static NSString* oldUrl = nil;
            
            if ([oldUrl isEqualToString:[_actionUrl absoluteString]] == NO) {
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_vedioReadyToPlay object:nil];
            }
            oldUrl = [_actionUrl absoluteString];
            
        }
        else if ([playerItem status] == AVPlayerStatusFailed)
        {
            // 影片加载失败
            DDLogError(@"影片加载失败");
            _playerView.status = SJVideoPlayerViewStatusFailed;
        }
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(isExternalPlaybackActive))]){
        DDLogInfo(@"isExternalPlaybackActive");
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(error))])
    {
        DDLogInfo(@"error:%@",_playerItem.error.description);
        [[NSUserDefaults standardUserDefaults] setObject:_playerItem.error.description forKey:kPlayerError];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(loadedTimeRanges))])
    {
        
        // 缓冲进度
        AVPlayerItem *playerItem = self.player.currentItem;
        
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);

//        NSTimeInterval tb = startSeconds + durationSeconds;
//        if (totalBuffer < tb) {
//            totalBuffer = tb;
//        }
//        else{
//            if (_player.status != SJVideoPlayerViewStatusPaused) {
//                [_player play];
//            }
//            
//        }
        totalBuffer = startSeconds + durationSeconds;//缓冲总长度
 
        
        if (totalBuffer > 0 && !_isSeeking) {
            [_playerView updateCacheTime:totalBuffer];
        
        }
        
        _avgTotalBuffer = totalBuffer/(_countBuffer + 1);
        _countBuffer++;
    }
    
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(duration))])
    {
        // !CMTIME_IS_VALID(time)
        // 影片总时长
        float total = CMTimeGetSeconds([_playerItem duration]);
        
        if (isnan(total)) {
            total = 0;
        }
        
        if (total >= 0 ) {
            
            [_playerView updateTotalTime:total];
        }
        
        self.videoDuration = total;
    }
    
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        //_playerView.status = SJVideoPlayerViewStatusCaching;
        // 没有缓冲时
        if (self.playerItem.playbackBufferEmpty) {
            AFNetworkReachabilityStatus status = [self currentNetWorkStates];
            
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [self handleNetwork:status];
            }
            else{
                _playerView.status = SJVideoPlayerViewStatusCaching;
                [self loadedTimeRanges];
            }
        }
        
    }
    
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    { // 当缓冲好的时候
        if (self.playerItem.playbackLikelyToKeepUp && _playerView.status == SJVideoPlayerViewStatusCaching){
            _playerView.status = SJVideoPlayerViewStatusPlaying;
        }
    }
    
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(style))])
        
    {
        if (_playerView.style == SJVideoPlayerViewStyleFullScreen && [self.delegate respondsToSelector:@selector(playerDidFinishFullScreen)])
        {
            // 播放器全屏
            [self.delegate playerDidFinishFullScreen];
        }
        else if(_playerView.style == SJVideoPlayerViewStyleMini && [self.delegate respondsToSelector:@selector(playerDidFinishMinimumScreen)])
        {
            // 播放器小屏
            [self.delegate playerDidFinishMinimumScreen];
        }
        
    }
}

- (void)moviePlayDidEnd:(NSNotification *)sender
{
    if ([self.delegate respondsToSelector:@selector(playerDidPlayToCacheVideo)]) {
        [self.delegate playerDidPlayToCacheVideo];
    }
    [self play];
    if (_playerView.seriesCount > (_currentVideoIndex + 1)) {
        //有下一集时播放下一集
        self.currentVideoIndex += 1;
        //_playerView.currentVideoIndex = _currentVideoIndex;
    }
    else{
        //结束播放
        _playerView.status = SJVideoPlayerViewStatusFinished;
        if ([self.delegate respondsToSelector:@selector(playerDidPlayToEnd)]) {
            [self.delegate playerDidPlayToEnd];
        }
        
    }
}

- (void)moviePlayDidFail:(NSNotification *)sender
{
    //播放失败
    DDLogInfo(@"\nmoviePlayDidFail:\n");
    [self stop];
    [self setActionUrl:_actionUrl];
}


- (void)applicationDidEnterBackground
{
    // app进入后台
    if (_isScreening) {
        return;
    }
    NSArray *tracks = [self.playerItem tracks];
    for (AVPlayerItemTrack *playerItemTrack in tracks) {
        if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
            playerItemTrack.enabled = YES;
        }
    }
    self.lastStyle = _playerView.style;
    _playerView.status = SJVideoPlayerViewStatusPaused;
    [_player pause];
}

- (void)applicationWillEnterForeGround
{
    // app进入前台
    if (_isScreening) {
        return;
    }
    if (_player.status == AVPlayerStatusReadyToPlay) {
        _playerView.style = _lastStyle;
        if (_lastStyle == SJVideoPlayerViewStyleFullScreen) {
            [_playerView performSelector:@selector(recoverFullScreen) withObject:self afterDelay:1.0];
            //[_playerView recoverFullScreen];
        }
        _playerView.status = SJVideoPlayerViewStatusPlaying;
        NSArray *tracks = [self.playerItem tracks];
        for (AVPlayerItemTrack *playerItemTrack in tracks) {
            if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
                playerItemTrack.enabled = YES;
            }
        }
        if (_player.status != SJVideoPlayerViewStatusPaused) {
            [_player play];
        }
        
    }
}

- (void)networkStatusChanged:(NSNotification *)notification
{
    // 网络改变
    NSNumber *num = [notification.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem];
    AFNetworkReachabilityStatus networkStatus = [num integerValue];
    [self handleNetwork:networkStatus];
    
}

- (AFNetworkReachabilityStatus)currentNetWorkStates
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus networkStatus = [manager networkReachabilityStatus];
    return networkStatus;
}

- (void)playerWasInterrupted:(NSNotification *)notification
{
    AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    switch (type)
    {
        case AVAudioSessionInterruptionTypeBegan:
        {
                [self.player pause];
                _playerView.status = SJVideoPlayerViewStatusPaused;
            
            break;
        }
        case AVAudioSessionInterruptionTypeEnded:
        {
            AVAudioSessionInterruptionOptions option = [notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
            if (option == AVAudioSessionInterruptionOptionShouldResume)
            {
                //[self play];
            }
            break;
        }
        default:
        {
            break;
        }
    }
    
}


#pragma mark - Setter & Getter
- (void)setIsScreening:(BOOL)isScreening
{
    _playerView.isScreening = isScreening;
    if (isScreening) {
        
        [self stop];
        _playerView.status = SJVideoPlayerViewStatusScreening;
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
    }
    else{
        if (_isScreening) {
            _playerView.status = SJVideoPlayerViewStatusPlaying;
            [self play];
        }
    }
    _isScreening = isScreening;
}

-(void)setIsTVPlay:(BOOL)isTVPlay{
    _isTVPlay = isTVPlay;
    if (_isTVPlay) {
        _playerView.status = SJVideoPlayerViewStatusOnlyTvPlay;
    }
}
#pragma mark - Setter & Getter
-(void)setNoFree:(BOOL)noFree{
    _noFree = noFree;
    _playerView.noFree = _noFree;
}
- (void)setCurrentVideoIndex:(NSInteger)currentVideoIndex
{
    _currentVideoIndex = currentVideoIndex;
    _playerView.currentVideoIndex = currentVideoIndex;
}

- (void)setActionUrl:(NSURL *)actionUrl
{
    self.noFree = NO;
    //_actionUrl = actionUrl;
    _actionUrl = [HiTVGlobals dingxiangIpForPlayUrl:actionUrl];
    if (_isAddObserver) {
        
        [self removeObservers];
        [self removePlayerTimeObservers];
    }
    
    _isScreening = NO;
    _playerView.isScreening = _isScreening;
    
    if (_playbackTimeObserver) {
        [_player removeTimeObserver:_playbackTimeObserver];
        _playbackTimeObserver = nil;
    }
    
    if (actionUrl) {
        [self updatePlayerUrl:actionUrl.absoluteString];
        _playerView.status = SJVideoPlayerViewStatusCaching;
        [self play];
    }
    
}

- (UIView *)view
{
    return self.playerView;
}
-(void)showFullPayTipView{
    [self.playerView showFullPayTipView:@"付费内容，观看完整版请开通会员"];
    [self stop];
}

-(long long)getReceivedBytes
{
    AVPlayerItemAccessLog *accesslog = _player.currentItem.accessLog;
    NSArray *events = [accesslog events];
    AVPlayerItemAccessLogEvent *event = events.firstObject;
    
    return [event numberOfBytesTransferred]/1024;
}
@end
