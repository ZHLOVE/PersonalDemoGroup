//
//  SJVideoPlayerWithoutWifiView.m
//  ShiJia
//
//  Created by yy on 16/8/4.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoPlayerWithoutWifiView.h"

static CGFloat btnwidth      = 120.0;
static CGFloat btnheight     = 40.0;
static CGFloat labelheight   = 20.0;
static CGFloat kInnerPadding = 10.0;

@interface SJVideoPlayerWithoutWifiView ()

@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation SJVideoPlayerWithoutWifiView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self addGestureRecognizer:tapGr];
        
        self.backgroundColor = [UIColor clearColor];
        
        // 背景
        _backImgView = [[UIImageView alloc] init];
        _backImgView.backgroundColor = [UIColor blackColor];
        _backImgView.alpha = 0.5;
        [self addSubview:_backImgView];
        
        // tip label
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.textColor = [UIColor whiteColor];
        _label.text = @"现在没有WIFI，再看就要花流量了";
        [self addSubview:_label];
        
        // button
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage imageNamed:@"video_detail_continue_btn"] forState:UIControlStateNormal];
        [_button setTitle:@"土豪请继续" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
       // [self addSubview:_button];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _button.frame = CGRectMake((self.frame.size.width - btnwidth) / 2.0,
                               (self.frame.size.height - btnheight - labelheight - kInnerPadding) / 2.0 + labelheight,
                               btnwidth,
                               btnheight);
    
    _label.frame = CGRectMake(0,
                              (self.frame.size.height - btnheight - labelheight - kInnerPadding) / 2.0,
                              self.frame.size.width,
                              labelheight);
    
    _backImgView.frame = self.bounds;
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self buttonClicked];
}
#pragma mark - Event
- (void)buttonClicked
{
    if (self.continueButtonClickBlock) {
        self.continueButtonClickBlock();
    }
}
@end
