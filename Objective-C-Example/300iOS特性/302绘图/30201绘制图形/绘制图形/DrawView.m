//
//  DrawView.m
//  绘制图形
//
//  Created by niit on 16/4/6.
//  Copyright © 2016年 NIIT. All rights reserved.
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

//    [self drawGraphicsA];
      [self drawGraphicsYuan];
//    [self drawGraphics1];
//    [self drawGraphics2];
//    [self drawGraphics3];
//    [self drawGraphics4];
//    [self drawGraphics5];
//    [self drawGraphics6];
//    [self drawGraphics7];
//    [self drawGraphics8];
//    [self drawGraphics9];
}

//画绿点
- (void)drawGraphicsA
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGFloat X = self.letfTop.x;
//    CGFloat Y = self.letfTop.y;
//    CGFloat W = self.rightBottom.x - self.letfTop.x;
//    CGFloat H = self.rightBottom.y - self.letfTop.y;
//    CGContextAddRect(ctx, CGRectMake(X,Y,W,H));
    UIColor *testColor = [UIColor greenColor];
    //(上下文，圆心x,圆心y,半径，开始弧度，结束弧度，绘制方向)
    CGContextAddArc(ctx, 150, 30, 5, 0, M_PI * 2.0, 0);//添加一个圆
    CGContextSetFillColorWithColor(ctx, testColor.CGColor);//填充颜色
    CGContextDrawPath(ctx, kCGPathFill);//仅填充

}

//画圆
- (void)drawGraphicsYuan
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //(上下文，圆心x,圆心y,半径，开始弧度，结束弧度，绘制方向)
    CGContextAddArc(ctx, 150, 90, 5, 0, M_PI * 2.0, 0);//添加一个圆
    CGContextSetLineWidth(ctx, 1);  //边宽
    CGContextSetRGBStrokeColor(ctx,1,1,1,1.0);//画笔线的颜色
    CGContextDrawPath(ctx, kCGPathStroke);//仅填充
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    imgView.frame = CGRectMake(100, 100, 10, 10);
    [self addSubview:imgView];
}

#pragma mark - 绘制扇形
- (void)drawGraphics9
{
    //1.取出上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.设置路径
    CGRect rect = CGRectMake(50, 50, 10, 10);
    UIRectFrame(rect);
    CGContextAddEllipseInRect(context, rect);
    //3.绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawGraphics8
{
    UIBezierPath *path = [UIBezierPath  bezierPath];
    
    [path moveToPoint:CGPointMake(125, 125)];
    // 中心点 半径 起始角度 终止角度 顺逆方向
    [path addArcWithCenter:CGPointMake(125, 125) radius:100 startAngle:0 endAngle:M_PI_2 clockwise:YES];
    // 封闭路径
    [path closePath];
    [[UIColor whiteColor] setStroke];
    path.lineWidth = 5;
    [path stroke];// 绘制边线
    [path fill];// 绘制填充
    
}

#pragma mark - 绘制圆角矩形
- (void)drawGraphics7
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 50, 200,200) cornerRadius:100];
    [[UIColor yellowColor] setStroke];
    [[UIColor greenColor] setFill];
    path.lineWidth = 50;
    [path stroke];
    [path fill];
}

#pragma mark - 绘制QuadCurve曲线
- (void)drawGraphics6
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 50, 200);
    CGContextAddQuadCurveToPoint(ctx, 150, 250, 250, 200);// 控制点的xy 终点的xy
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];
//    CGContextStrokePath(ctx);// 绘制线
    CGContextClosePath(ctx);//封闭路径
    CGContextFillPath(ctx);// 绘制填充
    
}
#pragma mark - 方式三 绘制的一些设置
- (void)drawGraphics5
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
    [path addLineToPoint:CGPointMake(50, 100)];
    path.lineWidth = 10;
    [[UIColor greenColor] setStroke];
    [path stroke];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(50, 100)];
    [path2 addLineToPoint:CGPointMake(50, 150)];
    path2.lineWidth = 10;
    [[UIColor yellowColor] setStroke];
    [path2 stroke];
}

#pragma mark - 方式二 绘制的一些设置
- (void)drawGraphics4
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
  
    CGContextMoveToPoint(ctx, 50, 50);
    CGContextAddLineToPoint(ctx, 100, 50);
    CGContextAddLineToPoint(ctx, 100, 100);
    
    // 设置当前stroke颜色
    [[UIColor redColor] setStroke];
    
    // 线宽
    CGContextSetLineWidth(ctx, 10);
    // 线的接头的地方样式
    CGContextSetLineJoin(ctx, kCGLineJoinBevel);
//    kCGLineJoinMiter 直角
//    kCGLineJoinRound 圆角
//    kCGLineJoinBevel 缺角
    
    CGContextStrokePath(ctx);
}

#pragma mark - 方式3：UIKit里封装的绘图功能(OC类)
- (void)drawGraphics3
{
    // 贝塞尔路径
    
    // 1. 创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
    [path addLineToPoint:CGPointMake(250, 200)];
    // 2. 绘制路径
    [path stroke];
}

#pragma mark - 方式2: 在图形上下文中添加路径(省略了创建路径)
- (void)drawGraphics2
{
    // 1. 得到图形上下文 (得到当前UIView对应的绘图环境)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2. 添加路径
    CGContextMoveToPoint(ctx, 50, 50);
    CGContextAddLineToPoint(ctx, 150, 200);
    // 3. 绘制出来(渲染)
    CGContextStrokePath(ctx);
}

#pragma mark - 方法1: 在图形上下添加路径
- (void)drawGraphics1
{
    // 1. 得到图形上下文 (得到当前UIView对应的绘图环境)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    // 2. 添加路径
//    CGMutablePathRef path = CGPathCreateMutable();
//    // 移动到某点
//    CGPathMoveToPoint(path, NULL, 5, 5);
//    // 画条线到某点
//    CGPathAddLineToPoint(path, NULL, 25, 5);

    CGContextAddRect(ctx, CGRectMake(5, 5, 150, 200));

    // 3. 把路径添加到图形上下文中
//    CGContextAddPath(ctx, path);

    // 4. 绘制出来(渲染)
    CGContextStrokePath(ctx);
}

- (void)drawGraphics11
{
    // 1. 得到图形上下文 (得到当前UIView对应的绘图环境)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2. 添加路径
    CGMutablePathRef path = CGPathCreateMutable();
    // 移动到某点
    CGPathMoveToPoint(path, NULL, 5, 5);
    // 画条线到某点
    CGPathAddLineToPoint(path, NULL, 25, 5);

    // 3. 把路径添加到图形上下文中
    CGContextAddPath(ctx, path);

    // 4. 绘制出来(渲染)
    CGContextStrokePath(ctx);
}



@end
