//
//  SJVideoPlayerTitleNode.m
//  ShiJia
//
//  Created by yy on 16/4/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJVideoPlayerTitleNode.h"
#import "SJVideoPlayerView.h"
#import "TPXmppRoomManager.h"

CGFloat const kSJVideoPlayerTitleViewHeight = 40.0;// 标题栏高度
static CGFloat kBackNodeWidth               = 38.0;// 返回按钮宽度
static CGFloat kRightButtonNodeWidth        = 40.0;// 右侧按钮宽度
static CGFloat kRightButtonNodeHeight       = 25.0;// 右侧按钮高度
static CGFloat kInnerPadding                = 10.0;// 右侧按钮之间的间隙
static CGFloat kTopPadding                  = 0.0;// staus bar高度



@interface SJVideoPlayerTitleNode ()
{
    RACDisposable *handler;
}
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong, readwrite) ASImageNode  *backgroudImgNode;// 背景
@property (nonatomic, strong, readwrite) ASTextNode   *textNode; // 标题
@property (nonatomic, strong, readwrite) ASButtonNode *backNode;  // 返回按钮
@property (nonatomic, strong, readwrite) ASButtonNode *danmuNode; // 弹幕按钮
@property (nonatomic, strong, readwrite) ASButtonNode *seriesNode;// 选集按钮
@property (nonatomic, strong, readwrite) ASButtonNode *moreNode;  // 更多按钮


@property (nonatomic, assign) NSInteger     currentVideoIndex;
@property (nonatomic, assign, readwrite) BOOL showBarrage;

@end

