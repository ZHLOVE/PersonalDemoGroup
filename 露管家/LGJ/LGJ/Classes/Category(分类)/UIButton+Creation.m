//
//  UIButton+Creation.m
//  Weibo
//
//  Created by qiang on 5/5/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "UIButton+Creation.h"

@implementation UIButton (Creation)

+ (UIButton *)createButtonWithTitle:(NSString *)title
                          imageName:(NSString *)imageName
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    return btn;
}
@end
