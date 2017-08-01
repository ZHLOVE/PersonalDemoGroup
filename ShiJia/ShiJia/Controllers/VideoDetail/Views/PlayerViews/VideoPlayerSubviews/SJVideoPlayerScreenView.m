//
//  SJVideoPlayerScreenView.m
//  ShiJia
//
//  Created by yy on 16/8/4.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoPlayerScreenView.h"

static CGFloat imgwidth = 40.0;
static CGFloat labelwidth = 160.0;
static CGFloat labelheight = 20.0;
static CGFloat btnheight = 50.0;

@interface SJVideoPlayerScreenView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *remoteBtn;

@end

@implementation SJVideoPlayerScreenView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        _imgView = [[UIImageView alloc] init];
        //_imgView.image = [UIImage imageNamed:@"player_screen_btn"];
        [self addSubview:_imgView];
        
        
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:13.0];
        _label.textColor = kColorLightGrayBackground;
        _label.text = @"电视播放中";
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        _remoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _remoteBtn.backgroundColor = kColorBlueTheme;
        [_remoteBtn setTitle:@"手机遥控器" forState:UIControlStateNormal];
        /*UIColor *borderColor = RGB(43, 194, 239, 1);
        [_remoteBtn setTitleColor:borderColor forState:UIControlStateNormal];
        _remoteBtn.layer.cornerRadius=10;
        _remoteBtn.clipsToBounds=YES;
        _remoteBtn.layer.borderColor = borderColor.CGColor;
        _remoteBtn.layer.borderWidth = 1.0f;*/
        [_remoteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_remoteBtn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_remoteBtn];

    }
    return self;

}
-(void)setTvPlay:(BOOL)tvPlay{
    _tvPlay = tvPlay;
    if (_tvPlay) {
        _label.text = @"该节目仅支持电视端播放";
    }else{
        _label.text = @"电视播放中";
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
        
    
    _imgView.frame = CGRectMake((self.frame.size.width - imgwidth) / 2.0,
                                (self.frame.size.height - imgwidth - labelheight) / 2.0,
                                imgwidth,
                                imgwidth);

    
    _label.frame = CGRectMake((self.frame.size.width - labelwidth) / 2.0,
                              (self.frame.size.height - imgwidth - labelheight-btnheight) / 2.0 + imgwidth/2,
                              labelwidth,
                              labelheight);
        
    _remoteBtn.frame = CGRectMake((self.frame.size.width - labelwidth) / 2.0,
                              _label.frame.origin.y+labelheight+20,
                              labelwidth,
                              btnheight);
    
}
#pragma mark - Event
- (void)buttonClicked
{
    if (self.remoteButtonClickBlock) {
        self.remoteButtonClickBlock();
    }
}
@end
