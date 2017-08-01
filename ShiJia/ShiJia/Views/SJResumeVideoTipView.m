//
//  SJResumeVideoTipView.m
//  ShiJia
//
//  Created by yy on 2017/5/19.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJResumeVideoTipView.h"
#import "UIWindow+PazLabs.h"

#import "MainViewController.h"
#import "WatchListViewController.h"
#import "ChannelViewController.h"
#import "HotspotViewController.h"
#import "SJMyViewController.h"

static CGFloat kMainViewHeight1 = 52.0;//离家模式view高度
static CGFloat kMainViewHeight2 = 62.0;//回家模式view高度
static CGFloat kMainViewBottomPadding = 49.0;//view距离底部高度
static CGFloat kTipLabelLeftPadding = 10.0;//label左边距
static CGFloat kLineTopPadding = 15.0;//分割线上边距
static CGFloat kLineWidth = 1.0;
static CGFloat kButtonWidth = 60.0;

@interface SJResumeVideoTipView ()

//@property (nonatomic, strong) UIButton *topButton;
//@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UIView   *mainView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel  *tipLabel;
//@property (nonatomic, strong) UIImageView *lineImgView;
@property (nonatomic, assign) SJResumeVideoMode resumeMode;
@property (nonatomic, strong) RecentVideo *recentVideo;

@end

@implementation SJResumeVideoTipView
{
    dispatch_source_t _timer;
    NSInteger seconds;
}

#pragma mark - Lifecycle
- (instancetype)initWithMode:(SJResumeVideoMode)mode recentVideo:(RecentVideo *)video
{
    self = [super init];
    
    if (self) {
        
        self.resumeMode = mode;
        self.recentVideo = video;
        if (mode == SJResumeVideoModeTogether) {
            seconds = 5;
        }
        else{
            seconds = 30;
        }
        
    }
    return self;
}

#pragma mark - Subviews
- (void)setupSubviews
{
    // main view
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = kColorBlueTheme;
    self.mainView.alpha = 0.95;
    [self addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).with.offset(0);
        if (self.resumeMode == SJResumeVideoModeTogether) {
            make.height.mas_equalTo(kMainViewHeight2);
        }
        else{
            make.height.mas_equalTo(kMainViewHeight1);
        }
        make.bottom.equalTo(self).with.offset(-0);
        
    }];
    
    UIViewController *vc = [[AppDelegate appDelegate].window visibleViewController];
    if ([vc isKindOfClass:[MainViewController class]] ||
        [vc isKindOfClass:[HotspotViewController class]] ||
        [vc isKindOfClass:[WatchListViewController class]] ||
        [vc isKindOfClass:[SJMyViewController class]] ||
        [vc isKindOfClass:[ChannelViewController class]]) {
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.1 animations:^{
            
            [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self).with.offset(-kMainViewBottomPadding);
                
            }];
            
            [self layoutIfNeeded];//强制绘制
            
        }];
    }
    
    
    // top button
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topButton.backgroundColor = [UIColor clearColor];
    [topButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:topButton];
    [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self).with.offset(0);
        make.bottom.equalTo(self.mainView.mas_top).with.offset(0);
    }];
    
    // bottom button
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.backgroundColor = [UIColor clearColor];
    [bottomButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self).with.offset(0);
        make.top.equalTo(self.mainView.mas_bottom).with.offset(0);
        
    }];
    
    // right button
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.mainView).with.offset(0);
        make.width.mas_equalTo(kButtonWidth);
        
    }];
    
    // line image view
    UIImageView *lineImgView = [[UIImageView alloc] init];
    lineImgView.backgroundColor = [UIColor whiteColor];
    lineImgView.alpha = 0.8;
    [self.mainView addSubview:lineImgView];
    [lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView).with.offset(kLineTopPadding);
        make.bottom.equalTo(self.mainView).with.offset(-kLineTopPadding);
        make.right.equalTo(self.rightButton.mas_left).with.offset(0);
        make.width.mas_equalTo(kLineWidth);
    }];
    
    // left button
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineImgView.mas_left).with.offset(0);
        make.top.bottom.equalTo(self.mainView).with.offset(0);
        make.width.mas_equalTo(kButtonWidth);
    }];
    
    
    // tip label
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.font = [UIFont systemFontOfSize:14.0];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.numberOfLines = 4;
    [self.mainView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView).with.offset(kTipLabelLeftPadding);
        make.right.equalTo(self.leftButton.mas_left).with.offset(0);
        make.top.bottom.equalTo(self.mainView).with.offset(0);
    }];
    
    if (self.resumeMode == SJResumeVideoModeTogether) {
        [self.leftButton setTitle:@"继续观看" forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"resume_phone_icon"] forState:UIControlStateNormal];
        self.leftButton.imageEdgeInsets = [self buttonImageEdgeInsets:self.leftButton];
        self.leftButton.titleEdgeInsets = [self buttonLabelEdgeInsets:self.leftButton];
        
        [self.rightButton setTitle:@"投屏观看" forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"resume_tv_icon"] forState:UIControlStateNormal];
        self.rightButton.imageEdgeInsets = [self buttonImageEdgeInsets:self.rightButton];
        self.rightButton.titleEdgeInsets = [self buttonLabelEdgeInsets:self.rightButton];
        
        
        
    }
    else{
        [self.leftButton setTitle:@"手机观看" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"不看了" forState:UIControlStateNormal];
    }
    [self startCounting];
}

- (UIEdgeInsets)buttonImageEdgeInsets:(UIButton *)button;
{
    CGFloat space = 2.0;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = button.titleLabel.intrinsicContentSize.width;
        labelHeight = button.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = button.titleLabel.frame.size.width;
        labelHeight = button.titleLabel.frame.size.height;
    }
    
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space/2.0, 0, 0, -labelWidth);
    
    return imageEdgeInsets;
    
}

- (UIEdgeInsets)buttonLabelEdgeInsets:(UIButton *)button
{
    CGFloat space = 2.0;
    CGFloat imageWith = button.imageView.frame.size.width;
    CGFloat imageHeight = button.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = button.titleLabel.intrinsicContentSize.width;
        labelHeight = button.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = button.titleLabel.frame.size.width;
        labelHeight = button.titleLabel.frame.size.height;
    }
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight - space/2.0, 0);
    return labelEdgeInsets;
}

#pragma mark - Event
- (void)backButtonClicked:(id)sender
{
    [self hide];
}

- (void)leftButtonClicked:(id)sender
{
    // 回家/离家模式：手机观看
    if (self.leftButtonClickBlock) {
        self.leftButtonClickBlock();
    }
    [self hide];
}

- (void)rightButtonClicked:(id)sender
{
    
    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock();
    }
    [self hide];
    
}

#pragma mark - Operations
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self setupSubviews];
    
    NSString *device = @"手机";
    if (![self.recentVideo.deviceType isEqualToString:@"MOBILE"]) {
       device = @"TV";
    }
    NSString *programName = self.recentVideo.lastProgramName.length != 0 ? self.recentVideo.lastProgramName: self.recentVideo.objectName;
    
    self.tipLabel.text = [NSString stringWithFormat:@"上次在%@上观看了《%@》",device,programName];
    
}

- (void)hide
{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    [self removeFromSuperview];
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
            
            if (count >= seconds) {
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    count = 0;
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    [strongSelf hide];
                    
                });
                
            }
            else{
                
                count++;
            }
            
        });
        
    });
    dispatch_resume(_timer);
    
}

@end
