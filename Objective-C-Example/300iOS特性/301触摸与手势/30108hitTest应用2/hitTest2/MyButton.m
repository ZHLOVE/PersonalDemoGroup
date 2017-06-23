//
//  MyButton.m
//  hitTest2
//
//  Created by niit on 16/3/17.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 判断一下触摸点是不是在addBtn范围内
    CGPoint addBtnPoint = [self convertPoint:point toView:self.addBtn];
    
    if([self.addBtn pointInside:addBtnPoint withEvent:event])
    {
        return self.addBtn;
    }
    else
    {
        return [super hitTest:point withEvent:event];
    }
    
}

// 方法3:
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // 当前的视图内的触摸点
    CGPoint curPoint = [touch locationInView:self];
    
    // 上次的点
    CGPoint perPoint = [touch previousLocationInView:self];
    
    // 偏移量
    CGFloat offsetX = curPoint.x - perPoint.x;
    CGFloat offsetY = curPoint.y - perPoint.y;
    
    self.center = CGPointMake(self.center.x+offsetX, self.center.y+offsetY);
}

@end
