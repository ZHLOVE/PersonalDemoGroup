//
//  SJVideoPlayerView.m
//  ShiJia
//
//  Created by yy on 16/3/16.
//  Copyright © 2016年 yy. All rights reserved.
//  播放器

#import "SJVideoPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <REMenu/REMenu.h>
#import <BarrageRenderer/BarrageRenderer.h>

#import "SJVideoPlayerScreenView.h"
#import "SJVideoPlayerWithoutWifiView.h"
#import "SJVideoPlayerWithoutNetworkView.h"
#import "SJVideoPlayerCustomHUDView.h"
#import "ZFBrightnessView.h"

#import "SJVideoPlayerTitleNode.h"
#import "SJVideoPlayerBottomNode.h"
#import "SJVideoPlayerSlider.h"
#import "SJPlayerSlider.h"
#import "SJVideoPlayerSeriesView.h"
#import "CFDanmakuView.h"
#import "TPDanmakuData.h"
#import "SJPayfilmTipView.h"
#import "SJVideoPlayerSettingView.h"

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

static CGFloat kPlayerAspectRatio    = 320.0 / 180.0;//播放器长宽比
static CGFloat kMenuWidth            = 120.0;
static CGFloat kMenuHeight           = 40.0;
static CGFloat kLeftMargin           = 15.0;
static CGFloat kLockButtonWidth      = 40.0;
//static CGFloat kInnerPadding         = 10.0;
static CGFloat kLiveLogoWidth               = 25.0;// 直播logo宽度
static CGFloat kLiveLogoHeight              = 17.0;// 直播logo高度

@interface SJVideoPlayerView ()<SJVideoPlayerTitleViewDelegate,SJVideoPlayerBottomViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray* RACObserves;
}

@property (nonatomic, strong) AVPlayerLayer                   *playerLayer;
@property (nonatomic, strong) SJVideoPlayerTitleNode          *titleNode;//播放器导航栏
@property (nonatomic, strong) SJVideoPlayerBottomNode         *bottomNode;//播放器底部工具栏
@property (nonatomic, strong) UIButton                        *lockButton;//锁屏键
@property (nonatomic, strong) REMenu                          *menu;//更多菜单
@property (nonatomic, strong) SJVideoPlayerSeriesView         *seriesView;//选集view
@property (nonatomic, strong) UIActivityIndicatorView         *activity;//加载中view
@property (nonatomic, strong) BarrageRenderer                 *renderer;//弹幕
@property (nonatomic, strong) REMenuItem                      *collectItem;//收藏菜单
@property (nonatomic, strong) REMenuItem                      *screenItem;//投屏菜单
@property (nonatomic, strong) SJVideoPlayerSettingView        *settingView;//播放器画面设置view
@property (nonatomic, strong) SJVideoPlayerScreenView         *screenView;//播放器投屏提示view
@property (nonatomic, strong) SJVideoPlayerWithoutWifiView    *withoutWifiView;//4g提示view
@property (nonatomic, strong) SJVideoPlayerWithoutNetworkView *withoutNetworkView;//无网络提示view
@property (nonatomic, strong) SJPayfilmTipView                *payfilmTipView;//够买提示view

@property (nonatomic, strong, readonly) ASImageNode  *liveLogo;// 直播标志

@property (nonatomic, strong) UIPanGestureRecognizer          *panGesture;//手势
@property (nonatomic, strong) UISlider                        *volumeViewSlider;//音量控制slider

/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection        panDirection;

/** 是否在调节音量*/
@property (nonatomic, assign) BOOL                isVolume;

/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat             sumTime;

@property (nonatomic, assign) CGFloat             oldBrightness;//用来保存亮度原始值

@property (nonatomic, assign) CGFloat             oldVolume;//用来保存音量原始值


@property (nonatomic, readwrite)         CGSize size;//播放器尺寸
@property (nonatomic, assign)            BOOL   showControls;//显示控制标志位
@property (nonatomic, assign)            BOOL   showDanmaku;//显示弹幕标志位
@property (nonatomic, assign, readwrite) BOOL   locked;//锁屏标志位
@property (nonatomic, assign) CATransform3D oldTransform;//用于保存视频原始比例

@property (nonatomic, strong) UIImageView *defaultImg;

@end

