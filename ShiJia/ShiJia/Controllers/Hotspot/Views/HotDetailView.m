//
//  HotDetailView.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/24.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "HotDetailView.h"
@interface HotDetailView ()
@property (weak, nonatomic)  IBOutlet UIButton *playDetailBtn;
@property (nonatomic, strong) UIImageView *topBackImgView;

@end
@implementation HotDetailView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _topBackImgView = [[UIImageView alloc] init];
    _topBackImgView.backgroundColor = [UIColor blackColor];
    [self.posterImg addSubview:_topBackImgView];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.7];
       // self.alpha = .5;
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    
    self.posterImg.clipsToBounds = NO;
    self.posterImg.layer.masksToBounds = YES;
    self.posterImg.layer.cornerRadius = 3.0;


    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.playDetailBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.playDetailBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.playDetailBtn.layer.mask = maskLayer;
    
    
    _topBackImgView.frame = self.titleLab.bounds;
    [self addTopGradientInBackgroundView];
}
-(void)setTipString:(NSString *)tipString{
    [self.playDetailBtn setTitle:tipString forState:UIControlStateNormal];
}
-(IBAction)playDetailVideo:(id)sender{
    if (self.didClickButtonAtIndex) {
        self.didClickButtonAtIndex(0);
    }
}
-(IBAction)replayCurrentVideo:(id)sender{
    if (self.didClickButtonAtIndex) {
        self.didClickButtonAtIndex(1);
    }
}

- (void)addTopGradientInBackgroundView
{
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)   alpha:0.02];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.25];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.5];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.5),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = _topBackImgView.bounds;
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(0, 0);
    _topBackImgView.layer.mask = gradientLayer;
}
@end
