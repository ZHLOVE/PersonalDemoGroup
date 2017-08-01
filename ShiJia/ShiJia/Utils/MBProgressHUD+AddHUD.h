//
//  MBProgressHUD+AddHUD.h
//  ShiJia
//
//  Created by 峰 on 16/7/8.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (AddHUD)

+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view delay:(int)time;
/**
 *  MBProgress 展示状态
 *
 *  @param text 显示文字
 *  @param icon 图片名字
 *  @param view 对应的view
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;

+ (void)hideHUD;

+ (MBProgressHUD *)loading:(NSString *)message toView:(UIView *)view;
@end
