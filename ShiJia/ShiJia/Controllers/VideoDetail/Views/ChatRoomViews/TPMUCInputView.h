//
//  TPMUCInputView.h
//  ShiJia
//
//  Created by yy on 16/7/28.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJHitTestView.h"

//#import "iflyMSC/IFlySpeechRecognizer.h"

static CGFloat const kTPMUCInputViewHeight = 49.0;

//@protocol TPMUCInputViewDelegate <NSObject>
///**
// *  发送文字消息
// *
// *  @param msg 消息内容
// */
//- (void)sendMessage:(NSString *)msg;
//
///**
// *  发送语音消息
// *
// *  @param recordData     语音data
// *  @param recordDuration 语音时长
// */
//- (void)sendRecordData:(NSData *)recordData recordString:(NSString *)recordString recordDuration:(CGFloat )recordDuration;
//
//@end


@interface TPMUCInputView : SJHitTestView

//@property (nonatomic, weak) id<TPMUCInputViewDelegate>delegate;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UIButton *recorderButton;
@property (nonatomic, strong) UITextView *textview;

////语音识别对象
//@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;
//@property (nonatomic, readwrite, strong) NSString *recordString;
//@property (nonatomic, assign) BOOL isSent;
//
///**
// *  文字输入框高度变化block
// */
//@property (nonatomic, copy) void(^heightChangedBlock)(CGFloat height);

- (IBAction)sendButtonClicked:(id)sender;
- (IBAction)iconButtonClicked:(id)sender;
- (IBAction)recordButtonTouchDown:(id)sender;
- (IBAction)recordButtonTouchUpInside:(id)sender;
- (IBAction)recordButtonDragEnter:(id)sender;
- (IBAction)recordButtonDragExit:(id)sender;
- (IBAction)cancelRecord:(id)sender;

@end
