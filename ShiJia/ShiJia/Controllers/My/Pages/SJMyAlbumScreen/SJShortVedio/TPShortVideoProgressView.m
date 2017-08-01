//
//  TPShortVideoProgressView.m
//  HiTV
//
//  Created by yy on 15/10/28.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//

#import "TPShortVideoProgressView.h"

@interface TPShortVideoProgressView ()

@property (nonatomic, strong) IBOutlet UIImageView *progressImgView;
@property (nonatomic, strong) IBOutlet UIImageView *trackImgView;

@end

@implementation TPShortVideoProgressView

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupSubviews];
    
    self.trackTintColor = kColorBlueTheme;
    self.progressTintColor = [UIColor colorWithHexString:@"444442"];
}

#pragma mark - subviews
- (void)setupSubviews
{
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    
    //add subview
    [self addSubview:self.progressImgView];
    [self.progressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self addSubview:self.trackImgView];
    [self.trackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        
    }];
    
    //init data
    self.progress = 0;
}

#pragma mark - setter
- (void)setProgressImage:(UIImage *)progressImage
{
    _progressImage = progressImage;
    self.progressImgView.image = progressImage;
}

- (void)setTrackImage:(UIImage *)trackImage
{
    _trackImage = trackImage;
    self.trackImgView.image = trackImage;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    self.progressImgView.image = nil;
    self.progressImgView.backgroundColor = progressTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    self.trackImgView.image = nil;
    self.trackImgView.backgroundColor = trackTintColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    if (progress < 0) {
        _progress = 0;
    }
    if (progress > 1) {
        _progress =  1;
    }
    
    //update constraints
    CGFloat width = self.frame.size.width * progress;
    [self.trackImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    [self setProgress:progress];
    
    //动画
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNeedsLayout];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - getter
- (UIImageView *)progressImgView
{
    if (_progressImgView == nil) {
        _progressImgView = [[UIImageView alloc] init];
        _progressImgView.backgroundColor = [UIColor colorWithHexString:@"444442"];
    }
    return _progressImgView;
}

- (UIImageView *)trackImgView
{
    if (_trackImgView == nil) {
        _trackImgView = [[UIImageView alloc] init];
        _trackImgView.backgroundColor = kColorBlueTheme;
    }
    
    return _trackImgView;
}

@end
