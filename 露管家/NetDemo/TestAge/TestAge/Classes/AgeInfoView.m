//
//  AgeInfoView.m
//  TestAge
//
//  Created by niit on 16/4/12.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AgeInfoView.h"

@interface AgeInfoView()

@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation AgeInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];//
        self.alpha = 0.9;
        
    }
    return self;
}

- (UIImageView *)imageView
{
    if(_imageView == nil)
    {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)ageLabel
{
    if(_ageLabel==nil)
    {
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.font = [UIFont systemFontOfSize:120];
        _ageLabel.textColor = [UIColor orangeColor];
        _ageLabel.adjustsFontSizeToFitWidth = YES;
        _ageLabel.minimumScaleFactor = 0.1;
        _ageLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:_ageLabel];
    }
    return _ageLabel;
}

- (void)setAge:(int)age
{
    _age  = age;
    self.ageLabel.text = [NSString stringWithFormat:@"%i",age];
}

- (void)setMale:(BOOL)male
{
    _male = male;
    self.imageView.image =  [UIImage imageNamed:male ? @"icon-gender-male" : @"icon-gender-female"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.imageView.frame = CGRectMake(0, 0, width/3, height*4/5);
    self.ageLabel.frame = CGRectMake(width/3, 0, width*2/3, height*4/5);
    
}

- (void)drawRect:(CGRect)rect
{
    // 绘制背景
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor yellowColor] set];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, width, 0);
    CGContextAddLineToPoint(ctx, width, height*4/5);
    CGContextAddLineToPoint(ctx, width/2+width/6, height*4/5);
    CGContextAddLineToPoint(ctx, width/2, height);    
    CGContextAddLineToPoint(ctx, width/2-width/6, height*4/5);
    CGContextAddLineToPoint(ctx, 0, height*4/5);

    
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFill);
}
@end

