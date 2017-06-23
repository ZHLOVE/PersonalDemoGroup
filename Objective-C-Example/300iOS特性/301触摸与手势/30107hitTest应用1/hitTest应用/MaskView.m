//
//  MaskView.m
//  hitTest应用
//
//  Created by niit on 16/3/17.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 判断触摸点是不是在按钮的范围内

    CGPoint btnPoint = [self convertPoint:point toView:self.btn];// 转换成按钮坐标系
    
    if([self.btn pointInside:btnPoint withEvent:event])
    {
        return self.btn;
    }
    else
    {
        return [super hitTest:point withEvent:event];
    }
}


@end
