//
//  DrawView.m
//  图片的相关处理
//
//  Created by niit on 16/4/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage *img = [UIImage imageNamed:@"1.jpeg"];
    [img drawInRect:rect];
    
    NSString *str = @"郭德纲 NIIT";
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    [str drawAtPoint:CGPointZero withAttributes:dict];
    
    
}


@end
