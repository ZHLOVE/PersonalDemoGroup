//
//  MyBtnA.m
//  TouchBtnMove
//
//  Created by student on 16/3/17.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "MyBtnA.h"

@implementation MyBtnA

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 判断一下触摸点是不是在addBtn范围内
    CGPoint addBtnPoint = [self convertPoint:point toView:self.btnB];
    
    if([self.btnB pointInside:addBtnPoint withEvent:event])
    {
        return self.btnB;
    }
    else
    {
        return [super hitTest:point withEvent:event];
    }
    
}

@end
