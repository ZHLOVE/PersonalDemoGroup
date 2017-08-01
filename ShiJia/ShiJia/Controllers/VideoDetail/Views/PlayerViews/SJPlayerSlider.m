//
//  SJPlayerProgressView.m
//  ShiJia
//
//  Created by yy on 16/3/25.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJPlayerSlider.h"

static CGFloat kThumbImageWidth = 20.0;
static CGFloat kProgressControlHeight = 3.0;
//static CGFloat kTopPadding  = 2.0;
static CGFloat kThumbInitOriginX = -8.0;
static NSString *kBackgroundColorValue   = @"444444";// 背景色值
static NSString *kCacheColorValue        = @"ffffff";// 缓冲色值

@interface SJPlayerSlider ()
{
    UIPanGestureRecognizer *pan;
}
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) ASImageNode  *backgroundNode;
@property (nonatomic, strong) ASImageNode  *trackNode;
@property (nonatomic, strong) ASImageNode  *cacheNode;
@property (nonatomic, strong) ASButtonNode *thumbNode;
@property (nonatomic, strong) ASTextNode   *playedTimeNode;
@property (nonatomic, strong) ASTextNode   *totalTimeNode;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation SJPlayerSlider

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(frame)) options:NSKeyValueObservingOptionNew context:nil];
        
        // 背景
        _backgroundNode = [[ASImageNode alloc] init];
        _backgroundNode.backgroundColor = [UIColor colorWithHexString:kBackgroundColorValue];
        _backgroundNode.cornerRadius = kProgressControlHeight / 2.0;
        [self addSubnode:_backgroundNode];
        
        
        // 已缓冲
        _cacheNode = [[ASImageNode alloc] init];
        _cacheNode.backgroundColor = [UIColor colorWithHexString:kCacheColorValue];
        _cacheNode.cornerRadius = kProgressControlHeight / 2.0;
        [self addSubnode:_cacheNode];
        
        // 已播放
        _trackNode = [[ASImageNode alloc] init];
        _trackNode.backgroundColor = kColorBlueTheme;
        _trackNode.cornerRadius = kProgressControlHeight / 2.0;
        [self addSubnode:_trackNode];
        
        // 拖动滑块
        _thumbNode = [[ASButtonNode alloc] init];
        _thumbNode.cornerRadius = kThumbImageWidth / 2.0;
//        _thumbNode.backgroundColor = [UIColor whiteColor];
        [_thumbNode setImage:[UIImage imageNamed:@"player_slider_thumb"] forState:ASControlStateNormal];
        _thumbNode.imageNode.contentMode = UIViewContentModeCenter;
        [self addSubnode:_thumbNode];
        [_thumbNode addSubnode:_thumbNode.imageNode];
        
        // 已播放时间label
        _playedTimeNode = [[ASTextNode alloc] init];
        _playedTimeNode.alignSelf = ASStackLayoutAlignSelfCenter;
        _playedTimeNode.flexShrink = YES;
        _playedTimeNode.layerBacked = YES;
        _playedTimeNode.truncationMode = NSLineBreakByTruncatingTail;
        _playedTimeNode.maximumNumberOfLines = 1;
        [self addSubnode:_playedTimeNode];
        
        
        // 总时长label
        _totalTimeNode = [[ASTextNode alloc] init];
        _totalTimeNode.alignSelf = ASStackLayoutAlignSelfCenter;
        _totalTimeNode.flexShrink = YES;
        _totalTimeNode.layerBacked = YES;
        _totalTimeNode.truncationMode = NSLineBreakByTruncatingTail;
        _totalTimeNode.maximumNumberOfLines = 1;
        [self addSubnode:_totalTimeNode];
        
        _isFirstLoad = YES;
        
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.view addGestureRecognizer:pan];
        
        // 背景色加渐变
