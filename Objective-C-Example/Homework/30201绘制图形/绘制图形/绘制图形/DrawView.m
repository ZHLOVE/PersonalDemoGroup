//
//  DrawView.m
//  绘制图形
//
//  Created by student on 16/4/6.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

// 图形上下文:
// 是一个CGContextRef类型的数据

// 图形上下文的作用:
// 1. 保存绘图信息、绘图状态
// 2. 决定绘制的输出目标
// 关于图形上下文:
//1. 当一个UIVIew需要执行绘图操作的时， drawRect:方法就会被调用。当drawRect：方法被调用，当前图形上下文也被设置为属于视图的图形上下文。你可以使用Core Graphics或UIKit提供的方法将图形画到该上下文中
//2. 上下文中有一块区域用来保存绘图信息，有一块区域用来保存绘图的状态（线宽，圆角，颜色）。直线不是直接绘制到view上的，可以理解为在图形上下文中有一块单独的区域用来先绘制图形，当调用渲染方法的时候，再把绘制好的图形显示到view上去。
//3. 如果你想调用drawRect：方法更新视图，只需发送setNeedsDisplay方法。这将使得drawRect：方法会在下一个适当的时间调用。
//4. 在UIView子类的drawRect：方法中无需调用super，因为本身UIView的drawRect：方法是空的。为了提高一些绘图性能，你可以调用setNeedsDisplayInRect：方法重新绘制视图的子区域，而视图的其他部分依然保持不变。
//5、触发视图更新的动作有:
//* 遮挡当前视图的视图被移动或删除
//* 当前视图被显示,或隐藏
//* 显式调用setNeedDisplay或者setNeedDisplayInrect: 方法

- (void)drawRect:(CGRect)rect {
//    [self drawGraphics1];
//    [self drawGraphics2];
    [self drawGraphics3];
//    [self drawGraphics4];
//    [self drawGraphics5];
//    [self drawGraphics6];
//    [self drawGraphics7];
//    [self drawGraphics8];
}
#pragma mark - 绘制扇形
- (void)drawGraphics8{
    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(125, 125)];
    //中心点 半径 起始角度 终止角度 顺逆方向
    [path addArcWithCenter:CGPointMake(125, 125) radius:100 startAngle:0 endAngle:M_PI_2 clockwise:YES];
    //封闭路径
//    [path closePath];
    [[UIColor whiteColor]setStroke];
    path.lineWidth = 8;
    [path stroke];//绘制边线
//    [path fill];//绘制填充
}
#pragma mark - 绘制圆角矩形
- (void)drawGraphics7{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 50, 200, 200) cornerRadius:30];
    [[UIColor yellowColor]setStroke];
    [[UIColor greenColor]setFill];
    path.lineWidth = 10;
    [path stroke];
//    [path fill];
}
#pragma mark - 绘制QuadCurve曲线
- (void)drawGraphics6{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 50, 200);
    CGContextAddQuadCurveToPoint(ctx, 150, 250, 250, 200);//控制点的xy 终点的xy
    [[UIColor redColor] setStroke];
//    [[UIColor redColor] setFill];
    CGContextStrokePath(ctx);// 绘制线
//    CGContextClosePath(ctx);//封闭路径
//    CGContextFillPath(ctx);// 绘制填充默认黑色

}

#pragma mark - 方式三 绘制的一些设置
- (void)drawGraphics5{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
    [path addLineToPoint:CGPointMake(50, 100)];
    path.lineWidth = 5;
    [[UIColor greenColor] setStroke];
    [path stroke];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(50, 100)];
    [path2 addLineToPoint:CGPointMake(50, 150)];
    path2.lineWidth = 6;
    [[UIColor blueColor]setStroke];
    [path2 stroke];
}

#pragma mark - 方式二 绘制的一些设置
- (void)drawGraphics4{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 50, 50);
    CGContextAddLineToPoint(ctx, 100, 50);
    CGContextAddLineToPoint(ctx, 100, 100);
    //设置当前stroke颜色
    [[UIColor redColor]setStroke];
    //线宽
    CGContextSetLineWidth(ctx, 5);
    //线的接头方式
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    //    kCGLineJoinMiter 直角
    //    kCGLineJoinRound 圆角
    //    kCGLineJoinBevel 缺角
    CGContextStrokePath(ctx);
}




#pragma mark - 方式3：UIKit里封装的绘图功能(OC类)
- (void)drawGraphics3{
    //贝塞尔路径
    //创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];//起点
    [path addLineToPoint:CGPointMake(250, 200)];//终点
    //渲染绘制
    [[UIColor greenColor] setStroke];
    [path stroke];
}

#pragma mark - 方式2: 在图形上下文中添加路径(省略了创建路径)
- (void)drawGraphics2{
    //1得到图形上下文(得到当前UIView对应的绘图环境)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2添加路径
    CGContextMoveToPoint(ctx, 50, 50);
    CGContextAddLineToPoint(ctx, 150, 200);
    //3绘制出来
    CGContextStrokePath(ctx);
}
#pragma mark - 方法1: 在图形上下文添加路径

- (void)drawGraphics1{
    //1得到图形上下文(得到当前UIView对应的绘图环境)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2添加路径
    CGMutablePathRef path = CGPathCreateMutable();
    //移动到某点
    CGPathMoveToPoint(path, NULL, 50, 50);
    //画条线到某点
    CGPathAddLineToPoint(path, NULL, 200, 200);
    //3把路径添加到图形上下文中
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
}


















@end
