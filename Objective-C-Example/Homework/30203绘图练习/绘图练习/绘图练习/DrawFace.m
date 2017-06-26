//
//  DrawFace.m
//  绘图练习
//
//  Created by student on 16/4/6.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DrawFace.h"

@implementation DrawFace


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self drawFace2];
}

- (void)drawFace1
{
    //脸轮廓
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 50, 300,300) cornerRadius:150];
    [[UIColor blueColor] setStroke];
    path.lineWidth = 5;
    [path stroke];
    //左眼睛
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 150, 30,30) cornerRadius:15];
    [[UIColor blueColor] setStroke];
    path2.lineWidth = 5;
    [path2 stroke];
    //右眼睛
    UIBezierPath *path3 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(220, 150, 30,30) cornerRadius:15];
    [[UIColor blueColor] setStroke];
    path3.lineWidth = 5;
    [path3 stroke];
    //弧线
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 100, 280);
    CGContextAddQuadCurveToPoint(ctx, 180, 360, 255, 280);// 控制点的xy 终点的xy
    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(ctx, 5);
    CGContextStrokePath(ctx);// 绘制线
    
}

- (void)drawFace2
{
    //脸轮廓
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 50, 300,300) cornerRadius:150];
    [[UIColor blueColor] setStroke];
    path.lineWidth = 5;
    [path stroke];
    //左眼睛
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 150, 30,30) cornerRadius:15];
    [[UIColor blueColor] setStroke];
    path2.lineWidth = 5;
    [path2 stroke];
    //右眼睛
    UIBezierPath *path3 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(220, 150, 30,30) cornerRadius:15];
    [[UIColor blueColor] setStroke];
    path3.lineWidth = 5;
    [path3 stroke];
    //弧线
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 100, 280);
    CGContextAddQuadCurveToPoint(ctx, 180, 200, 255, 280);// 控制点的xy 终点的xy
    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(ctx, 5);
    CGContextStrokePath(ctx);// 绘制线
    
}




@end
