/*!
 @header WMPlayer.m
 
 @abstract  作者Github地址：https://github.com/zhengwenming
 作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/1/24
 
 @version 2.0.0 16/1/24 Creation(版本信息)
 
 Copyright © 2016年 郑文明. All rights reserved.
 */

#import "WMPlayer.h"
#import "ASButtonNode.h"

#define WMPlayerSrcName(file) [@"WMPlayer.bundle" stringByAppendingPathComponent:file]
#define WMPlayerFrameworkSrcName(file) [@"Frameworks/WMPlayer.framework/WMPlayer.bundle" stringByAppendingPathComponent:file]
#define kHalfWidth self.frame.size.width * 0.5
#define kHalfHeight self.frame.size.height * 0.5


static void *PlayViewCMTimeValue = &PlayViewCMTimeValue;

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface WMPlayer () <UIGestureRecognizerDelegate>
@property (nonatomic,assign)CGPoint firstPoint;
@property (nonatomic,assign)CGPoint secondPoint;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;
//监听播放起状态的监听者
@property (nonatomic ,strong) id playbackTimeObserver;

//视频进度条的单击事件
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign) CGPoint originalPoint;
@property (nonatomic, assign) BOOL isDragingSlider;//是否点击了按钮的响应事件
/**
 *  显示播放时间的UILabel
 */
@property (nonatomic,strong) UILabel        *leftTimeLabel;
@property (nonatomic,strong) UILabel        *rightTimeLabel;
/**
 * 亮度的进度条 
 */
@property (nonatomic,strong) UISlider       *lightSlider;
@property (nonatomic,strong) UISlider       *progressSlider;
@property (nonatomic,strong) UISlider       *volumeSlider;
@property (nonatomic,strong) UIProgressView *loadingProgress;

@property (nonatomic, strong) UIImageView *topBackImgView;
@property (nonatomic, strong) UIImageView *bottomBackImgView;


@end


@implementation WMPlayer{
    UISlider *systemSlider;
    UITapGestureRecognizer* singleTap; //!< 单机事件 显示或隐藏上下状态栏
}
/**
 *  alloc init的初始化方法
 */
- (instancetype)init{
    self = [super init];
    if (self){
        [self initWMPlayer];
    }
    return self;
}
/**
 *  storyboard、xib的初始化方法
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initWMPlayer];
}
/**
 *  initWithFrame的初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWMPlayer];
    }
    return self;
}
/**
 *  初始化WMPlayer的控件，添加手势，添加通知，添加kvo等
 */
