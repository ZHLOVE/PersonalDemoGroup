//
//  HotspotViewCell.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/22.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "HotspotViewCell.h"

@interface HotspotViewCell ()


@end

@implementation HotspotViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _topBgView = [[UIImageView alloc] init];
    _topBgView.backgroundColor = [UIColor blackColor];
    [self.mainImageView addSubview:_topBgView];
    
    _bottomBgView = [[UIImageView alloc] init];
    _bottomBgView.backgroundColor = [UIColor blackColor];
    [self.mainImageView addSubview:_bottomBgView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.numberOfLines = 0;
    [self.mainImageView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.mainImageView addSubview:_timeLabel];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _mainImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-50);
    _topBgView.frame = CGRectMake(0, 0, self.bounds.size.width, 50);
    //_titleLabel.frame = CGRectMake(15, 0, _topBgView.bounds.size.width-30, _topBgView.frame.size.height);
    CGSize maximumSize = CGSizeMake(_topBgView.bounds.size.width-30, 9999);
    NSString *dateString = _titleLabel.text;
    UIFont *dateFont = [UIFont boldSystemFontOfSize:18];
    CGSize dateStringSize = [dateString sizeWithFont:dateFont
                                   constrainedToSize:maximumSize
                                       lineBreakMode:NSLineBreakByWordWrapping];
    float h = dateStringSize.height;
    if (h>_topBgView.frame.size.height) {
        h = _topBgView.frame.size.height;
    }
    CGRect dateFrame = CGRectMake(15, 10, _topBgView.bounds.size.width-30, h);
    _titleLabel.frame = dateFrame;
    
    _bottomBgView.frame = CGRectMake(0, self.mainImageView.bounds.size.height-40, self.bounds.size.width, 42);
    _timeLabel.frame = CGRectMake(_bottomBgView.frame.size.width-100, self.mainImageView.frame.size.height-25, 90, 20);

    [self addTopGradientInBackgroundView];
    [self addBottomGradientInBackgroundView];

}
-(IBAction)share{
    if (self.m_delegate) {
        [self.m_delegate shareCurrentVideo:self.hotsVideoModel];
    }
}
- (void)addTopGradientInBackgroundView
{
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)   alpha:0.0];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.25];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.8];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.5),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = _topBgView.bounds;
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(0, 0);
    _topBgView.layer.mask = gradientLayer;
}
- (void)addBottomGradientInBackgroundView
{
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)   alpha:0.8];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.25];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.00];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.5),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = _bottomBgView.bounds;
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(0, 0);
    _bottomBgView.layer.mask = gradientLayer;
}
/*-(void)setShowDetail:(BOOL)showDetail{
    if (showDetail) {
        self.detailView.hidden = NO;
    }
    else{
        self.detailView.hidden = YES;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.detailView.frame = self.mainImageView.bounds;
    self.detailView.center = self.mainImageView.center;
}
-(HotDetailView *)detailView{
    if (!_detailView) {
        _detailView = [[[NSBundle mainBundle] loadNibNamed:@"HotDetailView" owner:self options:nil] firstObject];
        WEAKSELF
        [_detailView setDidClickButtonAtIndex:^(NSInteger index){
            if (index == 0) {
                [weakSelf.m_delegate playDetailVideo];
                weakSelf.detailView.hidden = YES;
            }
            else{
                [weakSelf.m_delegate replayCurrentVideo];
                weakSelf.detailView.hidden = YES;
            }
        }];
        _detailView.hidden = YES;
        [self addSubview:_detailView];
    }
    return _detailView;
}*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
