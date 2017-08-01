//
//  TPIMMinAlertView.h
//  HiTV
//
//  Created by yy on 15/9/10.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//
/**
 *  自定义黑色背景小窗口AlertView，无标题，有提示内容，有两个按钮，用于全屏观看视频时显示
 */
#import <UIKit/UIKit.h>

@interface TPIMMinAlertView : UIView

/**
 *  左边按钮事件block
 */
@property (nonatomic, copy) void(^leftButtonClickBlock)();

/**
 *  右边按钮时间block
 */
@property (nonatomic, copy) void(^rightButtonClickBlock)();

/**
 *  初始化方法
 *
 *  @param message          提示内容
 *  @param leftButtonTitle  左边按钮标题
 *  @param rightButtonTitle 右边按钮标题
 *
 *  @return 返回TPIMAlertView
 */
- (instancetype)initWithMessage:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

/**
 *  显示Alert view
 */
- (void)show;

@end
