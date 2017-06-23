//
//  DrawView.m
//  绘制文字和图片
//
//  Created by niit on 16/4/6.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)setSelImage:(UIImage *)selImage
{
    _selImage = selImage;
    // 重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // 1. 绘制图片
    // bundle中的图片
    UIImage *img = [UIImage imageNamed:@"langmuwine"];
    [img drawAtPoint:CGPointZero];
    [img drawInRect:CGRectMake(29, 0, 29, 45)];
//    [img drawInRect:rect];
    
    // 外部传入的图片
//    [self.selImage drawInRect:rect];
    [self.selImage drawInRect:CGRectMake(50, 80, 100, 100)];
    
    // 2. 绘制文字
    
    // 普通字符串
    NSString *str = @"我adfasdf";
    // 字符串格式字典
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    textDict[NSForegroundColorAttributeName] = [UIColor greenColor];// 颜色
    textDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];// 字体大小
    // 带格式的字符串
    NSAttributedString *aStr = [[NSAttributedString alloc] initWithString:@"Hello!" attributes:textDict];
    
    [str drawAtPoint:CGPointMake(100, 25) withAttributes:textDict];

    [aStr drawAtPoint:CGPointMake(100, 50)];
    
}


@end