-(void)initWMPlayer{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 具体的哪个位置播放
    self.seekTime = 0.00;
    self.backgroundColor = [UIColor blackColor];
    //小菊花
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    UIActivityIndicatorViewStyleWhiteLarge 的尺寸是（37，37）
//    UIActivityIndicatorViewStyleWhite 的尺寸是（22，22）
    [self addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.loadingView startAnimating];

    
    //topView
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:self.topView];
    
    _topBackImgView = [[UIImageView alloc] init];
    _topBackImgView.backgroundColor = [UIColor blackColor];
    [self.topView addSubview:_topBackImgView];
    
    
    // 返回按钮
    _backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backbtn.backgroundColor = [UIColor clearColor];
    [_backbtn setImage:[UIImage imageNamed:@"white_back_img"] forState:UIControlStateNormal];
    [_backbtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _backbtn.hidden = YES;
    [self.topView addSubview:_backbtn];
    
    [_backbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).with.offset(0);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.topView).with.offset(0);
        make.width.mas_equalTo(40);
        
    }];
    
    //autoLayout topView
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(50);
        make.top.equalTo(self).with.offset(0);
    }];
    
    
    //bottomView
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:self.bottomView];
    
    _bottomBackImgView = [[UIImageView alloc] init];
    _bottomBackImgView.backgroundColor = [UIColor blackColor];
    [self.bottomView addSubview:_bottomBackImgView];

    //autoLayout bottomView
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self).with.offset(0);
        
    }];
    [self setAutoresizesSubviews:NO];
    
    //_playOrPauseBtn
    self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseBtn.showsTouchWhenHighlighted = YES;
    [self.playOrPauseBtn addTarget:self action:@selector(PlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn setImage:[UIImage imageNamed:WMPlayerSrcName(@"pause")] ?: [UIImage imageNamed:WMPlayerFrameworkSrcName(@"pause")] forState:UIControlStateNormal];
    [self.playOrPauseBtn setImage:[UIImage imageNamed:WMPlayerSrcName(@"play")] ?: [UIImage imageNamed:WMPlayerFrameworkSrcName(@"play")] forState:UIControlStateSelected];
    [self.bottomView addSubview:self.playOrPauseBtn];
    //autoLayout _playOrPauseBtn
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(5);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self.bottomView).with.offset(-5);
        make.width.mas_equalTo(30);
        
    }];
    
    //创建亮度的进度条
    self.lightSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.lightSlider.hidden = YES;
    self.lightSlider.minimumValue = 0;
    self.lightSlider.maximumValue = 1;
    //        进度条的值等于当前系统亮度的值,范围都是0~1
    self.lightSlider.value = [UIScreen mainScreen].brightness;
    //        [self.lightSlider addTarget:self action:@selector(updateLightValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.lightSlider];
    
    
    
    /*MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    [self addSubview:volumeView];
    volumeView.frame = CGRectMake(-1000, -100, 100, 100);
    [volumeView sizeToFit];
    
    
    systemSlider = [[UISlider alloc]init];
    systemSlider.backgroundColor = [UIColor clearColor];
    for (UIControl *view in volumeView.subviews) {
        if ([view.superclass isSubclassOfClass:[UISlider class]]) {
            systemSlider = (UISlider *)view;
        }
    }
    systemSlider.autoresizesSubviews = NO;
    systemSlider.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:systemSlider];
    //        systemSlider.hidden = YES;
    
    
    
    self.volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.volumeSlider.tag = 1000;
    self.volumeSlider.hidden = YES;
    self.volumeSlider.minimumValue = systemSlider.minimumValue;
    self.volumeSlider.maximumValue = systemSlider.maximumValue;
    self.volumeSlider.value = systemSlider.value;
    [self.volumeSlider addTarget:self action:@selector(updateSystemVolumeValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.volumeSlider];
    */
    
    //slider
    self.progressSlider = [[UISlider alloc]init];
    self.progressSlider.minimumValue = 0.0;
    [self.progressSlider setThumbImage:[UIImage imageNamed:WMPlayerSrcName(@"dot")] ?: [UIImage imageNamed:WMPlayerFrameworkSrcName(@"dot")]  forState:UIControlStateNormal];
    self.progressSlider.minimumTrackTintColor = kColorBlueTheme;
    self.progressSlider.maximumTrackTintColor = [UIColor whiteColor];

    
    self.progressSlider.value = 0.0;//指定初始值
    //进度条的拖拽事件
    [self.progressSlider addTarget:self action:@selector(stratDragSlide:)  forControlEvents:UIControlEventValueChanged];
    //进度条的点击事件
    [self.progressSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventTouchUpInside];
    
    //给进度条添加单击手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    self.tap.delegate = self;
    [self.progressSlider addGestureRecognizer:self.tap];
    [self.bottomView addSubview:self.progressSlider];
    self.progressSlider.backgroundColor = [UIColor clearColor];
    
    //autoLayout slider
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(45);
        make.right.equalTo(self.bottomView).with.offset(-45);
        //make.center.equalTo(self.bottomView);
        make.centerX.mas_equalTo(self.bottomView);
        make.centerY.mas_equalTo(self.bottomView.frame.size.height/2-5);

    }];
    
    
    self.loadingProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.loadingProgress.progressTintColor = [UIColor whiteColor];
    self.loadingProgress.trackTintColor    = [UIColor lightGrayColor];
    [self.bottomView addSubview:self.loadingProgress];
    [self.loadingProgress setProgress:0.0 animated:NO];

    [self.loadingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressSlider);
        make.right.equalTo(self.progressSlider);
        make.center.equalTo(self.progressSlider).with.offset(0.7);
    }];
    
    [self.bottomView sendSubviewToBack:self.loadingProgress];
    
    
    //_fullScreenBtn
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullScreenBtn.showsTouchWhenHighlighted = YES;
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn setImage:[UIImage imageNamed:WMPlayerSrcName(@"fullscreen")] ?: [UIImage imageNamed:WMPlayerFrameworkSrcName(@"fullscreen")] forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:[UIImage imageNamed:WMPlayerSrcName(@"nonfullscreen")] ?: [UIImage imageNamed:WMPlayerFrameworkSrcName(@"nonfullscreen")] forState:UIControlStateSelected];
    [self.bottomView addSubview:self.fullScreenBtn];
    //autoLayout fullScreenBtn
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(0);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.bottomView).with.offset(0);
        make.width.mas_equalTo(40);
        
    }];
    
    
    
    
    
    //leftTimeLabel
    self.leftTimeLabel = [[UILabel alloc]init];
    self.leftTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.leftTimeLabel.textColor = [UIColor whiteColor];
    self.leftTimeLabel.backgroundColor = [UIColor clearColor];
    self.leftTimeLabel.font = [UIFont systemFontOfSize:11];
    [self.bottomView addSubview:self.leftTimeLabel];
    //autoLayout timeLabel
    [self.leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(45);
        make.right.equalTo(self.bottomView).with.offset(-45);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.bottomView).with.offset(0);
    }];
    
    
    
    //rightTimeLabel
    self.rightTimeLabel = [[UILabel alloc]init];
    self.rightTimeLabel.textAlignment = NSTextAlignmentRight;
    self.rightTimeLabel.textColor = [UIColor whiteColor];
    self.rightTimeLabel.backgroundColor = [UIColor clearColor];
    self.rightTimeLabel.font = [UIFont systemFontOfSize:11];
    [self.bottomView addSubview:self.rightTimeLabel];
    //autoLayout timeLabel
    [self.rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(45);
        make.right.equalTo(self.bottomView).with.offset(-45);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.bottomView).with.offset(0);
    }];
    
    
    //_closeBtn
   /* _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.showsTouchWhenHighlighted = YES;
    [_closeBtn addTarget:self action:@selector(colseTheVideo:) forControlEvents:UIControlEventTouchUpInside];
       [self.topView addSubview:_closeBtn];
    //autoLayout _closeBtn
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).with.offset(5);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.topView).with.offset(5);
        make.width.mas_equalTo(30);
        
    }];*/
    
    //titleLabel
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.titleLabel.numberOfLines = 0;
    [self.topView addSubview:self.titleLabel];
    //autoLayout titleLabel
    
    /*[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).with.offset(15);
        make.right.equalTo(self.topView).with.offset(-15);
        make.center.equalTo(self.topView);
        make.top.equalTo(self.topView).with.offset(0);

    }];*/
    
    [self bringSubviewToFront:self.loadingView];
    [self bringSubviewToFront:self.bottomView];
    
    
    // 单击的 Recognizer
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1; // 单击
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appwillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];    
}
#pragma mark
#pragma mark lazy 加载失败的label
-(UILabel *)loadFailedLabel{
    if (_loadFailedLabel==nil) {
        _loadFailedLabel = [[UILabel alloc]init];
        _loadFailedLabel.textColor = [UIColor whiteColor];
        _loadFailedLabel.textAlignment = NSTextAlignmentCenter;
        _loadFailedLabel.text = @"视频加载失败";
        _loadFailedLabel.hidden = YES;
        [self addSubview:_loadFailedLabel];

        [_loadFailedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(@30);

        }];
    }
    return _loadFailedLabel;
}
#pragma mark
#pragma mark 进入后台
- (void)appDidEnterBackground:(NSNotification*)note
{
    if (self.playOrPauseBtn.isSelected==NO) {//如果是播放中，则继续播放
        NSArray *tracks = [self.currentItem tracks];
        for (AVPlayerItemTrack *playerItemTrack in tracks) {
            if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
                playerItemTrack.enabled = YES;
            }
        }
        self.playerLayer.player = nil;
        [self.player play];
        self.state = WMPlayerStatePlaying;
    }else{
        self.state = WMPlayerStateStopped;
    }
}
#pragma mark 
#pragma mark 进入前台
- (void)appWillEnterForeground:(NSNotification*)note
{
    if (self.playOrPauseBtn.isSelected==NO) {//如果是播放中，则继续播放
        NSArray *tracks = [self.currentItem tracks];
        for (AVPlayerItemTrack *playerItemTrack in tracks) {
            if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
                playerItemTrack.enabled = YES;
            }
        }
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResize;
        [self.layer insertSublayer:_playerLayer atIndex:0];
        [self.player play];
        self.state = WMPlayerStatePlaying;

    }else{
        self.state = WMPlayerStateStopped;
    }
}
#pragma mark
#pragma mark appwillResignActive
- (void)appwillResignActive:(NSNotification *)note
{
    DDLogInfo(@"appwillResignActive");
}
- (void)appBecomeActive:(NSNotification *)note
{
    DDLogInfo(@"appBecomeActive");
}
//视频进度条的点击事件
- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint touchLocation = [sender locationInView:self.progressSlider];
    CGFloat value = (self.progressSlider.maximumValue - self.progressSlider.minimumValue) * (touchLocation.x/self.progressSlider.frame.size.width);
    [self.progressSlider setValue:value animated:YES];

    [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value, self.currentItem.currentTime.timescale)];
    if (self.player.rate != 1.f) {
        if ([self currentTime] == [self duration])
            [self setCurrentTime:0.f];
        self.playOrPauseBtn.selected = NO;
        [self.player play];
    }
}

