//
//  UILabel+Creation.m
//  Weibo
//
//  Created by qiang on 5/5/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "UILabel+Creation.h"

@implementation UILabel (Creation)

+ (UILabel *)createLabelWithColor:(UIColor *)color fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

@end
