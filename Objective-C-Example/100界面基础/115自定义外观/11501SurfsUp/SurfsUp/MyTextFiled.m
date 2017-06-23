//
//  MyTextFiled.m
//  SurfsUp
//
//  Created by niit on 16/3/10.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "MyTextFiled.h"

@implementation MyTextFiled

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (void)drawRect:(CGRect)rect
{
    UIImage *bg = [[UIImage imageNamed:@"text_field_teal"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 5, 15, 5)];
    [bg drawInRect:self.bounds];
}


// 文字区域
- (CGRect)textRectForBounds:(CGRect)bounds
{
    // 在原先的区域上扩大或者缩小 dx  dy
    return CGRectInset(bounds, 20, 0);
}

// 编辑区域
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 20, 0);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 50, 0);
}
@end