- (void)updateSystemVolumeValue:(UISlider *)slider{
    systemSlider.value = slider.value;
}
#pragma mark
#pragma mark - layoutSubviews
-(void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    
    _topBackImgView.frame = self.topView.bounds;
    _bottomBackImgView.frame = self.bottomView.bounds;

    [self addTopGradientInBackgroundView];
    [self addBottomGradientInBackgroundView];
    
    CGSize maximumSize = CGSizeMake(self.topView.bounds.size.width-30, 9999);
    NSString *dateString = _titleLabel.text;
    UIFont *dateFont = [UIFont boldSystemFontOfSize:18];
    CGSize dateStringSize = [dateString sizeWithFont:dateFont
                                   constrainedToSize:maximumSize
                                       lineBreakMode:_titleLabel.lineBreakMode];
    float h = dateStringSize.height;
    if (h>self.topView.frame.size.height) {
        h = self.topView.frame.size.height;
    }
    CGRect dateFrame = CGRectMake(15, 10, self.topView.bounds.size.width-30, h);
    _titleLabel.frame = dateFrame;
}
#pragma mark
#pragma mark - 全屏按钮点击func
-(void)backClick{
    [self fullScreenAction:nil];
}
// 点击全屏按钮回调
-(void)fullScreenAction:(UIButton *)sender{
    sender.selected = !sender.selected;
   // self.topView.hidden = !sender.selected;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:clickedFullScreenButton:)]) {
        [self.delegate wmplayer:self clickedFullScreenButton:sender];
    }
}
#pragma mark
#pragma mark - 关闭按钮点击func
// 点击关闭按钮进行关闭回调
-(void)colseTheVideo:(UIButton *)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:clickedCloseButton:)]) {
        [self.delegate wmplayer:self clickedCloseButton:sender];
    }
}
///获取视频长度
- (double)duration{
    AVPlayerItem *playerItem = self.player.currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return CMTimeGetSeconds([[playerItem asset] duration]);
    }
    else{
        return 0.f;
    }
}
///获取视频当前播放的时间
- (double)currentTime{
    if (self.player) {
        return CMTimeGetSeconds([self.player currentTime]);
    }else{
        return 0.0;
    }
}