@implementation SJVideoPlayerView
{
    dispatch_source_t _timer;
    CGFloat totalSeconds;
    CGPoint startPoint;
    CGPoint endPoint;
    //BOOL isSliding;
    MBProgressHUD *HUD;
    MBProgressHUD *verHUD;
    
    NSTimer *verTimer;
}
#pragma mark - Lifecycle
- (instancetype)initWithOrigin:(CGPoint)viewOrigin
{
    self = [super init];
    
    if (self) {
        
        
        RACObserves = [NSMutableArray array];
        __weak __typeof(self)weakSelf = self;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = width / kPlayerAspectRatio;
        self.frame = CGRectMake(viewOrigin.x, viewOrigin.y, width, height);
        
        // 横竖屏 切换通知
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        

        // 投屏view
        _screenView = [[SJVideoPlayerScreenView alloc] init];
        [_screenView setRemoteButtonClickBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_GOREMOTE object:strongSelf];

        }];
        [self addSubview:_screenView];
        _screenView.hidden = YES;
        
        // 无网络提示view
        _withoutNetworkView = [[SJVideoPlayerWithoutNetworkView alloc] init];
        [_withoutNetworkView setRetryButtonClickBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf retryPlay];
        }];
        [self addSubview:_withoutNetworkView];
        _withoutNetworkView.hidden = YES;
        
        // 蜂窝网络提示view
        _withoutWifiView = [[SJVideoPlayerWithoutWifiView alloc] init];
        [_withoutWifiView setContinueButtonClickBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf continuePlayingWithoutWifi];
        }];
        [self addSubview:_withoutWifiView];
        //_withoutWifiView.hidden = YES;
        
        // title view
        _titleNode = [[SJVideoPlayerTitleNode alloc] init];
        _titleNode.delegate = self;
        _titleNode.playerView = self;
        [self addSubview:_titleNode.view];
        [RACObserves addObject:[RACObserve(_titleNode, showBarrage) subscribeNext:^(NSNumber *x) {
         
            if ([x boolValue] == YES) {
                _renderer.view.hidden = NO;
            }
            else{
                _renderer.view.hidden = YES;
            }
        }]];
        
        // 直播标志
        _liveLogo = [[ASImageNode alloc] init];
        _liveLogo.image = [UIImage imageNamed:@"live_logo"];
        [self addSubnode:_liveLogo];
        _liveLogo.hidden = YES;
        
        // bottom view
        _bottomNode = [[SJVideoPlayerBottomNode alloc] init];
        _bottomNode.delegate = self;
        [self addSubview:_bottomNode.view];
        
        [RACObserves addObject:[RACObserve(_bottomNode.slider, isFirstResponder) subscribeNext:^(NSNumber *x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.isSliding = [x boolValue];
        }]];
        

        // activity view
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        [self addSubview:_activity];
        _activity.hidden = YES;
 
        // 弹幕view
        _showDanmaku = _titleNode.showBarrage;
        [self initBarrageRenderer];
        
        // lock button
        _lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockButton setImage:[UIImage imageNamed:@"player_unlock_btn"] forState:UIControlStateNormal];
        [_lockButton addTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_lockButton];
        _lockButton.hidden = YES;
        
        
        // HUD
        HUD = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:HUD];
        
        // 快进/快退、亮度/音量 调节手势
        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
        _panGesture.delegate = self;
        [self addGestureRecognizer:_panGesture];
        
        self.oldBrightness = [UIScreen mainScreen].brightness;
        
        // 亮度view加到window最上层
        ZFBrightnessView *brightnessView = [ZFBrightnessView sharedBrightnessView];
        [[UIApplication sharedApplication].keyWindow insertSubview:self belowSubview:brightnessView];
        
        [self configureVolume];
        
        [self backButtonClicked:nil];
        
        [RACObserves addObject:[RACObserve(self, allControlsHidden) subscribeNext:^(id x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([x boolValue]) {
                [strongSelf.withoutWifiView removeFromSuperview];
                [strongSelf.withoutNetworkView removeFromSuperview];
            }
        }]];
        
        [self firstLaunchingVideoPlayer];
        
        [self getCurrentOrtainer];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _activity.center = self.center;
    
    float titleNodeHeight = kSJVideoPlayerTitleViewHeight;
    if (self.style == SJVideoPlayerViewStyleMini) {
        titleNodeHeight = kSJVideoPlayerTitleViewHeight;
        _liveLogo.frame = CGRectMake(self.frame.size.width-40,
                                     12,
                                     kLiveLogoWidth,
                                     kLiveLogoHeight);

    }
    else{
        titleNodeHeight = kSJVideoPlayerTitleViewHeight+20;
        _liveLogo.frame = CGRectMake(40,
                                     kSJVideoPlayerTitleViewHeight-10,
                                     kLiveLogoWidth,
                                     kLiveLogoHeight);
    }
    _titleNode.frame = CGRectMake(0,
                                  0,
                                  self.frame.size.width,
                                  titleNodeHeight);

    _bottomNode.frame = CGRectMake(0,
                                   self.frame.size.height - kSJVideoPlayerBottomViewHeight,
                                   self.frame.size.width,
                                   kSJVideoPlayerBottomViewHeight);
    
    _lockButton.frame = CGRectMake(kLeftMargin,
                                   (self.frame.size.height - kLockButtonWidth) / 2.0,
                                   kLockButtonWidth,
                                   kLockButtonWidth);
    
    
    // 投屏view
    _screenView.frame = self.bounds;
    
    // 蜂窝网络view
    _withoutWifiView.frame = self.bounds;
    
    // 无网络view
    _withoutNetworkView.frame = self.bounds;
    if (self.payfilmTipView.showType == ShowTypeFull) {
        self.payfilmTipView.frame = self.frame;
        
    }
    else{
        self.payfilmTipView.frame = CGRectMake(self.frame.size.width-300, self.frame.size.height-80, 300, 38);
    }
    _defaultImg.frame = self.bounds;
    for (CALayer *sublayer in self.layer.sublayers) {
        if ([sublayer isKindOfClass:[AVPlayerLayer class]]) {
            sublayer.frame = self.bounds;
            break;
        }
    }
    
}

