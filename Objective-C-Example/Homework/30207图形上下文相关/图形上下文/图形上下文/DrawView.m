//
//  DrawView.m
//  图形上下文
//
//  Created by student on 16/4/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //第一条线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, 125)];
    [path addLineToPoint:CGPointMake(240, 125)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, 10);
    [[UIColor blueColor]set];
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
    [[UIColor yellowColor] set];
    CGContextStrokePath(ctx);
    
    // 第三条线
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, 10)];
    [path addLineToPoint:CGPointMake(240, 240)];
    CGContextAddPath(ctx, path.CGPath);
    // 还原前一次保存的上下文状态
//    CGContextRestoreGState(ctx);
    CGContextStrokePath(ctx);
  
}


@end