- (void)setCurrentTime:(double)time{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player seekToTime:CMTimeMakeWithSeconds(time, self.currentItem.currentTime.timescale)];

    });
}
#pragma mark
#pragma mark - PlayOrPause
- (void)PlayOrPause:(UIButton *)sender{
    
    // 播放器的rate  0 代表暂停   1 代表 播放
    if (self.player.rate != 1.f) {
        if ([self currentTime] == [self duration])
            [self setCurrentTime:0.f];
        sender.selected = NO;
        DDLogInfo(@"内部开始播放");
        [self.player play];
    } else {
        sender.selected = YES;
        DDLogInfo(@"内部暂停播放");
        [self.player pause];
        //[[NSNotificationCenter defaultCenter] postNotificationName:kNotification_WMPLAYERPAUSE object:nil];

    }
    if ([self.delegate respondsToSelector:@selector(wmplayer:clickedPlayOrPauseButton:)]) {
        [self.delegate wmplayer:self clickedPlayOrPauseButton:sender];
    }
}
///播放
-(void)play{
    [self.loadingView startAnimating];
    [self PlayOrPause:self.playOrPauseBtn];
}
///暂停
-(void)pause{
    [self PlayOrPause:self.playOrPauseBtn];
}
#pragma mark
#pragma mark - 单击手势方法
- (void)handleSingleTap:(UITapGestureRecognizer *)sender{
    // 取消之前未发生的事件
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoDismissBottomView:) object:nil];
    // 返回代理
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:singleTaped:)]) {
        [self.delegate wmplayer:self singleTaped:sender];
    }
    // 删除时间对象
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
    // 创建时间对象 不是用sche开头创建的，那么需要自己加到runloop中
    self.autoDismissTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoDismissBottomView:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
    
    // 让上面和下面的View隐藏或者显示
    [UIView animateWithDuration:0.5 animations:^{
        if (self.bottomView.alpha == 0.0) {
            self.bottomView.alpha = 1.0;
            self.closeBtn.alpha = 1.0;
            self.topView.alpha = 1.0;

        }else{
            self.bottomView.alpha = 0.0;
            self.closeBtn.alpha = 0.0;
            self.topView.alpha = 0.0;

        }
    } completion:^(BOOL finish){
        
    }];
}
#pragma mark
#pragma mark - 双击手势方法
- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayer:doubleTaped:)]) {
        [self.delegate wmplayer:self doubleTaped:doubleTap];
    }
    // 0 stop  1 play
    // stop的时候
    if (self.player.rate != 1.f) {
        // 这句话代表开始或者结束
        if ([self currentTime] == self.duration)
            [self setCurrentTime:0.f];
        [self.player play];
        self.playOrPauseBtn.selected = NO;
    } else {
        [self.player pause];
        self.playOrPauseBtn.selected = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.alpha = 1.0;
        self.topView.alpha = 1.0;
        self.closeBtn.alpha = 1.0;

    } completion:^(BOOL finish){
        
    }];
}