#pragma mark - SJVideoPlayerTitleViewDelegate & SJVideoPlayerBottomViewDelegate
- (void)backButtonClicked
{
    if (_bottomNode.isFullScreen) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:NSStringFromSelector(@selector(orientation))];
    }
    else{
        if ([self.delegate respondsToSelector:@selector(playerViewDidClickBack:)]) {
            [self.delegate playerViewDidClickBack:self];
        }
    }
}

- (void)titleViewDidClickBack:(SJVideoPlayerTitleNode *)titleview
{
    [self backButtonClicked];
}

- (void)titleViewDidClickMore:(SJVideoPlayerTitleNode *)titlenode
{
    if (!_menu) {
        [self setupREMenu];
    }
    
    if (_menu.isOpen) {
        [_menu close];
    }
    else{
        if (_isCollected) {
            _collectItem.title = @"收藏";
            [_collectItem setTextColor:RGB(254, 203, 47, 1)];
            _collectItem.image = [UIImage imageNamed:@"player_stared_btn"];
        }
        else{
            _collectItem.title = @"收藏";
            [_collectItem setTextColor:[UIColor whiteColor]];
            _collectItem.image = [UIImage imageNamed:@"player_unstar_btn"];
        }
        
        if (self.status == SJVideoPlayerViewStatusScreening) {
            _screenItem.title = @"取消投屏";
            _screenItem.image = [UIImage imageNamed:@"player_screen_phone_btn"];
        }
        else{
            _screenItem.title = @"投屏";
            _screenItem.image = [UIImage imageNamed:@"player_screen_btn"];
        }
        
        [_menu showFromRect:CGRectMake(self.frame.size.width - kMenuWidth,
                                       _titleNode.frame.size.height + _titleNode.frame.origin.y,
                                       kMenuWidth,
                                       kMenuHeight * 4)
                     inView:self];
    }

}

- (void)titleViewDidClickSeries:(SJVideoPlayerTitleNode *)titlenode
{
//    if (_seriesStyle == SJVideoPlayerSeriesViewStyleCollectionView ) {
//        if (_seriesCount <= 0 ) {
//            return;
//        }
//    }
//    else{
        if ( _seriesList.count <= 0) {
            return;
        }
//    }
    
    if (_seriesView == nil) {
//        if (_seriesList.count > 0) {
        
        
            _seriesView = [[SJVideoPlayerSeriesView alloc] initWithSeriesList:_seriesList style:(NSInteger)_seriesStyle];
//        }
//        else{
//            _seriesView = [[SJVideoPlayerSeriesView alloc] initWithSeriesCount:_seriesCount];
//            _seriesView.descending = self.seriesDescending;
//        }
        
    }
    
    [_seriesView hide];
    
    if (_showControls) {
        [self backButtonClicked:nil];
    }
    _seriesView.frame = CGRectMake( self.frame.size.width - kSeriesItemViewWidth * kSeriesColumnCount,
                                    0,
                                    kSeriesItemViewWidth * kSeriesColumnCount,
                                    self.frame.size.height);
    
    _seriesView.currentVideoIndex = _currentVideoIndex;
    
    __weak __typeof(self)weakSelf = self;
    [_seriesView setDidSelectVideoAtIndex:^(NSInteger index) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([strongSelf.delegate respondsToSelector:@selector(playerView:didClickSeriesAtIndex:)]) {
            [strongSelf.delegate playerView:strongSelf didClickSeriesAtIndex:index];
        }
    }];
    [_seriesView showInView:self];
    
}

- (void)bottomViewDidClickPlay:(SJVideoPlayerBottomNode *)bottomnode
{
    self.status = SJVideoPlayerViewStatusPlaying;
    if (_titleNode.showBarrage) {
        [_renderer start];
    }
    if ([self.delegate respondsToSelector:@selector(playerViewDidClickPlay:)]) {
        [self.delegate playerViewDidClickPlay:self];
    }
}

- (void)bottomViewDidClickPause:(SJVideoPlayerBottomNode *)bottomnode
{
    self.status = SJVideoPlayerViewStatusPaused;
    if (_titleNode.showBarrage) {
        [_renderer pause];
    }
    
    if ([self.delegate respondsToSelector:@selector(playerViewDidClickPause:)]) {
        [self.delegate playerViewDidClickPause:self];
    }

}

- (void)bottomViewDidClickMiniScreen:(SJVideoPlayerBottomNode *)bottomnode
{
    if ([self.delegate respondsToSelector:@selector(playerViewWillChangeFrame)]) {
        [self.delegate playerViewWillChangeFrame];
    }
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = UIInterfaceOrientationPortrait;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    //[[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:NSStringFromSelector(@selector(orientation))];
    
}

- (void)bottomViewDidClickFullScreen:(SJVideoPlayerBottomNode *)bottomnode
{
    if ([self.delegate respondsToSelector:@selector(playerViewWillChangeFrame)]) {
        [self.delegate playerViewWillChangeFrame];
    }
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = UIInterfaceOrientationLandscapeRight;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:NSStringFromSelector(@selector(orientation))];
}

- (void)bottomView:(SJVideoPlayerBottomNode *)bottomnode didChangeSliderValue:(SJPlayerSlider *)slider
{
    [self startCounting];
    if ([self.delegate respondsToSelector:@selector(playerView:didSlideToSeconds:)]) {
        [self.delegate playerView:self didSlideToSeconds:slider.value];
    }
}

