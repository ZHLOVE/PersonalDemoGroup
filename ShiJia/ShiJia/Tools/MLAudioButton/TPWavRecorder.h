//
//  SJWavRecorder.h
//  ShiJia
//
//  Created by yy on 16/5/10.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TPWavRecorderDelegate <NSObject>

@required
/**
 *  录音遇到了错误，例如创建文件失败啊。写入失败啊。关闭文件失败啊，等等。
 */
- (void)recordError:(NSError *)error;

@optional

/**
 *  录音被停止
 *  一般是在writer delegate中因为一些状况意外停止录音获得此事件时候使用，参考AmrRecordWriter里实现。
 */
- (void)recordStopped;

/**
 *  录音结束回调
 *
 *  @param data     录制完成的语音data
 *  @param duration 语音时长
 */
- (void)didFinishRecording:(NSData *)data duration:(CGFloat)duration;

/**
 *  开始倒计时
 */
- (void)startCountingDown;

@end



@interface TPWavRecorder : NSObject

@property (nonatomic, weak) id<TPWavRecorderDelegate>delegate;

/**
 * 语音data
 */
@property (nonatomic, readonly, strong) NSData *recordData;

/**
 *  语音时长
 */
@property (nonatomic, readonly, assign) CGFloat recordDuration;

/**
 *  录制语音时外界声音音量变化block
 */
@property (nonatomic, copy) void(^recordVolumeChanged)(double volume);

/**
 *  是否正在录音
 */
@property (atomic, assign,readonly) BOOL isRecording;

/**
 *  开始录音
 */
- (void)startRecord;

/**
 *  结束录音
 */
- (void)stopRecord;



@end
