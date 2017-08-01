//
//  SJVideoToolView.m
//  ShiJia
//
//  Created by yy on 16/6/15.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoToolView.h"


static CGFloat kScreenButtonWidth = 90.0;
static CGFloat kShareButtonWidth = 70.0;
static CGFloat kButtonHeight = 30.0;

@interface SJVideoToolView ()

@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIButton *screenButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *starButton;


@end

@implementation SJVideoToolView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _backImgView = [[UIImageView alloc] init];
        _backImgView.backgroundColor = [UIColor colorWithHexString:@"444444"];
        [self addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(0);
            make.right.equalTo(self).with.offset(0);
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
        }];
        
        
        _screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_screenButton setImage:[UIImage imageNamed:@"player_screen_btn"] forState:UIControlStateNormal];
        [_screenButton setTitle:@"  电视播放" forState:UIControlStateNormal];
        [_screenButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_screenButton addTarget:self action:@selector(screenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_screenButton setBackgroundColor:[UIColor clearColor]];
        _screenButton.layer.cornerRadius = 15.0;
        _screenButton.layer.masksToBounds = YES;
        [self addSubview:_screenButton];
        [_screenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.centerY.equalTo(self).with.offset(0);
            make.width.mas_equalTo(kScreenButtonWidth);
            make.height.mas_equalTo(kButtonHeight);
        }];
        
        _starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_starButton setImage:[UIImage imageNamed:@"player_unstar_btn"] forState:UIControlStateNormal];
        [_starButton setTitle:@"  收藏" forState:UIControlStateNormal];
        [_starButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_starButton];
        [_starButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.centerY.equalTo(self).with.offset(0);
            make.width.mas_equalTo(kShareButtonWidth);
            make.height.mas_equalTo(kButtonHeight);
        }];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"player_share_btn"] forState:UIControlStateNormal];
        [_shareButton setTitle:@"  分享" forState:UIControlStateNormal];
        [_shareButton sizeToFit];
        [_shareButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
        [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_starButton.mas_left);
            make.centerY.equalTo(self).with.offset(0);
//            make.width.mas_equalTo(kScreenButtonWidth);
//            make.height.mas_equalTo(kButtonHeight);
        }];
        
        
    }
    
    return self;
    
}



#pragma mark - Event
- (void)screenButtonClicked:(id)sender
{
    if (!self.screened) {
        
        // 电视投屏
        if ([self.delegate respondsToSelector:@selector(toolViewDidStartScreeningVideo:)]) {
            [self.delegate toolViewDidStartScreeningVideo:self];
        }
    }
    else{
        
        // 取消投屏
        if ([self.delegate respondsToSelector:@selector(toolViewDidCancelScreen:)]) {
            [self.delegate toolViewDidCancelScreen:self];
        }
    }
}

- (IBAction)shareButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(toolViewDidStartShareVideo:)]) {
        [self.delegate toolViewDidStartShareVideo:self];
    }

}

- (IBAction)starButtonClicked:(id)sender
{
    if (!self.collected) {
        
        // 收藏
        if ([self.delegate respondsToSelector:@selector(toolViewDidStartCollectingVideo:)]) {
            [self.delegate toolViewDidStartCollectingVideo:self];
        }
    }
    else{
        
        // 取消收藏
        if ([self.delegate respondsToSelector:@selector(toolViewDidCancelCollectVideo:)]) {
            [self.delegate toolViewDidCancelCollectVideo:self];
        }
    }
}

#pragma mark - Setter & Getter
- (void)setScreened:(BOOL)screened
{
    _screened = screened;
    if (screened) {
        [_screenButton setImage:[UIImage imageNamed:@"player_screen_phone_btn"] forState:UIControlStateNormal];
        if (_isTVPlay) {
            [_screenButton setTitle:@"  停止播放" forState:UIControlStateNormal];
        }else{
            [_screenButton setTitle:@"  手机播放" forState:UIControlStateNormal];
        }
    }
    else{
        [_screenButton setImage:[UIImage imageNamed:@"player_screen_btn"] forState:UIControlStateNormal];
        [_screenButton setTitle:@"  电视播放" forState:UIControlStateNormal];
        
    }

}

- (void)setCollected:(BOOL)collected
{
    _collected = collected;
    if (collected) {
        [_starButton setImage:[UIImage imageNamed:@"player_stared_btn"] forState:UIControlStateNormal];
        [_starButton setTitleColor:RGB(254, 203, 47, 1) forState:UIControlStateNormal];
        [_starButton setTitle:@"  收藏" forState:UIControlStateNormal];
    }
    else{
        [_starButton setImage:[UIImage imageNamed:@"player_unstar_btn"] forState:UIControlStateNormal];
        [_starButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_starButton setTitle:@"  收藏" forState:UIControlStateNormal];
    }

}
@end