- (void)sliderDidBecomeFirstResponder:(SJVideoPlayerBottomNode *)bottomview
{
//    if (_timer) {
//        dispatch_source_cancel(_timer);
//    }
}

#pragma mark - 弹幕
- (void)sendBarrage:(TPDanmakuData *)data
{
    //&& self.status != SJVideoPlayerViewStatusPaused
    if (self.titleNode.showBarrage ) {
       
        
        UIColor *color = [UIColor whiteColor];
        if (data.isSender) {
            color = kColorBlueTheme;
        }
        NSString *msg;
        if (data.message.length == 0) {
            msg = [NSString stringWithFormat:@"%@:",data.senderName];
        }
        else{
            msg = [NSString stringWithFormat:@"%@: %@",data.senderName,data.message];
        }
        
        NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
        if (spriteNumber <= 50) {
            
            BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
            descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
            descriptor.params[@"text"] = msg;
            descriptor.params[@"textColor"] = color;
            
            CGFloat speed = (100 * (double)random()/RAND_MAX+50) - 0.5;
            if (speed <= 0.5f) {
                speed = 0.5;
            }
            descriptor.params[@"speed"] = @(speed);
            descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
            descriptor.params[@"clickAction"] = ^{
                
            };
            
            [_renderer receive:descriptor];
        }

    }
}

- (void)initBarrageRenderer
{
    _renderer = [[BarrageRenderer alloc] init];
    
    [self addSubview:_renderer.view];
    [self sendSubviewToBack:_renderer.view];
    _renderer.canvasMargin = UIEdgeInsetsMake(0, 0, 0, 0);
    _renderer.masked = NO;
    // 若想为弹幕增加点击功能, 请添加此句话, 并在Descriptor中注入行为
//    _renderer.view.userInteractionEnabled = YES;
//    [self sendSubviewToBack:_renderer.view];
    [_renderer start];
}

#pragma mark - Event
- (void)backButtonClicked:(id)sender
{
    if (_allControlsHidden) {
        return;
    }
    _showControls = !_showControls;
    
    if (!_bottomNode.isFullScreen) {
        // 小屏不显示锁屏按钮
        _lockButton.hidden = YES;
    }
    else{
        // 全屏显示锁屏按钮
        _lockButton.hidden = !_showControls;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

    }
    
    if (self.locked) {
        return;
    }
    
    //未锁屏时
    if (self.showWithoutWifiView || self.showWithoutNetworkView) {
        _bottomNode.hidden = YES;
    }
    else{
        _bottomNode.hidden = !_showControls;
    }
    
    _titleNode.hidden = !_showControls;
    
    [_menu close];
   
    if (_showControls) {
        [self startCounting];
    }
    else{

        if (_timer) {
            dispatch_source_cancel(_timer);
        }
    }
}

- (void)lockButtonClicked:(id)sender
{
    self.locked = !self.locked;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isLockDevice = self.locked;
    self.titleNode.hidden = self.locked;
    self.bottomNode.hidden =  self.locked;
    if (self.locked) {
        
        [_lockButton setImage:[UIImage imageNamed:@"player_lock_btn"] forState:UIControlStateNormal];
        
    }else{
        
        [_lockButton setImage:[UIImage imageNamed:@"player_unlock_btn"] forState:UIControlStateNormal];
        
    }
}

- (void)continuePlayingWithoutWifi
{
    self.showWithoutWifiView = NO;
    if ([self.delegate respondsToSelector:@selector(playerViewDidClickContinueWithoutWifi:)]) {
        [self.delegate playerViewDidClickContinueWithoutWifi:self];
    }
}

- (void)retryPlay
{
    self.showWithoutNetworkView = NO;
    if ([self.delegate respondsToSelector:@selector(playerViewDidClickRetry:)]) {
        [self.delegate playerViewDidClickRetry:self];
    }
}

- (void)settingButtonClicked:(REMenuItem *)sender
{
    if (_settingView == nil) {
        
        _settingView = [[SJVideoPlayerSettingView alloc] init];
        
    }
    
    [_settingView hide];
    
    if (_showControls) {
        [self backButtonClicked:nil];
    }
    _settingView.frame = CGRectMake( self.frame.size.width - 300,
                                    0,
                                    300,
                                    self.frame.size.height);
    
    __weak __typeof(self)weakSelf = self;
    // 视频尺寸 铺满
    [_settingView setVideoScaleFillBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        for (CALayer *sublayer in strongSelf.layer.sublayers) {
            if ([sublayer isKindOfClass:[AVPlayerLayer class]]) {
                [(AVPlayerLayer *)sublayer setVideoGravity:AVLayerVideoGravityResize];
                sublayer.transform = CATransform3DScale(strongSelf.oldTransform, 1.0, 1.0, 1.0);
                break;
            }
        }
    }];
    
    // 视频尺寸 100%
    [_settingView setVideoScaleAspectFillBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        for (CALayer *sublayer in strongSelf.layer.sublayers) {
            if ([sublayer isKindOfClass:[AVPlayerLayer class]]) {
                [(AVPlayerLayer *)sublayer setVideoGravity:AVLayerVideoGravityResizeAspect];
                sublayer.transform = CATransform3DScale(strongSelf.oldTransform, 1.0, 1.0, 1.0);
                break;
            }
        }
    }];
    
    // 视频尺寸 50%
    [_settingView setVideoScaleAspect50Block:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        for (CALayer *sublayer in strongSelf.layer.sublayers) {
            if ([sublayer isKindOfClass:[AVPlayerLayer class]]) {
                [(AVPlayerLayer *)sublayer setVideoGravity:AVLayerVideoGravityResizeAspect];
                sublayer.transform = CATransform3DScale(strongSelf.oldTransform, 0.5, 0.5, 0.5);
                break;
            }
        }
    }];
    
    // 亮度调节
    [_settingView setChangeBrightnessBlock:^(CGFloat value) {
        [UIScreen mainScreen].brightness = value;
    }];
    
    [_settingView showInView:self];
    
}