//        if (_gradientLayer == nil) {
//            _gradientLayer = [CAGradientLayer layer];
//            
//            //layer.frame = self.backgroundNode.bounds;
//            
//            //颜色分配:四个一组代表一种颜色(r,g,b,a)
//            _gradientLayer.colors = @[(__bridge id) [UIColor colorWithHexString:@"666666"].CGColor,
//                             (__bridge id) [UIColor colorWithHexString:kBackgroundColorValue].CGColor];
//            //起始点
//            _gradientLayer.startPoint = CGPointMake(0.25, 0.5);
//            //结束点
//            _gradientLayer.endPoint = CGPointMake(0.75, 0.5);
//            
//            _gradientLayer.cornerRadius = kProgressControlHeight / 2.0;
//            
//            _gradientLayer.masksToBounds = YES;
//            
//            [self.backgroundNode.layer addSublayer:_gradientLayer];
//        }
    }
    return self;
}

- (void)layout
{
    [super layout];
    
    if (_isFirstLoad) {
        
        _isFirstLoad = NO;
        //[self updateSubviewsFrame];
        [self setSubviewFrame];
    }
    _gradientLayer.frame = _backgroundNode.bounds;
    
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.isFirstResponder = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    self.isFirstResponder = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    

    if (point.x < 0) {
        point.x = 0;
    }
    else if (point.x > self.frame.size.width){
        point.x = self.frame.size.width;
    }
    
    _value = point.x / self.frame.size.width * _maximumValue;
    _cacheValue = _value;
    [self setSubviewFrame];
    [self sendActionsForControlEvents:ASControlNodeEventTouchDragInside withEvent:event];
    
    self.isFirstLoad = NO;
    self.isFirstResponder = NO;
}

#pragma mark - Event
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if (_maximumValue <= 0) {
        return;
    }
    
    CGPoint point = [gesture locationInView:self.view];
    if (point.x < 0) {
        point.x = 0;
    }
    else if (point.x > self.frame.size.width){
        point.x = self.frame.size.width - 2;
    }
    _value = point.x / self.frame.size.width * _maximumValue;
    _cacheValue = _value;
    [self setSubviewFrame];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        
        self.isFirstResponder = NO;
        [self sendActionsForControlEvents:ASControlNodeEventTouchDragInside withEvent:nil];
    }
    else{
        self.isFirstResponder = YES;
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
    if (_maximumValue <= 0) {
        _trackNode.frame = CGRectMake(0,
                                      kThumbImageWidth / 2.0 - kProgressControlHeight / 2.0,
                                      0,
                                      kProgressControlHeight);
        return;
    }
    _playedTimeNode.attributedString = [[NSAttributedString alloc] initWithString:[self convertSecondsToFormatString:value] attributes:[self textAttributes]];
    
    if (value > 0) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self setSubviewFrame];
        [UIView commitAnimations];
    }
    
}

- (void)setCacheValue:(CGFloat)cacheValue
{
    _cacheValue = cacheValue;
    if (_maximumValue <= 0)
    {
        _cacheNode.frame = CGRectMake(0,
                                      _trackNode.frame.origin.y,
                                      0,
                                      kProgressControlHeight);
    }
    if (cacheValue > 0) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self setSubviewFrame];
        [UIView commitAnimations];
    }

}

- (NSString *)playedTime
{
    return _playedTimeNode.attributedString.string;
}

