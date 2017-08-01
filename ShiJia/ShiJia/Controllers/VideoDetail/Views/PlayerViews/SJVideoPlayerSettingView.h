//
//  SJVideoPlayerSettingView.h
//  ShiJia
//
//  Created by yy on 16/9/5.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJVideoPlayerSettingView : UIView

@property (nonatomic, assign) BOOL isShowing;

/**
 *  视频铺满屏幕
 */
@property (nonatomic, copy) void (^videoScaleFillBlock)();

/**
 *  视频按比例100%显示
 */
@property (nonatomic, copy) void (^videoScaleAspectFillBlock)();

/**
 *  视频按比例显示50%
 */
@property (nonatomic, copy) void (^videoScaleAspect50Block)();

/**
 *  改变屏幕亮度
 */
@property (nonatomic, copy) void (^changeBrightnessBlock)(CGFloat value);

- (void)showInView:(UIView *)view;

- (void)hide;

@end
