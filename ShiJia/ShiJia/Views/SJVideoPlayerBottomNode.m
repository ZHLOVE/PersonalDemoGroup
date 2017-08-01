//
//  SJVideoPlayerBottomNode.m
//  ShiJia
//
//  Created by yy on 16/4/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJVideoPlayerBottomNode.h"
#import "SJVideoPlayerView.h"
#import "SJPlayerSlider.h"

CGFloat const kSJVideoPlayerBottomViewHeight = 40.0;
static CGFloat kButtonNodeWidth              = 45.0;
static CGFloat kButtonNodeHeight             = 35.0;
static CGFloat kSliderHeight                 = 40.0;

@interface SJVideoPlayerBottomNode ()

@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) ASImageNode               *playNode;
@property (nonatomic, strong) ASButtonNode              *resizeNode;
@property (nonatomic, strong, readwrite) SJPlayerSlider *slider;


@end

@implementation SJVideoPlayerBottomNode

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _backImgView = [[UIImageView alloc] init];
        _backImgView.backgroundColor = [UIColor blackColor];
        //_backImgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player_bottom_background"]];
        //_backImgView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_backImgView];
        
        // 播放 / 暂停 按钮
        _playNode = [[ASImageNode alloc] init];
        _playNode.image = [UIImage imageNamed:@"player_pause_btn1"];
        _playNode.contentMode = UIViewContentModeCenter;
        [_playNode addTarget:self action:@selector(playNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:_playNode];
        
        // 小屏 / 全屏 切换按钮
        _resizeNode = [[ASButtonNode alloc] init];
        [_resizeNode setImage:[UIImage imageNamed:@"player_max_btn1"] forState:ASControlStateNormal];
        [_resizeNode setImage:[UIImage imageNamed:@"player_max_btn1"] forState:ASControlStateHighlighted];
        [_resizeNode addTarget:self action:@selector(resizeNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        _resizeNode.imageNode.contentMode = UIViewContentModeCenter;
        [_resizeNode addSubnode:_resizeNode.imageNode];
        [self addSubnode:_resizeNode];
        
        // 进度条
        _slider = [[SJPlayerSlider alloc] init];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:ASControlNodeEventTouchDragInside];
        [self addSubnode:_slider];
        
        _isPlaying = YES;
        _isFullScreen = NO;
        [_slider addObserver:self forKeyPath:NSStringFromSelector(@selector(isFirstResponder)) options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layout
{
    [super layout];
    
    _backImgView.frame = self.bounds;
   
    //背景加渐变
    [self addGradientInBackgroundView];
    
    // 播放按钮（靠左，居中对齐）
    _playNode.frame = CGRectMake(0, (kSJVideoPlayerBottomViewHeight - kButtonNodeWidth) / 2.0, kButtonNodeWidth, kButtonNodeWidth);
    
    // 小屏/全屏切换按钮（靠右，居中对齐）
    _resizeNode.frame = CGRectMake(CGRectGetWidth(self.frame) - kButtonNodeWidth, (kSJVideoPlayerBottomViewHeight - kButtonNodeHeight) / 2.0, kButtonNodeWidth, kButtonNodeHeight);
    _resizeNode.imageNode.frame = _resizeNode.bounds;
    
    // 进度条
    CGFloat originx = CGRectGetWidth(_playNode.frame) + _playNode.frame.origin.x + 10;
    _slider.frame = CGRectMake(originx, (kSJVideoPlayerBottomViewHeight - kSliderHeight) / 2.0, CGRectGetWidth(self.frame) - originx * 2, kSliderHeight);
    
}

#pragma mark - Event
- (void)playNodeClicked:(id)sender
{
    self.isPlaying = !_isPlaying;
  
    if (self.isPlaying && [self.delegate respondsToSelector:@selector(bottomViewDidClickPlay:)]) {
        [self.delegate bottomViewDidClickPlay:self];
    }
    
    if (!self.isPlaying && [self.delegate respondsToSelector:@selector(bottomViewDidClickPause:)]) {
        [self.delegate bottomViewDidClickPause:self];
    }
    
}

- (void)resizeNodeClicked:(id)sender
{
    
    _isFullScreen = !_isFullScreen;
    
    if (_isFullScreen) {
        
        
            [_resizeNode setImage:[UIImage imageNamed:@"player_min_btn1"] forState:ASControlStateNormal];
            [_resizeNode setImage:[UIImage imageNamed:@"player_min_btn1"] forState:ASControlStateHighlighted];
        
            if ([self.delegate respondsToSelector:@selector(bottomViewDidClickFullScreen:)]) {
                [self.delegate bottomViewDidClickFullScreen:self];
            }
        
        
    }
    else{
        [_resizeNode setImage:[UIImage imageNamed:@"player_max_btn1"] forState:ASControlStateNormal];
        [_resizeNode setImage:[UIImage imageNamed:@"player_max_btn1"] forState:ASControlStateHighlighted];
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:NSStringFromSelector(@selector(orientation))];
        if ([self.delegate respondsToSelector:@selector(bottomViewDidClickMiniScreen:)]) {
            [self.delegate bottomViewDidClickMiniScreen:self];
        }
    }
    
}

- (void)sliderValueChanged:(SJPlayerSlider *)sender
{
    if ([self.delegate respondsToSelector:@selector(bottomView:didChangeSliderValue:)]) {
        [self.delegate bottomView:self didChangeSliderValue:_slider];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isFirstResponder))]) {
        BOOL responder = (BOOL)object;
        if (responder && [self.delegate respondsToSelector:@selector(sliderDidBecomeFirstResponder:)]) {
            [self.delegate sliderDidBecomeFirstResponder:self];
        }
    }
}