- (NSString *)totalTime
{
    return _totalTimeNode.attributedString.string;
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
    //    playedRatio = 0;
        _totalTimeNode.attributedString = [[NSAttributedString alloc] initWithString:@"00:00"
                                                                          attributes:[self textAttributes]];
        
        // 显示已播放时长文字需要的size
        _playedTimeNode.attributedString = [[NSAttributedString alloc] initWithString:@"00:00"
                                                                           attributes:[self textAttributes]];
        
        CGSize playedTimeSize = [_playedTimeNode measure:self.frame.size];
        _playedTimeNode.frame = CGRectMake(0,
                                           self.frame.size.height - playedTimeSize.height-5,
                                           playedTimeSize.width,
                                           playedTimeSize.height);
        
        // 显示影片时长文字需要的size
        CGSize totalTimeSize = [_totalTimeNode measure:self.frame.size];
        _totalTimeNode.frame = CGRectMake(CGRectGetWidth(self.frame) - totalTimeSize.width,
                                          self.frame.size.height - totalTimeSize.height-5,
                                          totalTimeSize.width,
                                          totalTimeSize.height);
        
        _thumbNode.frame = CGRectMake(kThumbInitOriginX,
                                      0,
                                      kThumbImageWidth,
                                      kThumbImageWidth);
        
        _backgroundNode.frame = CGRectMake(0,
                                           kThumbImageWidth / 2.0 - kProgressControlHeight / 2.0,
                                           self.frame.size.width,
                                           kProgressControlHeight );
        self.enabled = NO;
    }
    else{
        
        if (!self.enabled) {
            self.enabled = YES;
        }
        
        playedRatio = _value / _maximumValue;
        _totalTimeNode.attributedString = [[NSAttributedString alloc] initWithString:[self convertSecondsToFormatString:_maximumValue] attributes:[self textAttributes]];
        
        
        // 已播放进度
        CGFloat trackNodeWidth = self.frame.size.width * playedRatio;
        _trackNode.frame = CGRectMake(0,
                                      kThumbImageWidth / 2.0 - kProgressControlHeight / 2.0,
                                      trackNodeWidth,
                                      kProgressControlHeight);
        
        // 滑块 frame
        CGFloat thumbOriginx = _trackNode.frame.size.width - kThumbImageWidth * 0.5;
        
        if (thumbOriginx < kThumbInitOriginX) {
            thumbOriginx = kThumbInitOriginX;
        }
        _thumbNode.frame = CGRectMake(thumbOriginx,
                                      0,
                                      kThumbImageWidth,
                                      kThumbImageWidth);
        
        // 显示已播放时长文字需要的size
        _playedTimeNode.attributedString = [[NSAttributedString alloc] initWithString:[self convertSecondsToFormatString:_value] attributes:[self textAttributes]];
        CGSize playedTimeSize = [_playedTimeNode measure:self.frame.size];
        
        
        
        
        
        _playedTimeNode.frame = CGRectMake(0,
                                           self.frame.size.height - playedTimeSize.height-5,
                                           playedTimeSize.width,
                                           playedTimeSize.height);
        
        // 显示影片时长文字需要的size
        CGSize totalTimeSize = [_totalTimeNode measure:self.frame.size];
        _totalTimeNode.frame = CGRectMake(CGRectGetWidth(self.frame) - totalTimeSize.width,
                                          self.frame.size.height - totalTimeSize.height-5,
                                          totalTimeSize.width,
                                          totalTimeSize.height);
        
        
        
        if (_cacheValue > _value) {
            
            //        CGFloat cacheRatio = (_cacheValue - _value) / _maximumValue;
            CGFloat cacheRatio = _cacheValue / _maximumValue;
            CGFloat cacheNodeWidth = self.frame.size.width * cacheRatio;
            
            _cacheNode.frame = CGRectMake(0,
                                          _trackNode.frame.origin.y,
                                          cacheNodeWidth,
                                          kProgressControlHeight);
        }
        else{
            _cacheNode.frame = CGRectMake(0,
                                          _trackNode.frame.origin.y,
                                          _cacheNode.frame.size.width,
                                          kProgressControlHeight);
        }
        
        _backgroundNode.frame = CGRectMake(0,
                                           _trackNode.frame.origin.y,
                                           self.frame.size.width,
                                           kProgressControlHeight );
    }
    
    _thumbNode.imageNode.frame = _thumbNode.bounds;
    
    
   

}

-(void)dealloc {
    [self.view removeGestureRecognizer:pan];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(frame))];
    DDLogInfo(@"########## SJPlayerSlider dealloc");
}
@end