@implementation SJVideoPlayerTitleNode

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //self.backgroundColor = [UIColor clearColor];
        _backImgView = [[UIImageView alloc] init];
        _backImgView.backgroundColor = [UIColor blackColor];
        //_backImgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player_title_background"]];
        [self.view addSubview:_backImgView];
        
        // 背景图片
        _backgroudImgNode = [[ASImageNode alloc] init];
        //_backgroudImgNode.image = [UIImage imageNamed:@"player_title_background"];
        //_backgroudImgNode.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player_title_background"]];
        //_backgroudImgNode.alpha = 0.3;
        [self addSubnode:_backgroudImgNode];
        
        
        // 返回按钮
        _backNode = [[ASButtonNode alloc] init];
        [_backNode setImage:[UIImage imageNamed:@"white_back_img"] forState:ASControlStateNormal];
        [_backNode setImage:[UIImage imageNamed:@"white_back_img"] forState:ASControlStateHighlighted];
        _backNode.imageNode.contentMode = UIViewContentModeCenter;
        [_backNode addTarget:self action:@selector(backNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:_backNode];
        [_backNode addSubnode:_backNode.imageNode];
        
        
        // 标题
        _textNode = [[ASTextNode alloc] init];
        //_textNode.alignSelf = ASStackLayoutAlignSelfCenter;
        _textNode.flexShrink = NO;
        //_textNode.layerBacked = YES;
        _textNode.truncationMode = NSLineBreakByTruncatingTail;
        _textNode.maximumNumberOfLines = 1;
        [self addSubnode:_textNode];
        
        // 弹幕按钮
        _danmuNode = [[ASButtonNode alloc] init];
        [_danmuNode setImage:[UIImage imageNamed:@"danmu_btn_highlighted"] forState:ASControlStateNormal];
        [_danmuNode setImage:[UIImage imageNamed:@"danmu_btn"] forState:ASControlStateHighlighted];
        _danmuNode.imageNode.contentMode = UIViewContentModeCenter;
        [_danmuNode addTarget:self action:@selector(danmuNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:_danmuNode];
        [_danmuNode addSubnode:_danmuNode.imageNode];
        
        
        // 剧集按钮
        _seriesNode = [[ASButtonNode alloc] init];//video_series_btn
        [_seriesNode setImage:[UIImage imageNamed:@"video_series"] forState:ASControlStateNormal];
        [_seriesNode setImage:[UIImage imageNamed:@"video_series"] forState:ASControlStateHighlighted];
        _seriesNode.imageNode.contentMode = UIViewContentModeCenter;
        [_seriesNode addTarget:self action:@selector(seriesNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:_seriesNode];
        [_seriesNode addSubnode:_seriesNode.imageNode];
        
        // 更多按钮
        _moreNode = [[ASButtonNode alloc] init];
        [_moreNode setImage:[UIImage imageNamed:@"player_more_btn"] forState:ASControlStateNormal];
        [_moreNode setImage:[UIImage imageNamed:@"player_more_btn"] forState:ASControlStateHighlighted];
        _moreNode.imageNode.contentMode = UIViewContentModeCenter;
        [_moreNode addTarget:self action:@selector(moreNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:_moreNode];
        [_moreNode addSubnode:_moreNode.imageNode];
        
        self.showBarrage = YES;
        
        handler = [RACObserve([TPXmppRoomManager defaultManager], isInChatRoom) subscribeNext:^(NSNumber *x) {
            if (!self.playerView.showDanmuSwitch) {
                if (x.boolValue == YES) {
                    _danmuNode.hidden = NO;
                    _liveLogo.hidden = NO;
                }
                else{
                    _danmuNode.hidden = YES;
                    _liveLogo.hidden = YES;
                }
            }
            
        }];
        [self hideButtons];
        
    }
    return self;
}
- (void)layout
{
    [super layout];
    
    _backImgView.frame = self.bounds;
    
    // 背景图片（充满整个标题栏）
    _backgroudImgNode.frame = self.bounds;
    
    [self addGradientInBackgroundView];
    if (!self.isFullScreen) {
        kTopPadding = 0;
    }
    else{
        kTopPadding = 20;
    }
    // 返回按钮（靠左、上对齐，宽度高度固定）
    _backNode.frame = CGRectMake(0,
                                 kTopPadding,
                                 kBackNodeWidth,
                                 kBackNodeWidth);
    
    _backNode.imageNode.frame = _backNode.bounds;
    
    CGFloat titleViewWidth = self.frame.size.width;
    
        
    if (!self.isFullScreen) {
        // 标题label（居中对齐，小屏时宽度为：标题栏的宽度 - 返回按钮宽度 *2，全屏时宽度为：标题栏宽度 - 右侧按钮宽度之和 * 2）
        CGSize titleNodeSize = [_textNode measure:CGSizeMake(titleViewWidth - kBackNodeWidth * 2 - kInnerPadding , self.frame.size.height)];
        _textNode.frame = CGRectMake(kBackNodeWidth,
                                     (kSJVideoPlayerTitleViewHeight - kTopPadding - titleNodeSize.height) / 2.0 + kTopPadding  ,
                                     titleNodeSize.width,
                                     titleNodeSize.height);
        
        // 弹幕按钮（在选集按钮左侧，中间间隙固定）
        
        if (_playerView.showDanmuSwitch) {
            _danmuNode.frame = CGRectMake(titleViewWidth - kBackNodeWidth - kInnerPadding-40,
                                          (kSJVideoPlayerTitleViewHeight - kTopPadding - kBackNodeWidth) / 2.0 + kTopPadding,
                                          kBackNodeWidth,
                                          kBackNodeWidth);
        }
        else{
            _danmuNode.frame = CGRectMake(titleViewWidth - kBackNodeWidth - kInnerPadding,
                                          (kSJVideoPlayerTitleViewHeight - kTopPadding - kBackNodeWidth) / 2.0 + kTopPadding,
                                          kBackNodeWidth,
                                          kBackNodeWidth);
        }
        /*_liveLogo.frame = CGRectMake(titleViewWidth - kBackNodeWidth - kInnerPadding+10,
                                      (kSJVideoPlayerTitleViewHeight - kTopPadding - kBackNodeWidth) / 2.0 + kTopPadding+10,
                                      kLiveLogoWidth,
                                      kLiveLogoHeight);*/
        
        // 更多按钮（靠右、上下居中对齐，宽度高度固定）
        _moreNode.frame = CGRectMake(titleViewWidth - kBackNodeWidth,
                                     (kSJVideoPlayerTitleViewHeight - kTopPadding - kBackNodeWidth) / 2.0 + kTopPadding,
                                     kBackNodeWidth,
                                     kBackNodeWidth);
        _moreNode.imageNode.frame = _moreNode.bounds;
        
        // 选集按钮（在更多按钮的左侧，中间间隙固定）
        _seriesNode.frame = CGRectMake(_moreNode.frame.origin.x - kBackNodeWidth - kInnerPadding,
                                       (kSJVideoPlayerTitleViewHeight - kTopPadding - kRightButtonNodeHeight) / 2.0 + kTopPadding,
                                       kRightButtonNodeWidth,
                                       kRightButtonNodeHeight);
        _seriesNode.imageNode.frame = _seriesNode.bounds;
        

        _textNode.frame = CGRectMake(_backNode.frame.size.width, (kSJVideoPlayerTitleViewHeight - kTopPadding - titleNodeSize.height) / 2.0 + kTopPadding , _danmuNode.frame.origin.x - _backNode.frame.size.width, titleNodeSize.height);
        
        
    }
    else{
        // 标题label（居中对齐，小屏时宽度为：标题栏的宽度 - 返回按钮宽度 *2，全屏时宽度为：标题栏宽度 - 右侧按钮宽度之和 * 2）
        CGSize titleNodeSize = [_textNode measure:CGSizeMake(titleViewWidth - kBackNodeWidth * 3 - kInnerPadding * 3 , self.frame.size.height)];
        /*_liveLogo.frame = CGRectMake(kBackNodeWidth,
                                     (kSJVideoPlayerTitleViewHeight - kTopPadding - titleNodeSize.height) / 2.0 + kTopPadding  +9,
                                     kLiveLogoWidth,
                                     kLiveLogoHeight);*/
        
        _textNode.frame = CGRectMake(kBackNodeWidth,
                                     (kSJVideoPlayerTitleViewHeight - kTopPadding - titleNodeSize.height) / 2.0 + kTopPadding  +5,
                                     titleViewWidth-(kBackNodeWidth)*2,
                                     titleNodeSize.height);
        
        // 更多按钮（靠右、上下居中对齐，宽度高度固定）
        _moreNode.frame = CGRectMake(titleViewWidth - kBackNodeWidth,
                                     (kSJVideoPlayerTitleViewHeight - kTopPadding - kBackNodeWidth) / 2.0 + kTopPadding,
                                     kBackNodeWidth,
                                     kBackNodeWidth);
        _moreNode.imageNode.frame = _moreNode.bounds;
        
        // 选集按钮（在更多按钮的左侧，中间间隙固定）
        _seriesNode.frame = CGRectMake(_moreNode.frame.origin.x - kBackNodeWidth - kInnerPadding,
                                       (kSJVideoPlayerTitleViewHeight - kTopPadding - kRightButtonNodeHeight) / 2.0 + kTopPadding,
                                       kRightButtonNodeWidth,
                                       kRightButtonNodeHeight);
        _seriesNode.imageNode.frame = _seriesNode.bounds;
       
        
        // 弹幕按钮（在选集按钮左侧，中间间隙固定）
        _danmuNode.frame = CGRectMake(_seriesNode.frame.origin.x - kBackNodeWidth - kInnerPadding ,
                                      (kSJVideoPlayerTitleViewHeight - kTopPadding - kRightButtonNodeHeight) / 2.0 +  kTopPadding,
                                      kRightButtonNodeWidth,
                                      kRightButtonNodeHeight);
        

       // _textNode.frame = CGRectMake(_backNode.frame.size.width, (kSJVideoPlayerTitleViewHeight - kTopPadding - titleNodeSize.height) / 2.0 + kTopPadding , _danmuNode.frame.origin.x - _backNode.frame.size.width, titleNodeSize.height);
    }
    
    _danmuNode.imageNode.frame = _danmuNode.bounds;
    
}

#pragma mark - Subviews
- (void)showButtons
{
//    _danmuNode.hidden = NO;
    _seriesNode.hidden = NO;
    _moreNode.hidden = NO;
}

- (void)hideButtons
{
//    _danmuNode.hidden = YES;
    _seriesNode.hidden = YES;
    _moreNode.hidden = YES;
}

#pragma mark - Event
- (void)backNodeClicked:(id)sender
{
//    if ([_playerView.delegate respondsToSelector:@selector(playerViewDidClickBack:)]) {
//        [_playerView.delegate playerViewDidClickBack:_playerView];
//    }
    if ([self.delegate respondsToSelector:@selector(titleViewDidClickBack:)]) {
        [self.delegate titleViewDidClickBack:self];
    }
}

- (void)danmuNodeClicked:(id)sender
{
    self.showBarrage = !self.showBarrage;
    
    if (self.showBarrage) {
        
        [_danmuNode setImage:[UIImage imageNamed:@"danmu_btn_highlighted"] forState:ASControlStateNormal];
        [_danmuNode setImage:[UIImage imageNamed:@"danmu_btn"] forState:ASControlStateHighlighted];
    }
    else{
        [_danmuNode setImage:[UIImage imageNamed:@"danmu_btn"] forState:ASControlStateNormal];
        [_danmuNode setImage:[UIImage imageNamed:@"danmu_btn_highlighted"] forState:ASControlStateHighlighted];
    }
    
    if ([_playerView.delegate respondsToSelector:@selector(playerViewDidClickDanmu:)]) {
        [_playerView.delegate playerViewDidClickDanmu:_playerView];
    }
}

- (void)seriesNodeClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(titleViewDidClickSeries:)]) {
        [self.delegate titleViewDidClickSeries:self];
    }
}

