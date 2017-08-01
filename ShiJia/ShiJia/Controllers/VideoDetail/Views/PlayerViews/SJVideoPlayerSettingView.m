//
//  SJVideoPlayerSettingView.m
//  ShiJia
//
//  Created by yy on 16/9/5.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoPlayerSettingView.h"

static CGFloat kVerLineImgWidth   = 2.0;
static CGFloat kVerLineImgHeight  = 16.0;
static CGFloat kVerLineImgOriginx = 10.0;
static CGFloat kHorLineImgHeight  = 1.0;
static CGFloat kLeftSpacing       = 10.0;
static CGFloat kLabelHeight       = 20.0;
static CGFloat kButtonWidth       = 60.0;
//static CGFloat kSliderHeight      = 31.0;

@interface SJVideoPlayerSettingView ()
{
    UILabel *_titleLabel;
    UILabel *_ratioTitleLabel;
    UIImageView *_verLineImgView;
    UIImageView *_horLineImgView;
    UILabel *_brightnessLabel;
}
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *ratio100Button;
@property (nonatomic, strong) UIButton *ratio50Button;
@property (nonatomic, strong) UISlider *brightnessSlider;

@end

@implementation SJVideoPlayerSettingView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        
        // 竖分割线
        _verLineImgView = [[UIImageView alloc] init];
        _verLineImgView.backgroundColor = kColorBlueTheme;
        [self addSubview:_verLineImgView];
        
        // 标题
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"播放器设置";
        [self addSubview:_titleLabel];
        
        // 横分割线
        _horLineImgView = [[UIImageView alloc] init];
        _horLineImgView.backgroundColor = kColorLightGrayBackground;
        [self addSubview:_horLineImgView];
        
        // 画面尺寸标题
        _ratioTitleLabel = [[UILabel alloc] init];
        _ratioTitleLabel.backgroundColor = [UIColor clearColor];
        _ratioTitleLabel.font = [UIFont systemFontOfSize:14.0];
        _ratioTitleLabel.textColor = [UIColor whiteColor];
        _ratioTitleLabel.text = @"画面尺寸：";
        [self addSubview:_ratioTitleLabel];
        
        // 满屏button
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setTitle:@"满屏" forState:UIControlStateNormal];
        [_fullScreenButton setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        [_fullScreenButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_fullScreenButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fullScreenButton];
        
        // 100%button
        _ratio100Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ratio100Button setTitle:@"100%" forState:UIControlStateNormal];
        [_ratio100Button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_ratio100Button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:_ratio100Button];
        
        // 50%button
        _ratio50Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ratio50Button setTitle:@"50%" forState:UIControlStateNormal];
        [_ratio50Button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_ratio50Button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:_ratio50Button];
        
        // 亮度标题
        _brightnessLabel = [[UILabel alloc] init];
        _brightnessLabel.backgroundColor = [UIColor clearColor];
        _brightnessLabel.font = [UIFont systemFontOfSize:14.0];
        _brightnessLabel.textColor = [UIColor whiteColor];
        _brightnessLabel.text = @"亮度：";
        [self addSubview:_brightnessLabel];
        
        // 亮度slider
        _brightnessSlider = [[UISlider alloc] init];
        _brightnessSlider.maximumValue = 1.0;
        _brightnessSlider.minimumValue = 0.0;
        _brightnessSlider.value = [UIScreen mainScreen].brightness;
        _brightnessSlider.minimumTrackTintColor =kColorBlueTheme;
        [_brightnessSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

        [self addSubview:_brightnessSlider];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _verLineImgView.frame = CGRectMake(kVerLineImgOriginx,
                                       kLeftSpacing + (kLabelHeight - kVerLineImgHeight) / 2.0,
                                       kVerLineImgWidth,
                                       kVerLineImgHeight);
   
    CGFloat labelOriginX = _verLineImgView.frame.origin.x + _verLineImgView.frame.size.width + 2.0;
    _titleLabel.frame = CGRectMake(labelOriginX,
                                   kLeftSpacing,
                                   self.frame.size.width - labelOriginX,
                                   kLabelHeight);
    
    _horLineImgView.frame = CGRectMake(0,
                                       _titleLabel.frame.origin.y + _titleLabel.frame.size.height + kLeftSpacing,
                                       self.frame.size.width,
                                       kHorLineImgHeight);
    
    _ratioTitleLabel.frame = CGRectMake(kLeftSpacing,
                                        _horLineImgView.frame.origin.y + _horLineImgView.frame.size.height + kLeftSpacing * 2,
                                        70,
                                        kLabelHeight);
    
    _fullScreenButton.frame = CGRectMake(_ratioTitleLabel.frame.origin.x + _ratioTitleLabel.frame.size.width + kLeftSpacing,
                                         _ratioTitleLabel.frame.origin.y,
                                         kButtonWidth,
                                         kLabelHeight);
    
    _ratio100Button.frame = CGRectMake(_fullScreenButton.frame.origin.x + _fullScreenButton.frame.size.width + kLeftSpacing,
                                       _fullScreenButton.frame.origin.y,
                                       kButtonWidth,
                                       kLabelHeight);
    
    _ratio50Button.frame = CGRectMake(_ratio100Button.frame.origin.x + _ratio100Button.frame.size.width + kLeftSpacing,
                                      _fullScreenButton.frame.origin.y,
                                      kButtonWidth,
                                      kLabelHeight);
    
    _brightnessLabel.frame = CGRectMake(kLeftSpacing,
                                        _ratioTitleLabel.frame.origin.y + _ratioTitleLabel.frame.size.height + kLeftSpacing * 2,
                                        50,
                                        kLabelHeight);
    
    CGFloat sliderOriginX = _brightnessLabel.frame.origin.x + _brightnessLabel.frame.size.width + kLeftSpacing;
    _brightnessSlider.frame = CGRectMake(sliderOriginX,
                                         _brightnessLabel.frame.origin.y - kLeftSpacing / 2.0,
                                         self.frame.size.width - sliderOriginX - kLeftSpacing,
                                         31);
    
}

#pragma mark - Event
- (void)buttonClicked:(UIButton *)sender
{
    if (sender == _fullScreenButton) {
        [_fullScreenButton setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        [_ratio100Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ratio50Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (self.videoScaleFillBlock) {
            self.videoScaleFillBlock();
        }
    }
    else if (sender == _ratio100Button){
        [_fullScreenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ratio100Button setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        [_ratio50Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (self.videoScaleAspectFillBlock) {
            self.videoScaleAspectFillBlock();
        }
    }
    else{
        [_fullScreenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ratio100Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ratio50Button setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        if (self.videoScaleAspect50Block) {
            self.videoScaleAspect50Block();
        }
    }
}

- (void)sliderValueChanged:(UISlider *)sender
{
    if (self.changeBrightnessBlock) {
        self.changeBrightnessBlock(sender.value);
    }
}

#pragma mark - Operation
- (void)showInView:(UIView *)view
{
    if (view) {
        
        _isShowing = YES;
        _brightnessSlider.value = [UIScreen mainScreen].brightness;
        [view addSubview:self];
    
    }
}

- (void)hide
{
    _isShowing = NO;
    [self removeFromSuperview];
}
@end
