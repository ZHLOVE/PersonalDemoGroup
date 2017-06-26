//
//  DrawView.m
//  画图
//
//  Created by student on 16/4/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DrawView.h"
#import "DrawLine.h"
@interface DrawView ()
// 当前绘制的路径
@property (nonatomic,strong) DrawLine *curPath;

// 路径数组
@property (nonatomic,strong) NSMutableArray *pathArr;
@end

@implementation DrawView

- (void)awakeFromNib
{
    self.curLineWidth = 1;
    self.curColor = [UIColor blackColor];
}

- (NSMutableArray *)pathArr{
    if (_pathArr == nil) {
        _pathArr = [NSMutableArray array];
    }
    return  _pathArr;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (DrawLine *path in self.pathArr) {
        [path.color set];
        [path stroke];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    // 1创建一个路径
    // 确定一个起点点
    self.curPath = [DrawLine bezierPath];
    self.curPath.lineWidth = self.curLineWidth; //线宽
    self.curPath.color = self.curColor;
    //2 添加到数组
     [self.pathArr addObject:self.curPath];
    // 3 设置起点
    [self.curPath moveToPoint:point];
    // 重绘
    [self setNeedsDisplay];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 移动
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    // 得到一个点
    // 点添加到路径中
    [self.curPath addLineToPoint:point];
     //每次touch后要重绘一下
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 把路径添加到数组中
}

// 撤销上一次画的路径
- (void)undo
{
    [self.pathArr removeLastObject];
    [self setNeedsDisplay];
}
// 清除路径
- (void)clear{
    [self.pathArr removeAllObjects];
    [self setNeedsDisplay];
}
@end
