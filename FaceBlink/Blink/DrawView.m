//
//  DrawView.m
//  WingsBurning
//
//  Created by MBP on 16/9/7.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "DrawView.h"
#import "UIColor+HexColor.h"

@interface DrawView()


@end

@implementation DrawView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
 
- (void)drawRect:(CGRect)rect{
    for (NSValue *val in self.pointArray) {
        CGPoint point = [val CGPointValue];
        [self drawCircularDotWithPoint:point];
    }
    self.pointArray = nil;
}

//**画框*/
- (void)drawGraphics{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat X = self.letfTop.x;
    CGFloat Y = self.letfTop.y;
    CGFloat W = self.rightBottom.x - self.letfTop.x;
    CGFloat H = self.rightBottom.y - self.letfTop.y;
    CGContextAddRect(ctx, CGRectMake(X,Y,W,H));
    CGContextSetLineWidth(ctx, 1);    //  设置画线的宽度
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextDrawPath(ctx, kCGPathStroke);//画线
}


//**画点*/
- (void)drawCircularDotWithPoint:(CGPoint )point{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //(上下文，圆心x,圆心y,半径，开始弧度，结束弧度，绘制方向)
    UIColor *co = [UIColor colorWithHexString:@"#01c872"];
    CGContextAddArc(ctx, point.x, point.y, 2, 0, M_PI * 2.0, 0);//添加一个圆
    CGContextSetFillColorWithColor(ctx, co.CGColor);//填充颜色
    CGContextDrawPath(ctx, kCGPathFill);//仅填充
}






@end