// 设置播放器item
-(void)setCurrentItem:(AVPlayerItem *)currentItem{
    if (_currentItem==currentItem) {
        return;
    }
    if (_currentItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [_currentItem removeObserver:self forKeyPath:@"status"];
        [_currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        _currentItem = nil;
    }
    _currentItem = currentItem;
    if (_currentItem) {
        [_currentItem addObserver:self
                           forKeyPath:@"status"
                              options:NSKeyValueObservingOptionNew
                              context:PlayViewStatusObservationContext];
        
        [_currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        // 缓冲区空了，需要等待数据
        [_currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        // 缓冲区有足够数据可以播放了
        [_currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        
        
        [self.player replaceCurrentItemWithPlayerItem:_currentItem];
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
    }
}
/**
 *  重写URLString的setter方法，处理自己的逻辑，外部进来的接口，直接在这里设置Player
 */
- (void)setURLString:(NSString *)URLString{
    _URLString = URLString;
    //设置player的参数
    self.currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:URLString]];

    self.player = [AVPlayer playerWithPlayerItem:_currentItem];
//    self.player.usesExternalPlaybackWhileExternalScreenIsActive=YES;
    //AVPlayerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.layer.bounds;
    //WMPlayer视频的默认填充模式，AVLayerVideoGravityResizeAspect // 全屏幕放大，但是比例失调了
    // AVLayerVideoGravityResizeAspectFill 等比例拉伸，会部分裁减掉
    // AVLayerVideoGravityResizeAspect 拉伸一边，会有留白
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.layer insertSublayer:_playerLayer atIndex:0];
    self.state = WMPlayerStateBuffering;
    if (self.closeBtnStyle==CloseBtnStylePop) {
        [_closeBtn setImage:[UIImage imageNamed:WMPlayerSrcName(@"play_back.png")] ?: [UIImage imageNamed:WMPlayerFrameworkSrcName(@"play_back.png")] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:WMPlayerSrcName(@"play_back.png")] ?: [UIImage imageNamed:WMPlayerFrameworkSrcName(@"play_back.png")] forState:UIControlStateSelected];
        
    }else{
        [_closeBtn setImage:[UIImage imageNamed:WMPlayerSrcName(@"close")] ?: [UIImage imageNamed:WMPlayerFrameworkSrcName(@"close")] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:WMPlayerSrcName(@"close")] ?: [UIImage imageNamed:WMPlayerFrameworkSrcName(@"close")] forState:UIControlStateSelected];
    }
}


/**
 *  设置播放的状态
 *  @param state WMPlayerState
 */
- (void)setState:(WMPlayerState)state
{
    _state = state;
    // 控制菊花显示、隐藏
    if (state == WMPlayerStateBuffering) {
        [self.loadingView startAnimating];
    }else if(state == WMPlayerStatePlaying){
        [self.loadingView stopAnimating];//
    }else if(state == WMPlayerStatusReadyToPlay){
        [self.loadingView stopAnimating];//
    }
    else{
        [self.loadingView stopAnimating];//
    }
}

/**
 *  通过颜色来生成一个纯色图片
 */
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}
// 播放完回调
- (void)moviePlayDidEnd:(NSNotification *)notification {
    self.state            = WMPlayerStateFinished;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayerFinishedPlay:)]) {
        [self.delegate wmplayerFinishedPlay:self];
    }

   
    
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [self.progressSlider setValue:0.0 animated:YES];
        self.playOrPauseBtn.selected = YES;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.alpha = 1.0;
        self.topView.alpha = 1.0;
    } completion:^(BOOL finish){
        
    }];
}

