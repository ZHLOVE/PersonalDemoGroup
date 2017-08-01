//
//  SJVideoPlayerCustomHUDView.m
//  ShiJia
//
//  Created by yy on 16/8/15.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoPlayerCustomHUDView.h"

static CGFloat kImgViewHeight = 50.0;
static CGFloat kProgressViewWidth = 100.0;
static CGFloat kProgressViewHeight = 2.0;
static CGFloat kInnerPadding = 20.0;

@interface SJVideoPlayerCustomHUDView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation SJVideoPlayerCustomHUDView

- (instancetype)initWithImage:(UIImage *)img progressValue:(CGFloat)value
{
    self = [super initWithFrame:CGRectMake(0, 0, 150, 150)];
    
    if (self) {
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = img;
        [self addSubview:_imgView];
        
        _progressView = [[UIProgressView alloc] init];
        [_progressView setProgressTintColor:kColorBlueTheme];
        [_progressView setTrackTintColor:[UIColor colorWithHexString:@"444444"]];
        _progressView.progress = value;
        [self addSubview:_progressView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat originy = (self.frame.size.height - kImgViewHeight - kProgressViewHeight - kInnerPadding) / 2.0;
    
    _imgView.frame = CGRectMake((self.frame.size.width - kImgViewHeight) / 2.0,
                                originy,
                                kImgViewHeight,
                                kImgViewHeight);
    
    _progressView.frame = CGRectMake((self.frame.size.width - kProgressViewWidth) / 2.0,
                                     _imgView.frame.size.height + _imgView.frame.origin.y + kInnerPadding,
                                     kProgressViewWidth,
                                     kProgressViewHeight);
    
    
}

@end
