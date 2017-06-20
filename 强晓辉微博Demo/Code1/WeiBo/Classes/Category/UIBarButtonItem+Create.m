//
//  UIBarButtonItem+Create.m
//  WeiBo
//
//  Created by student on 16/4/25.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "UIBarButtonItem+Create.h"

@implementation UIBarButtonItem (Create)


+ (UIBarButtonItem *)createBarButtonItem:(NSString *)imageName
                                  target:(id)target
                                  action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[imageName stringByAppendingString: @"_highlighted"]] forState:UIControlStateHighlighted];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
