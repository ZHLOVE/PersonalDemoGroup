//
//  DrawView.m
//  scoreViewDemo
//
//  Created by wukeng-mac on 16/6/29.
//  Copyright © 2016年 wukeng-mac. All rights reserved.
//

#import "DrawView.h"
#define kLineWidth 4

@interface DrawView()


@property (nonatomic,strong) CAShapeLayer *lineLayer;//灰色背景条
@property (nonatomic, strong) CAShapeLayer *progresslayer;
@property (nonatomic, strong) UILabel *scoreLable;
@end

@implementation DrawView

-(void)setPrecent:(CGFloat)precent{
    _precent = precent;
    [self setNeedsDisplay];
}
-(UILabel *)scoreLable{
    if (_scoreLable == nil) {
        _scoreLable = [[UILabel alloc] init];
        [self addSubview:self.scoreLable];
    }
    return _scoreLable;
}
- (void)drawRect:(CGRect)rect {
    if(_lineLayer == nil){
        [self buildGrayLayer];
    }
    [self.progresslayer removeFromSuperlayer];
    [self buildGreenLayer];
    [self buildLabel];
}
//构建进度图背景的灰色layer
-(void)buildGrayLayer{
    UIBezierPath *lineRect = [UIBezierPath bezierPath];
    [lineRect moveToPoint:CGPointMake(0, 50)];
    [lineRect addLineToPoint:CGPointMake(self.frame.size.width, 50)];
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.path = lineRect.CGPath;
    self.lineLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.lineLayer.lineWidth = kLineWidth;
    [self.layer addSublayer:self.lineLayer];
}
//构建评分的绿色View
-(void)buildGreenLayer{
    self.progresslayer = [CAShapeLayer layer];
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath moveToPoint:CGPointMake(0, 50)];
    [progressPath addLineToPoint:CGPointMake(self.precent * self.frame.size.width, 50)];
    self.progresslayer.path = progressPath.CGPath;
    self.progresslayer.strokeColor = [UIColor blueColor].CGColor;
    self.progresslayer.lineWidth = kLineWidth * 1.5;
    [self.layer addSublayer:self.progresslayer];
    [self startAnimation];
}

//添加动画
- (void)startAnimation{
    CABasicAnimation *lineBasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    [lineBasicAnimation setFromValue:@0];
    [lineBasicAnimation setToValue:@1];
    [lineBasicAnimation setDuration:1.0];
    [lineBasicAnimation setFillMode:kCAFillModeForwards];
    [self.progresslayer addAnimation:lineBasicAnimation forKey:@"line"];

}
//构建label
-(void)buildLabel{
    self.scoreLable.bounds = CGRectMake(0, 0, self.bounds.size.width - kLineWidth, self.bounds.size.width - kLineWidth);
    self.scoreLable.layer.masksToBounds = YES;
    self.scoreLable.layer.cornerRadius = (self.bounds.size.width - kLineWidth)/2;
    self.scoreLable.layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.scoreLable.backgroundColor = [UIColor clearColor];
    self.scoreLable.text = [NSString stringWithFormat:@"%.0f",self.precent*100];
    [self.scoreLable setTextColor:[UIColor greenColor]];
    [self.scoreLable setTextAlignment:NSTextAlignmentCenter];
    [self.scoreLable setFont:[UIFont systemFontOfSize:25]];
}
@end
