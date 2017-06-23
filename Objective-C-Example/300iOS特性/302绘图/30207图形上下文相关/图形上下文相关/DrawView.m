//
//  DrawView.m
//  图形上下文相关
//
//  Created by niit on 16/4/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 第一条线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, 125)];
    [path addLineToPoint:CGPointMake(240, 125)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, 10);
    [[UIColor redColor] set];
    // 保存绘图上下文状态
    CGContextSaveGState(ctx);
    // 绘制
    CGContextStrokePath(ctx);
    
    // 第二条线
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(125, 10)];
    [path addLineToPoint:CGPointMake(125, 240)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, 20);
    [[UIColor blueColor] set];
    CGContextStrokePath(ctx);
    
    // 第三条线
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, 10)];
    [path addLineToPoint:CGPointMake(240, 240)];
    CGContextAddPath(ctx, path.CGPath);
    // 还原前一次保存的上下文状态
    CGContextRestoreGState(ctx);
    CGContextStrokePath(ctx);
    
    // 矩阵变换
    // 在添加路径之前
    CGContextTranslateCTM(ctx, 100, 50);
    CGContextScaleCTM(ctx, 0.5,0.5);
    CGContextRotateCTM(ctx, M_PI_4);
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-100, -50, 200, 100)];
    CGContextAddPath(ctx, path.CGPath);
    [[UIColor redColor] set];
    CGContextFillPath(ctx);
    
    
    
}


@end
