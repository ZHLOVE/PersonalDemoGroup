//
//  UIBarButtonItem+Create.m
//  Weibo
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "UIBarButtonItem+Create.h"

@implementation UIBarButtonItem (Create)

+ (UIBarButtonItem *)createBarButtonItem:(NSString *)imageName
                                  target:(id)target
                                  action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 按钮图片
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_highlighted"]] forState:UIControlStateHighlighted];
    // 按钮事件
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    // 自动调整尺寸
    [btn sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