- (void)recoverFullScreen
{
    self.titleNode.isFullScreen = YES;
    self.bottomNode.isFullScreen = YES;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:NSStringFromSelector(@selector(orientation))];
    
}

- (void)recoverMiniScreen
{
    self.titleNode.isFullScreen = NO;
    self.bottomNode.isFullScreen = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:NSStringFromSelector(@selector(orientation))];
}

#pragma mark - (收费节目)立即购买
- (void)buyNow
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_BuyNow object:self];

}

#pragma mark - Notification
- (void)orientationChanged:(NSNotification *)notification
{
    // 收到 设备旋转 通知
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (screenSize.width > screenSize.height) {
        
        //横屏
        self.frame = CGRectMake(self.frame.origin.x, 0, screenSize.width, screenSize.height);
        _titleNode.isFullScreen = YES;
        _bottomNode.isFullScreen = YES;
        _lockButton.hidden = NO;
        self.style = SJVideoPlayerViewStyleFullScreen;
        //[self firstLaunchingVideoPlayer];
        [self setNeedsLayout];
        
    }
    else if(orientation == UIDeviceOrientationPortrait && screenSize.width < screenSize.height){
        // && screenSize.width < screenSize.height
        //竖屏
        CGFloat height = screenSize.width / kPlayerAspectRatio;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, screenSize.width, height);
        _titleNode.isFullScreen = NO;
        _bottomNode.isFullScreen = NO;
        _lockButton.hidden = YES;
        if (_settingView.isShowing) {
            [_settingView hide];
        }
        self.style = SJVideoPlayerViewStyleMini;
        [self setNeedsLayout];
        if (self.didFinishRecoverMiniScreen) {
            self.didFinishRecoverMiniScreen();
        }
    }
    
}

#pragma mark - touches
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGRect middleRect = CGRectMake(0,
                                   _titleNode.frame.size.height,
                                   self.frame.size.width,
                                   self.frame.size.height - _titleNode.frame.size.height - _bottomNode.frame.size.height);
    if (!_showControls) {
        middleRect = self.bounds;
    }
    if (CGRectContainsPoint(middleRect, point)) {
        if (_seriesView.isShowing) {
            [_seriesView hide];
        }
        
        if (_settingView.isShowing) {
            [_settingView hide];
        }
        [self backButtonClicked:nil];
    }

}

#pragma mark - UIPanGestureRecognizer手势方法
- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    if (_menu.isOpen||_settingView.isShowing) {
        return;
    }
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) {
                
                // 水平移动
                self.panDirection = PanDirectionHorizontalMoved;
                if (!self.bottomNode.isFullScreen) {
                   // break;
                }
                // 给sumTime初值
                self.sumTime      = [_bottomNode sliderValue];
                [self.player pause];
                
            }
            else if (x < y){
                // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else {
                    // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if (!self.bottomNode.isFullScreen) {
                       // break;
                    }
                    // 移动中一直显示快进label
                    //self.controlView.horizontalLabel.hidden = NO;
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if (!self.bottomNode.isFullScreen) {
                      //  break;
                    }
                    [HUD hide:YES];
        
                   // [self.player play];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 隐藏视图
                        //self.controlView.horizontalLabel.hidden = YES;
                    });
                    
                    DDLogInfo(@"快进/快退结束");
            
                    if ([self.delegate respondsToSelector:@selector(playerView:didSlideToSeconds:)]) {
            
                        [self.delegate playerView:self didSlideToSeconds:[_bottomNode sliderValue]];
                        _bottomNode.isEditing = NO;
                        [HUD hide:YES];
                    }
                    
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    
                    // 垂直移动结束后，把状态改为不再控制音量
                    [HUD hide:YES];
                    self.isVolume = NO;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //self.controlView.horizontalLabel.hidden = YES;
                    });
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

// pan垂直移动的方法
- (void)verticalMoved:(CGFloat)value
{
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
    if (self.isVolume) {
        self.volume = self.volumeViewSlider.value;
    }
}

