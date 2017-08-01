//
//  MBProgressHUD+AddHUD.m
//  ShiJia
//
//  Created by 峰 on 16/7/8.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "MBProgressHUD+AddHUD.h"

@implementation MBProgressHUD (AddHUD)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{

    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.opacity = text.length>0?0.5:0;
    hud.activityIndicatorColor=text.length>0?[UIColor whiteColor]:[UIColor clearColor];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error1.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.opacity = message.length>0?0.5:0;
    hud.activityIndicatorColor=message.length>0?[UIColor whiteColor]:[UIColor clearColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    [hud hide:YES afterDelay:30.];
    //
    hud.minShowTime = 1.0;

    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view delay:(int)time {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    hud.minShowTime = time;
    [hud hide:YES afterDelay:2.0];
    return hud;
}
+ (void)hideHUD{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    NSArray *huds = [MBProgressHUD allHUDsForView:view];
    for (MBProgressHUD *hud in huds) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
    }
}
+ (MBProgressHUD *)loading:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.labelText = message;
    hud.opacity = message.length>0?0.5:0;
    hud.activityIndicatorColor=message.length>0?[UIColor whiteColor]:[UIColor clearColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    //
    //hud.mode = MBProgressHUDModeCustomView;
    hud.minShowTime = 1.0;
    hud.minSize = CGSizeMake(W, H);
    hud.color = [UIColor blackColor];

    return hud;
}
@end
