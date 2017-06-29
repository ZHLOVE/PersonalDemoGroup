//
//  UIButton+Create.m
//  WingsBurning
//
//  Created by MBP on 2016/12/15.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)

- (void)setCaptchaButtonCreated{
    [self setBackgroundImage:[UIImage imageNamed:@"button_get_nor"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"button_get_dis"] forState:UIControlStateDisabled];
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.layer.cornerRadius = 47;
}




@end
