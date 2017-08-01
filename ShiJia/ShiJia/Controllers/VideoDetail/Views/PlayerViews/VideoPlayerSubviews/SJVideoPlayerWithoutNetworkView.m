//
//  SJVideoPlayerWithoutNetworkView.m
//  ShiJia
//
//  Created by yy on 16/8/4.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoPlayerWithoutNetworkView.h"

static CGFloat btnwidth    = 40.0;
static CGFloat labelheight = 20.0;
static CGFloat labelwidth  = 120.0;

@interface SJVideoPlayerWithoutNetworkView ()

@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;


@end

@implementation SJVideoPlayerWithoutNetworkView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        
        _backImgView = [[UIImageView alloc] init];
        _backImgView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:_backImgView];
        
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:13.0];
        _label.textColor = [UIColor whiteColor];
        _label.text = @"网络连接失败，点击";
        [self addSubview:_label];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"重试" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_button setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _button.frame = CGRectMake((self.frame.size.width - btnwidth - labelwidth) / 2.0 + labelwidth,
                               (self.frame.size.height - btnwidth) / 2.0 ,
                               btnwidth,
                               btnwidth);
    
    _label.frame = CGRectMake((self.frame.size.width - btnwidth - labelwidth) / 2.0,
                              (self.frame.size.height - labelheight) / 2.0,
                              labelwidth,
                              labelheight);
    
    _backImgView.frame = self.bounds;
}

#pragma mark - Event
- (void)buttonClicked
{
    if (self.retryButtonClickBlock) {
        self.retryButtonClickBlock();
    }
}
@end
