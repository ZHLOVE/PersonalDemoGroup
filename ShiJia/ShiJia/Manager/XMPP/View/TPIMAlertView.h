//
//  TPIMAlertView.h
//  HiTV
//
//  Created by yy on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

/**
 *  自定义黑色背景AlertView，有标题，提示内容，两个按钮
 */


#import <UIKit/UIKit.h>

@interface TPIMAlertView : UIView

/**
 *  左边按钮事件block
 */
@property (nonatomic, copy) void(^leftButtonClickBlock)();

/**
 *  右边按钮时间block
 */
@property (nonatomic, copy) void(^rightButtonClickBlock)();

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *imageUrl;

/**
 *  初始化方法
 *
 *  @param title            标题
 *  @param message          提示内容
 *  @param leftButtonTitle  左边按钮标题
 *  @param rightButtonTitle 右边按钮标题
 *
 *  @return 返回TPIMAlertView
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

/**
 *  显示Alert view
 */
- (void)show;

@end
