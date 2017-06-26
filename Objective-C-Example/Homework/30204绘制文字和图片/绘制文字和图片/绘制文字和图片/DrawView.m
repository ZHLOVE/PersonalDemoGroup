//
//  DrawView.m
//  绘制文字和图片
//
//  Created by student on 16/4/6.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

- (void)setSelImage:(UIImage *)selImage{
    _selImage = selImage;
    //重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //1 绘制图片
    //bundle中的图片
    UIImage *img = [UIImage imageNamed:@"langmuwine"];
    [img drawAtPoint:CGPointZero];
    [img drawInRect:CGRectMake(29, 0, 29, 45)];
    //外部传入的图片
    [self.selImage drawInRect:CGRectMake(50, 80, 100, 100)];
    
    //2 绘制文字
    //普通字符串
    NSString *str = @"我AbcdEFG";
    //字符串格式字典
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    textDict[NSForegroundColorAttributeName] = [UIColor greenColor];//颜色
    textDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];//字体大小
    //带格式的字符串
    NSAttributedString *aStr = [[NSAttributedString alloc]initWithString:@"Hello!" attributes:textDict];
    [str drawAtPoint:CGPointMake(100, 25) withAttributes:textDict];
    [aStr drawAtPoint:CGPointMake(100, 50)];
}


@end