#pragma mark
#pragma mark--开始点击sidle
// 拖动进度条
- (void)stratDragSlide:(UISlider *)slider{
    self.isDragingSlider = YES;
}
#pragma mark
#pragma mark - 播放进度
// 更新播放进度
- (void)updateProgress:(UISlider *)slider{
    self.isDragingSlider = NO;
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, _currentItem.currentTime.timescale)];
    
}
#pragma mark
#pragma mark KVO
// 观察所有监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    /* AVPlayerItem "status" property value observer. */

    if (context == PlayViewStatusObservationContext)
    {
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status)
            {
                    /* Indicates that the status of the player is not yet known because
                     it has not tried to load new media resources for playback */
                case AVPlayerStatusUnknown:
                {
                    [self.loadingProgress setProgress:0.0 animated:NO];
                    self.state = WMPlayerStateBuffering;
                    [self.loadingView startAnimating];
                }
                    break;
                    
                case AVPlayerStatusReadyToPlay:
                {
                    self.state = WMPlayerStatusReadyToPlay;
                    
                    // 双击的 Recognizer
                    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
                    doubleTap.numberOfTapsRequired = 2; // 双击
                    [singleTap requireGestureRecognizerToFail:doubleTap];//如果双击成立，则取消单击手势（双击的时候不回走单击事件）
                    [self addGestureRecognizer:doubleTap];
                    /* Once the AVPlayerItem becomes ready to play, i.e.
                     [playerItem status] == AVPlayerItemStatusReadyToPlay,
                     its duration can be fetched from the item. */
                    if (CMTimeGetSeconds(_currentItem.duration)) {
                        
                        double _x = CMTimeGetSeconds(_currentItem.duration);
                        if (!isnan(_x)) {
                            self.progressSlider.maximumValue = CMTimeGetSeconds(self.player.currentItem.duration);
                        }
                    }
                    //监听播放状态
                    [self initTimer];
                    
                    
                    //5s dismiss bottomView
                    if (self.autoDismissTimer ==nil) {
                        self.autoDismissTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoDismissBottomView:) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
                    }
                    
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayerReadyToPlay:WMPlayerStatus:)]) {
                        [self.delegate wmplayerReadyToPlay:self WMPlayerStatus:WMPlayerStatusReadyToPlay];
                    }
                    [self.loadingView stopAnimating];
                    // 跳到xx秒播放视频
                    if (self.seekTime) {
                        [self seekToTimeToPlay:self.seekTime];
                    }
                    
                }
                    break;
                    
                case AVPlayerStatusFailed:
                {
                    self.state = WMPlayerStateFailed;
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(wmplayerFailedPlay:WMPlayerStatus:)]) {
                        [self.delegate wmplayerFailedPlay:self WMPlayerStatus:WMPlayerStateFailed];
                    }
                    NSError *error = [self.player.currentItem error];
                    if (error) {
                        self.loadFailedLabel.hidden = NO;
                        [self bringSubviewToFront:self.loadFailedLabel];
                        [self.loadingView stopAnimating];
                    }
                    DDLogError(@"视频加载失败===%@",error.description);
                }
                    break;
            }

        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            // 总进度
            CMTime duration             = self.currentItem.duration;
            // 总进度时间
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            //缓冲颜色
            self.loadingProgress.progressTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
            // 设置缓冲的进度
            [self.loadingProgress setProgress:timeInterval / totalDuration animated:NO];
            
             [self.loadingView stopAnimating];

            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            // 缓冲为空的时候
            [self.loadingView startAnimating];
            // 当缓冲是空的时候 5秒之后进行播放
            if (self.currentItem.playbackBufferEmpty) {
                self.state = WMPlayerStateBuffering;
                //delete by jhl  20170226
              //  [self loadedTimeRanges];
                //end
            }
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            [self.loadingView stopAnimating];
            // 当缓冲好的时候
            if (self.currentItem.playbackLikelyToKeepUp && self.state == WMPlayerStateBuffering){
                self.state = WMPlayerStatePlaying;
            }
            
        }
    }

}
    

/**
 *  缓冲回调
 */
- (void)loadedTimeRanges
{
    self.state = WMPlayerStateBuffering;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self play];
        [self.loadingView stopAnimating];
    });
}

