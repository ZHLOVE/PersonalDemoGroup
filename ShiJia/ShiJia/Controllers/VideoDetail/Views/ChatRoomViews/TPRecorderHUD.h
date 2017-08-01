//
//  TPRecorderHUD.h
//  ChatDemo
//
//  Created by yy on 15/10/13.
//  Copyright © 2015年 yy. All rights reserved.
//
/**
 *  录制语音时显示的HUD类
 */
#import <UIKit/UIKit.h>

/**
 *  HUD模式
 */
typedef NS_ENUM(NSInteger, TPRecorderHUDMode) {
    /**
     * 音量变化mode
     */
    TPRecorderHUDModeVolumeChanging,
    /**
     *  取消录音提示mode
     */
     TPRecorderHUDModeCancelTip,
    /**
     *  录音时长超过50秒时的倒计时mode
     */
     TPRecorderHUDModeCountDown
};

@interface TPRecorderHUD : UIView

/**
 *  是否显示取消录音提示标志位
 */
@property (nonatomic, assign) BOOL showCancelTip;

/**
 *  HUD Mode
 */
@property (nonatomic, assign) TPRecorderHUDMode mode;

/**
 *  倒计时结束回调
 */
@property (nonatomic, copy) void(^didFinishCounting)();

/**
 *  显示音量
 *
 *  @param volume 音量值
 */
- (void)showRecordVolume:(double)volume;

/**
 *  显示麦克风图标
 */
- (void)showMicroPhoneImg;

/**
 *  显示取消录音提示
 */
- (void)showCancelRecordTip;

/**
 *  开始倒计时
 */
- (void)showCountDown;

/**
 *  显示警告图标
 */
- (void)showWarningImg;

@end
