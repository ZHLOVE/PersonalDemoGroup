//
//  DrawView.m
//  图片的相关处理
//
//  Created by student on 16/4/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


- (void)drawRect:(CGRect)rect {
    UIImage *img = [UIImage imageNamed:@"1.jpeg"];
    [img drawInRect:rect];
    
    NSString *str = @"郭德纲 NIIT";
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    [str drawAtPoint:CGPointZero withAttributes:dict];
}


@end