#pragma mark
#pragma mark autoDismissBottomView
-(void)autoDismissBottomView:(NSTimer *)timer{
    
    
    // 0 stop  1 play
    if (self.player.rate==.0f&&self.currentTime != self.duration) {//暂停状态
   
    }else if(self.player.rate==1.0f){
        if (self.bottomView.alpha==1.0) {
            [UIView animateWithDuration:0.5 animations:^{
                self.bottomView.alpha = 0.0;
                self.closeBtn.alpha = 0.0;
                self.topView.alpha = 0.0;

            } completion:^(BOOL finish){
                
            }];
        }
    }
}
#pragma  mark - 定时器
// 根据duration启动定时器观察
-(void)initTimer{
    double interval = .1f;
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([self.progressSlider bounds]);
        interval = 0.5f * duration / width;
    }
    __weak typeof(self) weakSelf = self;
    
    // 每秒钟调用这个方法刷新UISlider
    self.playbackTimeObserver =  [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)  queue:dispatch_get_main_queue() /* If you pass NULL, the main queue is used. */
        usingBlock:^(CMTime time){
        [weakSelf syncScrubber];
    }];
}

// 主线程更新进度条
- (void)syncScrubber{
    CMTime playerDuration = [self playerItemDuration];
    // CMTime是否可用的宏
    if (CMTIME_IS_INVALID(playerDuration)){
        self.progressSlider.minimumValue = 0.0;
        return;
    }
    // 获取事件
    double duration = CMTimeGetSeconds(playerDuration);
    // 有限的事件
    if (isfinite(duration)){
        // 最小值 固定
        float minValue = [self.progressSlider minimumValue];
        // 最大值 固定
        float maxValue = [self.progressSlider maximumValue];
        // 当前时间
        double nowTime = CMTimeGetSeconds([self.player currentTime]);
        
        // 剩下的时间
        double remainTime = duration-nowTime;
        // 转换时间
        self.leftTimeLabel.text = [self convertSecondsToFormatString:nowTime];
        self.rightTimeLabel.text = [self convertSecondsToFormatString:remainTime];
        if (self.isDragingSlider==YES) {//拖拽slider中，不更新slider的值
            
        }else if(self.isDragingSlider==NO){
            
            // 这你妹的直接定位到nowTime不行么
            [self.progressSlider setValue:(maxValue - minValue) * nowTime / duration + minValue];
        }
    }
}
/**
 *  跳到time处播放
 *  @param seekTime这个时刻，这个时间点
 */
- (void)seekToTimeToPlay:(double)time{
    if (self.player&&self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        if (time>[self duration]) {
            time = [self duration];
        }
        if (time<=0) {
            time=0.0;
        }
//        int32_t timeScale = self.player.currentItem.asset.duration.timescale;
        //currentItem.asset.duration.timescale计算的时候严重堵塞主线程，慎用
        /* A timescale of 1 means you can only specify whole seconds to seek to. The timescale is the number of parts per second. Use 600 for video, as Apple recommends, since it is a product of the common video frame rates like 50, 60, 25 and 24 frames per second*/

        [self.player seekToTime:CMTimeMakeWithSeconds(time, _currentItem.currentTime.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            
        }];
        
        
    }
}

// 这里获取到的值是最大区域值，是固定的
- (CMTime)playerItemDuration{
    AVPlayerItem *playerItem = _currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}

