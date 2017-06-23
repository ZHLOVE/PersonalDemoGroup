//
//  YellowView.m
//  TouchEvent
//
//  Created by niit on 16/3/17.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "YellowView.h"

@implementation YellowView

// 用来查找符合相应当前点击的最适合的视图
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL bInside = [super pointInside:point withEvent:event];
    NSLog(@"%s = %@",__func__,bInside ? @"YES":@"NO");
    return bInside;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}
- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}
@end