- (void)moreNodeClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(titleViewDidClickMore:)]) {
        [self.delegate titleViewDidClickMore:self];
    }
}

#pragma mark - Setter
- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    if (isFullScreen) {
        [self showButtons];
    }
    else{
        [self hideButtons];
    }
}

- (void)setPlayerView:(SJVideoPlayerView *)playerView
{
    _playerView = playerView;
    
    if (playerView) {
        [_playerView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
        [_playerView addObserver:self forKeyPath:NSStringFromSelector(@selector(showDanmuSwitch)) options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
     if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))]){
        
         if (_playerView.title.length != 0) {
             _textNode.attributedString = [[NSAttributedString alloc] initWithString:_playerView.title attributes:[self titleAttributes]];
             [self setNeedsLayout];
         }        
    }
     else if ([keyPath isEqualToString:NSStringFromSelector(@selector(showDanmuSwitch))]){
         if (_playerView.showDanmuSwitch) {
             _danmuNode.hidden = NO;
             _liveLogo.hidden = NO;
         }
         else{
             _danmuNode.hidden = YES;
             _liveLogo.hidden = YES;
         }
     }

}

#pragma mark - Private
- (NSDictionary *)titleAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    return @{
             NSFontAttributeName: [UIFont systemFontOfSize:16.0],
             NSForegroundColorAttributeName: [UIColor whiteColor],
             NSParagraphStyleAttributeName: paragraphStyle
             };
}

- (NSDictionary *)buttonTextAttributes
{
    return @{
             NSFontAttributeName: [UIFont systemFontOfSize:14.0],
             NSForegroundColorAttributeName: [UIColor whiteColor],
             };
    
}

#pragma mark - Subviews
- (void)addGradientInBackgroundView
{
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)   alpha:0.01];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.5];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:1];
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

- (void)handle_dealloc
{
    [handler dispose];
    [_seriesNode removeTarget:self action:@selector(seriesNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    [_backNode removeTarget:self action:@selector(backNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    [_danmuNode removeTarget:self action:@selector(danmuNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    [_moreNode removeTarget:self action:@selector(moreNodeClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
    [_playerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    [_playerView removeObserver:self forKeyPath:NSStringFromSelector(@selector(showDanmuSwitch))];
    _playerView = nil;
}

- (void)dealloc {
    DDLogInfo(@"####### VideoPlayerTitleNode dealloc");
}
@end

