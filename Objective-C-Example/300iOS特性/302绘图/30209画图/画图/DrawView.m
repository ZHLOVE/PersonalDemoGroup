//
//  DrawView.m
//  画图
//
//  Created by niit on 16/4/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DrawView.h"

#import "DrawLinePath.h"

// 1. 触摸里添加路径及路径点
// 2. drawRect将路径数组中的路径绘制出来

@interface DrawView()

// 当前绘制的路径
@property (nonatomic,strong) DrawLinePath *curPath;

// 路径数组
@property (nonatomic,strong) NSMutableArray *pathArr;

@end

@implementation DrawView

//
- (void)awakeFromNib
{
    self.curLineWidth = 1;
    self.curColor = [UIColor blackColor];
}


- (NSMutableArray *)pathArr
{
    if(_pathArr == nil)
    {
        _pathArr = [NSMutableArray array];
    }
    return _pathArr;
}

// 撤销上一次画的路径
- (void)undo
{
    [self.pathArr removeLastObject];
    
    [self setNeedsDisplay];
}
// 清除路径
- (void)clear
{
    [self.pathArr removeAllObjects];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // 将路径数组中的所有路径绘制出来
    for(DrawLinePath *path in self.pathArr)
    {
        [path.color set];
        [path stroke];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 触摸点位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 1. 创建新一个路径,作为当前正在绘制的路径
    self.curPath = [DrawLinePath bezierPath];
    self.curPath.lineWidth = self.curLineWidth;
    self.curPath.color = self.curColor;
    // 2. 将路径添加到路径数组
    [self.pathArr addObject:self.curPath];
    // 3. 为该条新路径添加起点点
    [self.curPath moveToPoint:point];
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 触摸点位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 点添加到当前路径中
    [self.curPath addLineToPoint:point];
    
    // 重绘
    [self setNeedsDisplay];
}

@end
