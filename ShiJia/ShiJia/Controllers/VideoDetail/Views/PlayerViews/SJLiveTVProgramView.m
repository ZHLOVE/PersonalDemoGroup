//
//  SJLiveTVProgramView.m
//  ShiJia
//
//  Created by yy on 16/6/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLiveTVProgramView.h"

CGFloat const kSJLiveTVProgramViewHeight = 90.0;
static CGFloat kLeftSpacing = 10.0;
static CGFloat kLineImgWidth = 10.0;
static CGFloat kLineImgHeight = 16.0;
static CGFloat kLineImgOriginx = 10.0;
static CGFloat kLabelHeight = 20.0;
static CGFloat kInnerPadding   = 10.0;
static CGFloat kMainViewHeight = 50.0;
static CGFloat kChannelImgViewHeight = 40.0;
static CGFloat kChannelNameWidth = 80.0;

@interface SJLiveTVProgramView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UIImageView *channelImgView;
@property (nonatomic, strong) IBOutlet UILabel *channelNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *programNameLabel;
@property (nonatomic, strong) UIImageView *lineImgView;


@end

@implementation SJLiveTVProgramView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
   
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _lineImgView = [[UIImageView alloc] init];
        //_line.backgroundColor = kColorBlueTheme;
        _lineImgView.image = [UIImage imageNamed:@"Triangle"];
        [self addSubview:_lineImgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"节目详情";
        [self addSubview:_titleLabel];
        
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 2.0;
        _mainView.layer.masksToBounds = YES;
        [self addSubview:_mainView];
        
        _channelImgView = [[UIImageView alloc] init];
        _channelImgView.contentMode = UIViewContentModeScaleAspectFit;
        _channelImgView.clipsToBounds = YES;
        [_mainView addSubview:_channelImgView];
        
        _channelNameLabel = [[UILabel alloc] init];
        _channelNameLabel.backgroundColor = [UIColor clearColor];
        _channelNameLabel.font = [UIFont systemFontOfSize:15.0];
        _channelNameLabel.textColor = [UIColor darkGrayColor];
        _channelNameLabel.adjustsFontSizeToFitWidth = YES;
        [_mainView addSubview:_channelNameLabel];
        
        _programNameLabel = [[UILabel alloc] init];
        _programNameLabel.font = [UIFont systemFontOfSize:15.0];
        _programNameLabel.backgroundColor = [UIColor clearColor];
        _programNameLabel.textColor = [UIColor darkGrayColor];
        [_mainView addSubview:_programNameLabel];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _lineImgView.frame = CGRectMake(kLineImgOriginx, kLeftSpacing + (kLabelHeight - kLineImgHeight) / 2.0, kLineImgWidth, kLineImgHeight);
    
    _titleLabel.frame = CGRectMake(_lineImgView.frame.origin.x + kLineImgWidth + kLeftSpacing,
                                   kInnerPadding,
                                   self.frame.size.width - 2 * kInnerPadding,
                                   kLabelHeight);
    
    _mainView.frame = CGRectMake(kInnerPadding,
                                 _titleLabel.origin.y + _titleLabel.frame.size.height + kInnerPadding,
                                 self.frame.size.width - 2 * kInnerPadding,
                                 kMainViewHeight);
    
    _channelImgView.frame = CGRectMake(kInnerPadding * 2,
                                       (_mainView.frame.size.height - kChannelImgViewHeight) / 2.0,
                                       kChannelImgViewHeight, kChannelImgViewHeight);
    
    
    
    _channelNameLabel.frame = CGRectMake(_channelImgView.frame.origin.x + _channelImgView.frame.size.width + kInnerPadding,
                                         (_mainView.frame.size.height -  kLabelHeight) / 2.0,
                                         kChannelNameWidth,
                                         kLabelHeight);
    
    CGFloat width = _mainView.frame.size.width - _channelNameLabel.frame.origin.x - _channelNameLabel.frame.size.width - kInnerPadding * 2;
    
    _programNameLabel.frame = CGRectMake(_channelNameLabel.frame.origin.x + kChannelNameWidth + kInnerPadding,
                                         _channelNameLabel.frame.origin.y,
                                         width,
                                         kLabelHeight);
}

#pragma mark - Setter

- (void)setChannelLogo:(NSString *)channelLogo
{
    _channelLogo = channelLogo;
    [_channelImgView setImageWithURL:[NSURL URLWithString:channelLogo] placeholderImage:[UIImage imageNamed:@"default_image"]];
}

- (void)setChannelName:(NSString *)channelName
{
    _channelName = channelName;
    _channelNameLabel.text = channelName;
    NSArray *channels = [NSUserDefaultsManager getObjectForKey:CHANNELLIST];
    if (_channelLogo.length == 0) {
        for (NSDictionary *dic in channels) {
            NSString *channelName = [dic objectForKey:@"channelName"];
            if ([channelName isEqualToString:_channelName]) {
                [_channelImgView setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:@"default_image"]];
                break;
            }
        }
    }
}

- (void)setProgramName:(NSString *)programName
{
    _programName = programName;
    _programNameLabel.text = programName;
}

@end