//pan水平移动的方法
- (void)horizontalMoved:(CGFloat)value
{
    if (value == 0) {
        return;
    }
    
    // 快进快退的方法
    if (value < 0) {
        
        // 每次滑动需要叠加时间
        self.sumTime = [_bottomNode sliderValue] - 1;;
        
        //快退的方法
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_gesture_progress_minus"]];
        
    }
    else{
        // 每次滑动需要叠加时间
        self.sumTime = [_bottomNode sliderValue] + 1;
        
        // 快进的方法
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_gesture_progress_add"]];
        
    }
    
    if (self.sumTime > totalSeconds) { self.sumTime = totalSeconds;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    _bottomNode.isEditing = YES;
    [_bottomNode updatePlayedTime:self.sumTime ];
   
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = [NSString stringWithFormat:@"%@/%@",[_bottomNode playedTime],[_bottomNode totalTime]];
    [HUD show:YES];
    
}
- (void)resetPlayedTime{
   // [_bottomNode updatePlayedTime:[_bottomNode sliderValue]];
}
//  根据时长求出字符串
- (NSString *)durationStringWithTime:(int)time
{
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

// 获取系统音量
- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            self.oldVolume = _volumeViewSlider.value;
            self.volume = _volumeViewSlider.value;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:self];
        // （屏幕下方slider区域） || （在cell上播放视频 && 不是全屏状态） || (播放完了) =====>  不响应pan手势
        if ((point.y > self.bounds.size.height-40) || self.status == SJVideoPlayerViewStatusFinished || self.locked) { return NO; }
        return YES;
    }
    
    return YES;
}

#pragma mark - Subviews
//第一次全屏透明帮助页
- (BOOL)firstLaunchingVideoPlayer
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"video"]){
        _defaultImg = [[UIImageView alloc]init];
        [_defaultImg setImage:[UIImage imageNamed:@"img_play_guide"]];
        _defaultImg.userInteractionEnabled = YES;
        [self addSubview:_defaultImg];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGr.cancelsTouchesInView = NO;
        
        [_defaultImg addGestureRecognizer:tapGr];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"video"];
        return YES;
    }
    else{
        return NO;
    }
}

- (void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    if (_defaultImg) {
        [_defaultImg removeFromSuperview];
    }
}

- (void)showFullPayTipView:(NSString *)title
{
    self.payfilmTipView.frame = self.frame;
    self.payfilmTipView.showType = ShowTypeFull;
    // [self setNeedsLayout];
    [self addSubview:_titleNode.view];
    [self.payfilmTipView setTipMessage:title andBuyBtnTitle:@"立即购买"];

}

- (void)startCounting
{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    
    __block int count = 0;
    __weak __typeof(self)weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (count >= 5) {
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    count = 0;
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    [strongSelf backButtonClicked:nil];
                    if (self.payfilmTipView.showType == ShowTypeMax) {
                        self.payfilmTipView.showType = ShowTypeMin;
                    }

                });
                
            }
            else{
                [[UIApplication sharedApplication] setStatusBarHidden:NO];

                count++;
            }
            
        });
        
    });
    dispatch_resume(_timer);
    
}

- (void)updateCacheTime:(CGFloat)cacheTime
{
    if (_bottomNode.isEditing) {
        return;
    }
    [_bottomNode updateCacheTime:cacheTime];
}

- (void)updateTotalTime:(CGFloat)totalTime
{
    totalSeconds = totalTime;
    [_bottomNode updateTotalTime:totalTime];
}

- (void)updatePlayedTime:(CGFloat)playerTime
{
    if (_bottomNode.isEditing) {
        return;
    }
    [_bottomNode updatePlayedTime:playerTime];
}

- (void)setupREMenu
{
    REMenuItem *shareItem = [[REMenuItem alloc] initWithTitle:@"分享"
                                                        image:[UIImage imageNamed:@"player_share_btn"]
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           
                                                     
                                                           if ([self.delegate respondsToSelector:@selector(playerViewDidClickShare:)]) {
                                                               [self.delegate playerViewDidClickShare:self];
                                                               
                                                           }
                                                           
                                                       }];
    
    _screenItem = [[REMenuItem alloc] initWithTitle:@"投屏"
                                                         image:[UIImage imageNamed:@"player_screen_btn"]
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            //if (_bottomNode.isFullScreen) {
                                                                //[_bottomNode resizeNodeClicked:nil];
                                                            //}
                                                            if (self.status == SJVideoPlayerViewStatusScreening) {
                                                                // 取消投屏
                                                                if ([self.delegate respondsToSelector:@selector(playerViewDidCancelScreen:)]) {
                                                                    [self.delegate playerViewDidCancelScreen:self];
                                                                }
                                                            }
                                                            else{
                                                                // 投屏
                                                                if ([self.delegate respondsToSelector:@selector(playerViewDidClickScreen:)]) {
                                                                    [self.delegate playerViewDidClickScreen:self];
                                                                }
                                                            }
                                                            
                                                            
                                                        }];
    
    
    _collectItem = [[REMenuItem alloc] initWithTitle:@"收藏"
                                                       image:[UIImage imageNamed:@"player_unstar_btn"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          if ([self.delegate respondsToSelector:@selector(playerViewDidClickStar:)]) {
                                                              [self.delegate playerViewDidClickStar:self];
                                                          }
                                                      }];
    
    REMenuItem *_settingItem = [[REMenuItem alloc] initWithTitle:@"设置"
                                               image:[UIImage imageNamed:@"player_setting_btn"]
                                    highlightedImage:[UIImage imageNamed:@"player_setting_btn_highlighted"]
                                              action:^(REMenuItem *item) {
                                                  [self settingButtonClicked:item];
                                              }];
    
    
    _menu = [[REMenu alloc] initWithItems:@[shareItem,_screenItem,_collectItem,_settingItem]];
    
    
    _menu.imageOffset = CGSizeMake(0, -1);
    _menu.textOffset = CGSizeMake(15, 0);
    _menu.waitUntilAnimationIsComplete = NO;
    _menu.separatorColor = kColorGraySeparator;
    _menu.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _menu.borderColor = [UIColor clearColor];
    _menu.separatorHeight = 0.5;
    _menu.separatorOffset = CGSizeMake(5, 0);
    _menu.textColor = [UIColor whiteColor];
    _menu.font = [UIFont systemFontOfSize:16.0];
    _menu.cornerRadius = 1.0;
    [_menu setClosePreparationBlock:^{
        
    }];
    
    [_menu setCloseCompletionHandler:^{
        
    }];
    
    _menu.itemHeight = kMenuHeight;
    
}

