//
//  TPMUCInputView.h
//  XmppDemo
//
//  Created by yy on 15/7/21.
//  Copyright (c) 2015年 yy. All rights reserved.
//
/**
 *  聊天室输入框view
 */
#import <UIKit/UIKit.h>
#import "TPMUCInputView.h"

#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

@class SJLiveTVViewModel;

static CGFloat const kTPPublicMUCInputViewHeight = 49.0;

@protocol TPPublicMUCInputViewDelegate <NSObject>
/**
 *  发送文字消息
 *
 *  @param msg 消息内容
 */
- (void)publicRoomSendMessage:(NSString *)msg;

/**
 *  发送语音消息
 *
 *  @param recordData     语音data
 *  @param recordDuration 语音时长
 */
- (void)publicRoomSendRecordData:(NSData *)recordData recordString:(NSString *)recordString recordDuration:(CGFloat )recordDuration;

@end

@interface TPPublicMUCInputView : TPMUCInputView



@property (nonatomic, weak) id<TPPublicMUCInputViewDelegate>delegate;
@property (nonatomic, strong) SJLiveTVViewModel *iflyManager;


/**
 *  文字输入框
 */
//@property (nonatomic, strong, readonly) UITextView *textview;

/**
 *  文字输入框高度变化block
 */
@property (nonatomic, copy) void(^heightChangedBlock)(CGFloat height);

@end
