//
//  MyWindow.m
//  TouchEvent
//
//  Created by niit on 16/3/17.
//  Copyright © 2016年 NIIT. All rights reserved.
//


// 1. hitTest:withEvent
// 事件传递的时候会被调用
// 当事件传递给控件的时候，就会调用该方法，用来查找最符合的view
// 作用:寻找最适合的view

// 当点self.view
// MyWindow -> YellowView -> GreenView

// 当点黄色的时候
// MyWindow -> YellowView -> BlueView

// 当点黄色的时候
// MyWindow -> YellowView -> BlueView -> RedView

// 当点红色的时候
// MyWindow -> YellowView -> BlueView -> RedView

// hitTest处理流程:
// 1. 调用当前视图的pointInsid:withEvent方法判断出点是否在当前视图内容
// 2. 如果返回NO,则hitTest返回nil
// 3. 如果返回YES,则向当前视图的所子视图再去用hitTest判断，遍历顺序是subViews从后往前，直到有子视图返回非空对象或者遍历完毕位置。
// 4. 如果有一个子视图返回非空对象,hitTest就返回这对象。
// 5. 如果子视图返回都是空，则返回自身

// 2. 判断当前点在不在方法调用者(控件)上
// pointInside:withEvent

#import "MyWindow.h"

@implementation MyWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// hitTest:withEvent 用来查找符合相应当前点击的最适合的视图
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //point 是当前控件坐标系的点坐标
    NSLog(@"%s",__func__);
    return [super hitTest:point withEvent:event];
}

// 判断当前的触摸点是不是在当前控件范围内
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL bInside = [super pointInside:point withEvent:event];
    NSLog(@"%s = %@",__func__,bInside ? @"YES":@"NO");
    return bInside;
}

@end
