//
//  SJPrivateMUCInputView.h
//  ShiJia
//
//  Created by yy on 16/6/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPMUCInputView.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

@class SJLiveTVViewModel;

static CGFloat const kTPPrivateMUCInputViewHeight = 49.0;

@protocol TPPrivateMUCInputViewDelegate <NSObject>
/**
 *  发送文字消息
 *
 *  @param msg 消息内容
 */
- (void)privateRoomSendMessage:(NSString *)msg;

/**
 *  发送语音消息
 *
 *  @param recordData     语音data
 *  @param recordDuration 语音时长
 */
- (void)privateRoomSendRecordData:(NSData *)recordData recordString:(NSString *)recordString recordDuration:(CGFloat )recordDuration;

@end

@interface TPPrivateMUCInputView : TPMUCInputView

@property (nonatomic, weak) id<TPPrivateMUCInputViewDelegate>delegate;
@property (nonatomic, strong) SJLiveTVViewModel *iflyManager;

@property (nonatomic, readonly) RACSignal *inviteSignal;
@property (nonatomic, assign) NSInteger userCount;

/**
 *  文字输入框
 */
//@property (nonatomic, strong, readonly) UITextView *textview;

/**
 *  文字输入框高度变化block
 */
@property (nonatomic, copy) void(^heightChangedBlock)(CGFloat height);

@end