- (void)setNoFree:(BOOL)noFree
{
    _noFree = noFree;
    if (_noFree) {
        self.payfilmTipView.hidden = NO;
    }
    else{
        self.payfilmTipView.hidden = YES;
        _payfilmTipView = nil;
    }
}

#pragma mark - Setter & Getter
- (void)getCurrentOrtainer
{
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (screenSize.width > screenSize.height) {
        
        //横屏
        self.frame = CGRectMake(self.frame.origin.x, 0, screenSize.width, screenSize.height);
        _titleNode.isFullScreen = YES;
        _bottomNode.isFullScreen = YES;
        _lockButton.hidden = NO;
        self.style = SJVideoPlayerViewStyleFullScreen;
        //[self firstLaunchingVideoPlayer];
        [self setNeedsLayout];
        
    }else{
        
        //竖屏
        CGFloat height = screenSize.width / kPlayerAspectRatio;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, screenSize.width, height);
        _titleNode.isFullScreen = NO;
        _bottomNode.isFullScreen = NO;
        _lockButton.hidden = YES;
        if (_settingView.isShowing) {
            [_settingView hide];
        }
        self.style = SJVideoPlayerViewStyleMini;
        [self setNeedsLayout];
        if (self.didFinishRecoverMiniScreen) {
            self.didFinishRecoverMiniScreen();
        }
        
    }
}

- (SJPayfilmTipView *)payfilmTipView
{
    if (!_payfilmTipView) {
        //SJPayfilmTipView  收费节目提示
        _payfilmTipView = [[SJPayfilmTipView alloc]init];
        WEAKSELF
        [_payfilmTipView setBuyButtonClickBlock:^{
            [weakSelf buyNow];
        }];
        [self addSubview:_payfilmTipView];
        _payfilmTipView.hidden = YES;
    }
    return _payfilmTipView;
}

- (void)setShowWithoutWifiView:(BOOL)showWithoutWifiView
{
    _showWithoutWifiView = showWithoutWifiView;
    if (self.allControlsHidden) {
        return;
    }
    if (showWithoutWifiView) {
        
        if (self.status != SJVideoPlayerViewStatusScreening) {
            _withoutWifiView.hidden = NO;
            _bottomNode.hidden = YES;
            [_activity stopAnimating];
            _activity.hidden = YES;
            
        }
        
    }
    else{
        _withoutWifiView.hidden = YES;
        _bottomNode.hidden = _titleNode.hidden;
    }
    [self setNeedsLayout];
}

- (void)setShowWithoutNetworkView:(BOOL)showWithoutNetworkView
{
    _showWithoutNetworkView = showWithoutNetworkView;
    
    if (self.allControlsHidden) {
        return;
    }
    if (showWithoutNetworkView) {
        
        if (self.status != SJVideoPlayerViewStatusScreening) {
            _withoutNetworkView.hidden = NO;
            _withoutWifiView.hidden = YES;
            _bottomNode.hidden = YES;
            [_activity stopAnimating];
            _activity.hidden = YES;
        }
        
    }
    else{
        _withoutNetworkView.hidden = YES;
        _bottomNode.hidden = _titleNode.hidden;
    }
}

