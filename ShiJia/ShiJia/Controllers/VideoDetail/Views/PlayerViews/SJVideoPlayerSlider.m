//
//  SJSlider.m
//  ShiJia
//
//  Created by yy on 16/3/28.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJVideoPlayerSlider.h"

static CGFloat kThumbImageWidth       = 16.0;
static CGFloat kProgressControlHeight = 5.0;

//static CGFloat kTopPadding            = 2.0;
static CGFloat kLabelWidth            = 100;
static CGFloat kLabelHeight           = 20.0;

static NSString *kBackgroundColorValue   = @"000000";// 背景色值
static NSString *kCacheColorValue        = @"ffffff";// 缓冲色值


@interface SJVideoPlayerSlider ()

@property (nonatomic, strong) UIImageView *backgroundImgView; // 背景
@property (nonatomic, strong) UIImageView *trackImgView; // 已播放背景
@property (nonatomic, strong) UIImageView *cacheImgView; // 缓存背景
@property (nonatomic, strong) UIButton    *thumbButton; // 滑块
@property (nonatomic, strong) UILabel     *playedTimeLabel; // 已播放时长label
@property (nonatomic, strong) UILabel     *totalTimeLabel; // 总时长label
@property (nonatomic, assign) BOOL        isFirstLoad;

@end


@implementation SJVideoPlayerSlider

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 背景
        _backgroundImgView = [[UIImageView alloc] init];
        
        _backgroundImgView.backgroundColor = [UIColor colorWithHexString:kBackgroundColorValue];
        [self addSubview:_backgroundImgView];
        
        // 缓冲进度
        _cacheImgView = [[UIImageView alloc] init];
        _cacheImgView.backgroundColor = [UIColor colorWithHexString:kCacheColorValue];
        [self addSubview:_cacheImgView];
        
        // 已播放进度
        _trackImgView = [[UIImageView alloc] init];
        _trackImgView.backgroundColor = kColorBlueTheme;
        [self addSubview:_trackImgView];
        
        // 滑块
        _thumbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _thumbButton.layer.cornerRadius = kThumbImageWidth / 2.0;
        _thumbButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:_thumbButton];
        
        // 已播放时长
        _playedTimeLabel = [[UILabel alloc] init];
        _playedTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _playedTimeLabel.textColor = [UIColor whiteColor];
        _playedTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_playedTimeLabel];
        
        // 总时长
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_totalTimeLabel];
        
        _isFirstLoad = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        
        [self addGestureRecognizer:pan];
      
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_isFirstLoad) {
        
        _isFirstLoad = NO;
        //[self updateSubviewsFrame];
        [self setSubviewFrame];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    
    if (point.x < 0) {
        point.x = 0;
    }
    else if (point.x > self.frame.size.width){
        point.x = self.frame.size.width;
    }
    
    _value = point.x / self.frame.size.width * _maximumValue;
    _cacheValue = _value;
    //[self updateSubviewsFrame];
    [self setSubviewFrame];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    
    self.isFirstLoad = NO;
}

#pragma mark - Event
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [gesture locationInView:self];
        if (point.x < 0) {
            point.x = 0;
        }
        else if (point.x > self.frame.size.width){
            point.x = self.frame.size.width;
        }
        _value = point.x / self.frame.size.width * _maximumValue;
        _cacheValue = _value;
        //[self updateSubviewsFrame];
        [self setSubviewFrame];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(frame))]) {
        _isFirstLoad = YES;
        [self setNeedsLayout];
    }
}

#pragma mark - Setter & Getter
- (void)setValue:(CGFloat)value
{
    _value = value;
    
    _playedTimeLabel.text = [self convertSecondsToFormatString:value];
    
    if (value > 0) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        //[self updateSubviewsFrame];
        [self setSubviewFrame];
        
        [UIView commitAnimations];
    }
    
}

- (void)setCacheValue:(CGFloat)cacheValue
{
    _cacheValue = cacheValue;
    
    if (cacheValue > 0) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        //[self updateSubviewsFrame];
        [self setSubviewFrame];
        
        [UIView commitAnimations];
    }
    
}

- (NSString *)playedTime
{
    return _playedTimeLabel.text;
}

- (NSString *)totalTime
{
    return _totalTimeLabel.text;
}

#pragma mark - Private
- (NSDictionary *)textAttributes
{
    return @{
             NSFontAttributeName: [UIFont systemFontOfSize:12.0],
             NSForegroundColorAttributeName: [UIColor whiteColor],
             };
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

- (void)setSubviewFrame
{
    // 已播放 frame
    CGFloat playedRatio;
    
    if (_maximumValue == 0)
    {
        playedRatio = 0;
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.hidden = YES;
        _thumbButton.hidden = YES;
    }
    else{
        playedRatio = _value / _maximumValue;
        _totalTimeLabel.text = [self convertSecondsToFormatString:_maximumValue];
        _totalTimeLabel.hidden = NO;
        _thumbButton.hidden = NO;
    }
    
    // 已播放进度
    CGFloat trackNodeWidth = self.frame.size.width * playedRatio;
    _trackImgView.frame = CGRectMake(0,
                                  kThumbImageWidth / 2.0 - kProgressControlHeight / 2.0,
                                  trackNodeWidth,
                                  kProgressControlHeight);
    
    // 滑块 frame
    CGFloat thumbOriginx = _trackImgView.frame.size.width - kThumbImageWidth * 0.5;
    
    if (thumbOriginx < 0) {
        thumbOriginx = 0;
    }
    _thumbButton.frame = CGRectMake(thumbOriginx,
                                  0,
                                  kThumbImageWidth,
                                  kThumbImageWidth);
    
    // 显示已播放时长文字需要的size
    _playedTimeLabel.text = [self convertSecondsToFormatString:_value];
    
    
    
    _playedTimeLabel.frame = CGRectMake(0,
                                       self.frame.size.height - kLabelHeight,
                                       kLabelWidth,
                                       kLabelHeight);
    
    
    _totalTimeLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - kLabelWidth,
                                      self.frame.size.height - kLabelHeight,
                                      kLabelWidth,
                                      kLabelHeight);
    
    if (_cacheValue > _value) {
        
        //        CGFloat cacheRatio = (_cacheValue - _value) / _maximumValue;
        CGFloat cacheRatio = _cacheValue / _maximumValue;
        CGFloat cacheNodeWidth = self.frame.size.width * cacheRatio;
        
        _cacheImgView.frame = CGRectMake(0,
                                      _trackImgView.frame.origin.y,
                                      cacheNodeWidth,
                                      kProgressControlHeight);
    }
    else{
        _cacheImgView.frame = CGRectMake(0,
                                      _trackImgView.frame.origin.y,
                                      _cacheImgView.frame.size.width,
                                      kProgressControlHeight);
    }
    
    
    _backgroundImgView.frame = CGRectMake(0,
                                       _trackImgView.frame.origin.y,
                                       self.frame.size.width,
                                       kProgressControlHeight );
    
}


@end
