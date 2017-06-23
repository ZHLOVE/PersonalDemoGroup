//
//  ProgressView.m
//  下载进度
//
//  Created by niit on 16/4/6.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView


- (void)setProgress:(float)progress
{
    _progress = progress;
    
//    [self drawRect:self.bounds];// 错误
    
    // 重绘制
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat radius = rect.size.width / 2;
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = - M_PI_2 + self.progress * M_PI * 2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:center];
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path closePath];
    [[UIColor greenColor] set];
    
    [path fill];
    
}


@end