- (void)setStatus:(SJVideoPlayerViewStatus)status
{
    _status = status;
    
    if (self.showWithoutWifiView || self.showWithoutNetworkView) {
       
        _activity.hidden = YES;
        [_activity stopAnimating];
        
        _withoutWifiView.hidden = !self.showWithoutWifiView;
        _withoutNetworkView.hidden = !self.showWithoutNetworkView;
        _bottomNode.hidden = YES;
        
    }
    _screenView.tvPlay = NO;

    switch (status) {
        case SJVideoPlayerViewStatusReadyToPlay:
        case SJVideoPlayerViewStatusPlaying:
        {
            if (_isScreening) {
                break;
            }
            
            _bottomNode.isPlaying = YES;
            _activity.hidden = YES;
            [_activity stopAnimating];
            _screenView.hidden = YES;
            _renderer.view.hidden = NO;
            [_renderer start];
        }
            break;
        case SJVideoPlayerViewStatusPaused:
        {
            if (_isScreening) {
                break;
            }
            _bottomNode.isPlaying = NO;
            _activity.hidden = YES;
            [_activity stopAnimating];
            _screenView.hidden = YES;
            _renderer.view.hidden = NO;
            [_renderer pause];
        }
            
            break;
        case SJVideoPlayerViewStatusFinished:
        {
            if (_isScreening) {
                break;
            }
            _bottomNode.isPlaying = NO;
            _activity.hidden = YES;
            [_activity stopAnimating];
            _screenView.hidden = YES;
            _renderer.view.hidden = NO;
            [_renderer stop];
        }
            break;
        case SJVideoPlayerViewStatusCaching:
        {
            if (_isScreening) {
                break;
            }
            _bottomNode.isPlaying = NO;
            
            _screenView.hidden = YES;
            _renderer.view.hidden = NO;
            _activity.hidden = NO;
            [_activity startAnimating];
            
        }
            break;
            
        case SJVideoPlayerViewStatusScreening:
        {
            _withoutWifiView.hidden = YES;
            _withoutNetworkView.hidden = YES;
            _screenView.hidden = NO;
            _renderer.view.hidden = YES;
            _activity.hidden = YES;
            [_activity stopAnimating];
            [_renderer pause];
        }
            break;
        case SJVideoPlayerViewStatusFailed:
        {
            _withoutWifiView.hidden = YES;
            _withoutNetworkView.hidden = YES;
            _bottomNode.isPlaying = NO;
            _activity.hidden = YES;
            [_activity stopAnimating];
            _screenView.hidden = YES;
            _renderer.view.hidden = NO;
            [_renderer stop];
        }
            break;
        case SJVideoPlayerViewStatusOnlyTvPlay:
        {
            _withoutWifiView.hidden = YES;
            _withoutNetworkView.hidden = YES;
            _bottomNode.isPlaying = NO;
            _activity.hidden = YES;
            [_activity stopAnimating];
            _screenView.hidden = NO;
            _screenView.tvPlay = YES;
            _renderer.view.hidden = NO;
            [_renderer stop];
        }
            break;
        default:
            break;
    }
}

- (void)setCurrentVideoIndex:(NSInteger)currentVideoIndex
{
    _currentVideoIndex = currentVideoIndex;
    
    if (_seriesView.currentVideoIndex != currentVideoIndex) {
        _seriesView.currentVideoIndex = currentVideoIndex;
    }
    
}

- (void)setAllControlsHidden:(BOOL)allControlsHidden
{
    _allControlsHidden = allControlsHidden;
    
    if (allControlsHidden) {
        _lockButton.hidden = YES;
        _titleNode.hidden = YES;
        _bottomNode.hidden = YES;
        
    }
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (BOOL)showBarrage
{
    return _titleNode.showBarrage;
}

- (AVPlayer *)player
{
    return self.playerLayer.player;
}

- (void)setPlayer:(AVPlayer *)player
{
    if (self.playerLayer == nil) {
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    }
    [self.playerLayer removeFromSuperlayer];
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    [self.playerLayer setBackgroundColor:[UIColor blackColor].CGColor];
    [self.playerLayer setPlayer:player];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResize];
    _oldTransform = self.playerLayer.transform;
    
}

- (void)handle_dealloc
{
    //[self removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    //[self removeObserver:self forKeyPath:NSStringFromSelector(@selector(showDanmuSwitch))];
    
    if (_timer) 
    dispatch_source_cancel(_timer);
    [_renderer stop];
    HUD = nil;
    [self removeFromSuperview];
    [_lockButton removeTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomNode.delegate = nil;
    [_bottomNode handle_dealloc];
    _titleNode.delegate = nil;
    [_titleNode handle_dealloc];
    _delegate = nil;
    
    
    [_seriesView handle_dealloc];
    _panGesture.delegate = nil;
    [_panGesture removeTarget:self action:@selector(panDirection:)];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (RACDisposable *handler in RACObserves) {
        [handler dispose];
    }
}

- (void)setShowDanmuSwitch:(BOOL)showDanmuSwitch
{
    _showDanmuSwitch = showDanmuSwitch;
    _liveLogo.hidden = !showDanmuSwitch;
}

#pragma mark - 试看时长  10s后变立即购买
- (void)setTrialDura:(CGFloat)trialDura
{
    _trialDura = trialDura;
    if (_trialDura != 0) {
        if (self.payfilmTipView.showType == ShowTypeFull) {
            [self.payfilmTipView setTipMessage:@"付费内容，观看完整版请开通会员" andBuyBtnTitle:@"立即购买"];
        }
        else{
            int trialMinte = trialDura/60;
            [self.payfilmTipView setTipMessage:[NSString stringWithFormat:@"付费内容，您可以试看前%d分钟",trialMinte] andBuyBtnTitle:@"立即购买"];
        }
    }
    [self trialDuraCounting];
}

- (void)trialDuraCounting
{
    if (!verTimer) {
        verTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(verUpdate) userInfo:nil repeats:NO];
    }
}

- (void)verUpdate
{
    if (self.payfilmTipView.showType == ShowTypeMax) {
        self.payfilmTipView.showType = ShowTypeMin;
    }
    [self closeTimer];
}

- (void)closeTimer
{
    [verTimer invalidate];
    verTimer = nil;
    
}

- (void)dealloc
{
    DDLogInfo(@"####### VideoPlayerView dealloc");
}

@end