#pragma mark - Public Methods
- (void)updateCacheTime:(CGFloat)cacheTime
{
    
    _slider.cacheValue = cacheTime;
}

- (void)updatePlayedTime:(CGFloat)playerTime
{
    
    _slider.value = playerTime;
}

- (void)updateTotalTime:(CGFloat)totalTime
{
    _slider.minimumValue = 0.0;
    _slider.maximumValue = totalTime;
}

- (CGFloat)sliderValue
{
    return _slider.value;
}

- (NSString *)playedTime
{
    return _slider.playedTime;
}

- (NSString *)totalTime
{
    return _slider.totalTime;
}

#pragma mark - Subviews
- (void)addGradientInBackgroundView
{
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)   alpha:1.0];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.5];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.02];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.5),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = _backImgView.bounds;
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(0, 0);
    _backImgView.layer.mask = gradientLayer;
}

#pragma mark - Setter
- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    
    if (_isFullScreen) {
        [_resizeNode setImage:[UIImage imageNamed:@"player_min_btn1"] forState:ASControlStateNormal];
        [_resizeNode setImage:[UIImage imageNamed:@"player_min_btn1"] forState:ASControlStateHighlighted];
    }
    else{
        [_resizeNode setImage:[UIImage imageNamed:@"player_max_btn1"] forState:ASControlStateNormal];
        [_resizeNode setImage:[UIImage imageNamed:@"player_max_btn1"] forState:ASControlStateHighlighted];
    }
}

- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    
    if (_isPlaying) {
        [_playNode setImage:[UIImage imageNamed:@"player_pause_btn1"]];
    }
    else{
        [_playNode setImage:[UIImage imageNamed:@"player_play_btn1"]];
    }
}

- (void)handle_dealloc
{
    [self removeFromSupernode];
    [_playNode addTarget:self action:@selector(playNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    [_playNode removeTarget:self action:@selector(playNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    
    [_resizeNode removeTarget:self action:@selector(resizeNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    
    [_slider removeTarget:self action:@selector(sliderValueChanged:) forControlEvents:ASControlNodeEventTouchDragInside];
    [_slider removeObserver:self forKeyPath:NSStringFromSelector(@selector(isFirstResponder))];
    
    [[NSNotificationCenter defaultCenter] removeObserver:_slider];
    
}
- (void)dealloc {
    DDLogInfo(@"####### VideoPlayerBottomNode dealloc");
}
@end
