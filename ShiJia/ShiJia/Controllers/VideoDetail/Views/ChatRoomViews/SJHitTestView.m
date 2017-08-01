//
//  SJHitTestView.m
//  ShiJia
//
//  Created by 峰 on 16/8/22.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJHitTestView.h"

NSString * const kHitTestViewNameInputView = @"HitTestViewNameInputView";

@implementation SJHitTestView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL ret = [super pointInside:point withEvent:event];
    
    if (self.beyonded) {
      
        ret = self.beyonded;
    }
    
    return ret;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView *retView = nil;
    retView = [super hitTest:point withEvent:event];
    return retView;
}

@end