// 把时间转换成NSData然后转换成NSString
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *newTime = [[self dateFormatter] stringFromDate:d];
    return newTime;
}
/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [_currentItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

// 懒加载formmater对象
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in event.allTouches) {
        self.firstPoint = [touch locationInView:self];
    }
    self.volumeSlider.value = systemSlider.value;
    //记录下第一个点的位置,用于moved方法判断用户是调节音量还是调节视频
    self.originalPoint = self.firstPoint;
    
    
    //    UISlider *volumeSlider = (UISlider *)[self viewWithTag:1000];
    //    volumeSlider.value = systemSlider.value;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in event.allTouches) {
        self.secondPoint = [touch locationInView:self];
    }
    
    //判断是左右滑动还是上下滑动
    CGFloat verValue =fabs(self.originalPoint.y - self.secondPoint.y);
    CGFloat horValue = fabs(self.originalPoint.x - self.secondPoint.x);
    //如果竖直方向的偏移量大于水平方向的偏移量,那么是调节音量或者亮度
    if (verValue > horValue) {//上下滑动
        //判断是全屏模式还是正常模式
        if (self.isFullscreen) {//全屏下
            //判断刚开始的点是左边还是右边,左边控制音量
            if (self.originalPoint.x <= kHalfHeight) {//全屏下:point在view的左边(控制音量)
                
                /* 手指上下移动的计算方式,根据y值,刚开始进度条在0位置,当手指向上移动600个点后,当手指向上移动N个点的距离后,
                 当前的进度条的值就是N/600,600随开发者任意调整,数值越大,那么进度条到大1这个峰值需要移动的距离也变大,反之越小 */
                systemSlider.value += (self.firstPoint.y - self.secondPoint.y)/600.0;
                self.volumeSlider.value = systemSlider.value;
            }else{//全屏下:point在view的右边(控制亮度)
                //右边调节屏幕亮度
                self.lightSlider.value += (self.firstPoint.y - self.secondPoint.y)/600.0;
                [[UIScreen mainScreen] setBrightness:self.lightSlider.value];
                
            }
        }else{//非全屏
            
            //判断刚开始的点是左边还是右边,左边控制音量
            if (self.originalPoint.x <= kHalfWidth) {//非全屏下:point在view的左边(控制音量)
                
                /* 手指上下移动的计算方式,根据y值,刚开始进度条在0位置,当手指向上移动600个点后,当手指向上移动N个点的距离后,
                 当前的进度条的值就是N/600,600随开发者任意调整,数值越大,那么进度条到大1这个峰值需要移动的距离也变大,反之越小 */
                systemSlider.value += (self.firstPoint.y - self.secondPoint.y)/600.0;
                self.volumeSlider.value = systemSlider.value;
            }else{//非全屏下:point在view的右边(控制亮度)
                //右边调节屏幕亮度
                self.lightSlider.value += (self.firstPoint.y - self.secondPoint.y)/600.0;
                [[UIScreen mainScreen] setBrightness:self.lightSlider.value];
                
            }
        }
    }else{//左右滑动,调节视频的播放进度
        //视频进度不需要除以600是因为self.progressSlider没设置最大值,它的最大值随着视频大小而变化
        //要注意的是,视频的一秒时长相当于progressSlider.value的1,视频有多少秒,progressSlider的最大值就是多少
        self.progressSlider.value -= (self.firstPoint.x - self.secondPoint.x)/10.0;
        [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value, self.currentItem.currentTime.timescale)];
        //滑动太快可能会停止播放,所以这里自动继续播放
        if (self.player.rate != 1.f) {
            if ([self currentTime] == [self duration])
                [self setCurrentTime:0.f];
            self.playOrPauseBtn.selected = NO;
            [self.player play];
        }
    }
    
    self.firstPoint = self.secondPoint;
    //    systemSlider.value += (self.firstPoint.y - self.secondPoint.y)/500.0;
    //    UISlider *volumeSlider = (UISlider *)[self viewWithTag:1000];
    //    volumeSlider.value = systemSlider.value;
    //    self.firstPoint = self.secondPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.firstPoint = self.secondPoint = CGPointZero;
}
//重置播放器
-(void )resetWMPlayer{
    self.currentItem = nil;
    self.seekTime = 0;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 关闭定时器
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
    // 暂停
    [self.player pause];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.player = nil;

}
-(void)dealloc{
    

    
    DDLogInfo(@"WMPlayer dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player pause];
    
    [self.player removeTimeObserver:self.playbackTimeObserver];
    
    //移除观察者
    [_currentItem removeObserver:self forKeyPath:@"status"];
    [_currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [_currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    

    [self.playerLayer removeFromSuperlayer];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    self.currentItem = nil;
    self.playOrPauseBtn = nil;
    self.playerLayer = nil;
    
    self.autoDismissTimer = nil;
    
}
- (NSString *)version{
    return @"2.0.0";
}

// 将 时间秒 转换成 小时：分钟：秒 格式 例如： 1420s 转换成 23:40
- (NSString *)convertSecondsToFormatString:(CGFloat)seconds
{
    NSInteger hour = seconds / (60 * 60);
    NSInteger min = (seconds - hour * 60 *60) / 60;
    NSInteger sec = seconds - min * 60 - hour * 60 * 60;
    NSString *timeString;
    
    if (hour > 0) {
        timeString = [NSString stringWithFormat:@"%.2zd:%.2zd:%.2zd",hour,min,sec];
    }
    else{
        timeString = [NSString stringWithFormat:@"%.2zd:%.2zd",min,sec];
    }
    return timeString;
}
- (void)addTopGradientInBackgroundView
{
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)   alpha:0.02];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.5];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:1];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.5),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = _topBackImgView.bounds;
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(0, 0);
    _topBackImgView.layer.mask = gradientLayer;
}
- (void)addBottomGradientInBackgroundView
{
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)   alpha:1];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.5];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.02];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.5),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = _bottomBackImgView.bounds;
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(0, 0);
    _bottomBackImgView.layer.mask = gradientLayer;
}
@end
