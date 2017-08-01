//
//  SJMessageVideoView.m
//  ShiJia
//
//  Created by yy on 16/6/23.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMessageVideoView.h"

CGFloat const kSJMessageVideoViewHeight = 160.0;

static CGFloat kLabelWidth = 30.0;
static CGFloat kLabelHeight = 20.0;
static CGFloat kPosterImgViewWidth = 90.0;
static CGFloat kInnerPadding = 10.0;
static CGFloat kIconImgViewWidth = 50.0;

@interface SJMessageVideoView ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *posterImgView;
@property (nonatomic, strong) UILabel *videoNameLabel;
@property (nonatomic, strong) UILabel *directorLabel;
@property (nonatomic, strong) UILabel *actorLabel;
@property (nonatomic, strong) UIButton *playButton;
@end

@implementation SJMessageVideoView
{
    UILabel *directorTitleLabel;
    UILabel *actorTitleLabel;
//    UIImageView *playImgView;
}

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
    
        // main view
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 2.0;
        _mainView.layer.masksToBounds = YES;
        [self addSubview:_mainView];
        

        // 海报
        _posterImgView = [[UIImageView alloc] init];
        _posterImgView.contentMode = UIViewContentModeScaleAspectFill;
        _posterImgView.clipsToBounds = YES;
//        _posterImgView.image = [UIImage imageNamed:@"default_image"];
        [_mainView addSubview:_posterImgView];
        
        
        // video name
        _videoNameLabel = [[UILabel alloc] init];
        _videoNameLabel.backgroundColor = [UIColor clearColor];
        _videoNameLabel.font = [UIFont systemFontOfSize:14.0];
        _videoNameLabel.textColor = [UIColor darkGrayColor];
//        _videoNameLabel.text = @"本杰明巴顿";
        [_mainView addSubview:_videoNameLabel];
        
        
        directorTitleLabel = [[UILabel alloc] init];
        directorTitleLabel.backgroundColor = [UIColor clearColor];
        directorTitleLabel.font = [UIFont systemFontOfSize:13.0];
        directorTitleLabel.textColor = kColorBlueTheme;
        directorTitleLabel.text = @"导演";
        [_mainView addSubview:directorTitleLabel];
        
        
        _directorLabel = [[UILabel alloc] init];
        _directorLabel.backgroundColor = [UIColor clearColor];
        _directorLabel.font = [UIFont systemFontOfSize:13.0];
        _directorLabel.textColor = [UIColor darkGrayColor];
//        _directorLabel.text = @"斯皮尔伯格";
        [_mainView addSubview:_directorLabel];
        
        
        
        actorTitleLabel = [[UILabel alloc] init];
        actorTitleLabel.backgroundColor = [UIColor clearColor];
        actorTitleLabel.font = [UIFont systemFontOfSize:13.0];
        actorTitleLabel.textColor = kColorBlueTheme;
        actorTitleLabel.text = @"主演";
        [_mainView addSubview:actorTitleLabel];
                
        
        _actorLabel = [[UILabel alloc] init];
        _actorLabel.backgroundColor = [UIColor clearColor];
        _actorLabel.font = [UIFont systemFontOfSize:13.0];
        _actorLabel.textColor = [UIColor darkGrayColor];
        [_mainView addSubview:_actorLabel];
//        _actorLabel.text = @"布拉德皮特";
        
        
    
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"message_detail_play_btn"] forState:UIControlStateNormal];
        _playButton.alpha = 0.7;
        [_mainView addSubview:_playButton];
//        playImgView = [[UIImageView alloc] init];
//        playImgView.image = [UIImage imageNamed:@"message_detail_play_btn"];
//        playImgView.alpha = 0.7;
//        [_posterImgView addSubview:playImgView];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mainView.frame = CGRectMake(kInnerPadding,
                                 kInnerPadding,
                                 self.frame.size.width - kInnerPadding * 2,
                                 self.frame.size.height - kInnerPadding * 2);
    
    
    _posterImgView.frame = CGRectMake(kInnerPadding,
                                      kInnerPadding,
                                      kPosterImgViewWidth,
                                      _mainView.frame.size.height - kInnerPadding * 2);
    
    CGFloat nameOriginx = _posterImgView.frame.origin.x + _posterImgView.frame.size.width + kInnerPadding;
    _videoNameLabel.frame = CGRectMake(nameOriginx,
                                       kInnerPadding,
                                       _mainView.frame.size.width - nameOriginx - kInnerPadding,
                                       kLabelHeight);
    
    
    directorTitleLabel.frame = CGRectMake(nameOriginx,
                                          _videoNameLabel.frame.origin.y + _videoNameLabel.frame.size.height + kInnerPadding,
                                          kLabelWidth,
                                          kLabelHeight);
    
    CGFloat directorOriginx = directorTitleLabel.frame.origin.x + directorTitleLabel.frame.size.width + kInnerPadding;
    _directorLabel.frame = CGRectMake(directorOriginx,
                                      _videoNameLabel.frame.origin.y + _videoNameLabel.frame.size.height + kInnerPadding,
                                      _mainView.frame.size.width - directorOriginx - kInnerPadding,
                                      kLabelHeight);
    
    actorTitleLabel.frame = CGRectMake(nameOriginx,
                                       directorTitleLabel.frame.origin.y + directorTitleLabel.frame.size.height + kInnerPadding,
                                       kLabelWidth,
                                       kLabelHeight);
    
    CGFloat actorOriginx = actorTitleLabel.frame.origin.x + actorTitleLabel.frame.size.width + kInnerPadding;
    _actorLabel.frame = CGRectMake(actorOriginx,
                                   _directorLabel.frame.origin.y + _directorLabel.frame.size.height + kInnerPadding,
                                   _mainView.frame.size.width - actorOriginx - kInnerPadding,
                                   kLabelHeight);
    
    _playButton.frame = CGRectMake((_posterImgView.frame.size.width - kIconImgViewWidth) / 2.0 + kInnerPadding,
                                   (_posterImgView.frame.size.height - kIconImgViewWidth) / 2.0 + kInnerPadding,
                                   kIconImgViewWidth,
                                   kIconImgViewWidth);

}

#pragma mark - Setter & Getter
- (void)setPosterImgUrl:(NSString *)posterImgUrl
{
    _posterImgUrl = posterImgUrl;
    
    if (posterImgUrl == nil) {
        
//        _posterImgView.image = [UIImage imageNamed:@"default_image"];
        _posterImgView.backgroundColor = kColorLightGrayBackground;
    }
    else{
        _posterImgView.backgroundColor = [UIColor clearColor];
        [_posterImgView setImageWithURL:[NSURL URLWithString:posterImgUrl] placeholder:[UIImage imageNamed:@"default_image"]];
    }
    
}

- (void)setActor:(NSString *)actor
{
    _actor = actor;
    if (actor.length == 0 || [actor isEqualToString:@"null"]) {
        actorTitleLabel.hidden = YES;
    }
    else{
        actorTitleLabel.hidden = NO;
        _actorLabel.text = actor;
    }
    
}

- (void)setDirector:(NSString *)director
{
    _director = director;
    if (director.length == 0 || [director isEqualToString:@"null"]) {
        directorTitleLabel.hidden = YES;
    }
    else{
        directorTitleLabel.hidden = NO;
        _directorLabel.text = director;
    }

}

- (void)setProgramName:(NSString *)programName
{
    _programName = programName;
    _videoNameLabel.text = programName;
}

- (RACSignal *)playSignal
{
    return [_playButton rac_signalForControlEvents:UIControlEventTouchUpInside];
}

@end
