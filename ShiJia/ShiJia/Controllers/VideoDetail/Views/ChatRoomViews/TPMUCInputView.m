//
//  TPMUCInputView.m
//  ShiJia
//
//  Created by yy on 16/7/28.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "TPMUCInputView.h"

#import "TPRecorderHUD.h"
#import "TPWavRecorder.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import <iflyMSC/IFlySpeechConstant.h>
#import "RecognizerFactory.h"
#import "ISRDataHelper.h"

//static CGFloat kIconButtonWidth    = 35.0;
//static CGFloat kTextViewHeight     = 35.0;
//static CGFloat kRecordButtonHeight = 35.0;
//static CGFloat kInnerPadding       = 10.0;

typedef NS_ENUM(NSInteger, TPMUCInputViewInputType) {
    TPMUCInputViewInputType_text,
    TPMUCInputViewInputType_recorder
    
};

@interface TPMUCInputView ()
/*<UITextViewDelegate, TPWavRecorderDelegate,IFlySpeechRecognizerDelegate>

@property (nonatomic, retain) TPWavRecorder* wavRecorder;
@property (nonatomic, strong) TPRecorderHUD* customHUD;
@property (nonatomic, assign) TPMUCInputViewInputType inputType;
*/
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation TPMUCInputView
#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
       
        // 输入切换按钮
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconButton setBackgroundImage:[UIImage imageNamed:@"muc_input_record_btn"] forState:UIControlStateNormal];
        [_iconButton addTarget:self action:@selector(iconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_iconButton];
        
        
        // 录音按钮
        _recorderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recorderButton setBackgroundColor:kColorBlueTheme];
        [_recorderButton setTitle:@"按住说话" forState:UIControlStateNormal];
        [_recorderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recorderButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_recorderButton addTarget:self action:@selector(recordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_recorderButton addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchUpOutside];
        [_recorderButton addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchCancel];
        [_recorderButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_recorderButton addTarget:self action:@selector(recordButtonDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [_recorderButton addTarget:self action:@selector(recordButtonDragExit:) forControlEvents:UIControlEventTouchDragExit];
        _recorderButton.hidden = YES;
        _recorderButton.layer.cornerRadius = 2.0;
        _recorderButton.layer.masksToBounds = YES;
        [self addSubview:_recorderButton];
        
        
        // 输入框
        _textview = [[UITextView alloc] init];
        _textview.layer.cornerRadius = 2.0;
        _textview.layer.masksToBounds = YES;
        //_textview.delegate = self;
        _textview.backgroundColor = kColorLightGrayBackground;
        _textview.font = [UIFont systemFontOfSize:14];
        _textview.textColor = [UIColor colorWithHexString:@"9a9a9a"];
        _textview.returnKeyType = UIReturnKeySend;
        [self addSubview:_textview];
        
        /*
        //创建识别
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        //请不要删除这句,createRecognizer是单例方法，需要重新设置代理
        _iFlySpeechRecognizer.delegate = self;
        
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
        //设置采样率
        [_iFlySpeechRecognizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //设置录音保存文件
        //    [iflySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        //设置为非语义模式
        [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_SCH]];
        
        //设置返回结果的数据格式，可设置为json，xml，plain，默认为json。
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //设置为麦克风输入模式
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
//        _iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
//        [_iFlySpeechRecognizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
//        _iFlySpeechRecognizer.delegate = self;
        
        
        
        [self setRecorderButtonNormalImage];
         
         // init recorder
         self.wavRecorder = [[TPWavRecorder alloc] init];
         self.wavRecorder.delegate = self;
         
         @weakify(self);
         [self.wavRecorder setRecordVolumeChanged:^(double volume) {
         
         @strongify(self);
         if (!self.customHUD.showCancelTip) {
         [self.customHUD showRecordVolume:volume];
         }
         
         }];
         */
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(keyboardWillShow:)
         name:UIKeyboardWillShowNotification
         object:nil];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(keyboardWillHide:)
         name:UIKeyboardWillHideNotification
         object:nil];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(keyboardWillChangeFrame:)
         name:UIKeyboardWillChangeFrameNotification
         object:nil];
        
        
    }
    return self;
}

#pragma mark - subview
/*
- (void)setRecorderButtonNormalImage
{
    [self.recorderButton setBackgroundColor:kColorBlueTheme];
}

- (void)setRecorderButtonPressedImage
{
    [self.recorderButton setBackgroundColor:[UIColor colorWithHexString:@"11A7D3"]];
}
*/

#pragma mark - text view
/*
- (void)textViewDidBeginEditing:(UITextView*)textView
{
}

- (void)textViewDidChange:(UITextView*)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView*)textView
{
    [self resignFirstResponder];
}

- (BOOL)textView:(UITextView*)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString*)text
{
    
    if ([text isEqualToString:@"\n"]) {
        //换行
        [self sendButtonClicked:nil];
    }
    return YES;
}
*/

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification*)notification
{
    
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [_backButton removeFromSuperview];
    [self resignFirstResponder];
}

- (void)keyboardWillChangeFrame:(NSNotification*)notification
{
    
    if (!_textview.isFirstResponder) {
        return;
    }
    
    
    CGRect rect = [[notification.userInfo
                    valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.superview.frame.size.height - rect.size.height - self.frame.size.height,
                            self.frame.size.width,
                            self.frame.size.height);
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (rect.origin.y < screenSize.height) {
        self.beyonded = YES;
        [_backButton removeFromSuperview];
        _backButton.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - rect.size.height - self.frame.size.height);
        [[UIApplication sharedApplication].keyWindow addSubview:_backButton];
    }
    else{
        self.beyonded = NO;
        [_backButton removeFromSuperview];
    }
    
    
    [UIView animateWithDuration:0.8
                     animations:^{
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (BOOL)resignFirstResponder
{
    self.beyonded = NO;
    
    [self.textview resignFirstResponder];
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.superview.frame.size.height - self.frame.size.height,
                            self.frame.size.width,
                            self.frame.size.height);
    
    return [super resignFirstResponder];
}

#pragma mark - button click
- (void)backButtonClicked:(id)sender
{
    [self resignFirstResponder];
}

- (IBAction)sendButtonClicked:(id)sender
{
//    if (self.textview.text.length != 0 &&
//        [self.delegate respondsToSelector:@selector(sendMessage:)]) {
//        [self.delegate sendMessage:self.textview.text];
//        self.textview.text = nil;
//        [self resignFirstResponder];
//    }
}

- (IBAction)iconButtonClicked:(id)sender
{
//    if (self.inputType == TPMUCInputViewInputType_text) {
//        [self.iconButton
//         setBackgroundImage:[UIImage imageNamed:@"muc_input_keyboard_btn"]
//         forState:UIControlStateNormal];
//        self.textview.hidden = YES;
//        self.recorderButton.hidden = NO;
//        self.inputType = TPMUCInputViewInputType_recorder;
//        [self resignFirstResponder];
//    }
//    else {
//        [self.iconButton
//         setBackgroundImage:[UIImage imageNamed:@"muc_input_record_btn"]
//         forState:UIControlStateNormal];
//        self.textview.hidden = NO;
//        self.recorderButton.hidden = YES;
//        self.inputType = TPMUCInputViewInputType_text;
//        [self.textview becomeFirstResponder];
//    }
}

- (IBAction)recordButtonTouchDown:(id)sender
{
//    //开始录音
//    [self.wavRecorder startRecord];
//    _isSent = NO;
//    _recordString = @"";
//    //显示HUD
//    _customHUD.showCancelTip = NO;
//    [self showHUD];
//    HUD.labelColor = [UIColor whiteColor];
//    HUD.labelText = @"手指上滑，取消发送";
//    [_customHUD showMicroPhoneImg];
//    
//    //更新录音按钮样式
//    [self.recorderButton setTitle:@"松开发送" forState:UIControlStateNormal];
//    [self setRecorderButtonPressedImage];
}

- (IBAction)recordButtonTouchUpInside:(id)sender
{
//    //停止录音
//    self.recordString = @"";
//    [self.wavRecorder stopRecord];
//    [self iFlyStartListening];
//    _customHUD.showCancelTip = NO;
//    
//    if (self.wavRecorder.recordDuration < 2) {
//        
//        //HUD
//        HUD.labelText = @"说话时间太短";
//        HUD.labelColor = [UIColor whiteColor];
//        [_customHUD showWarningImg];
//        [HUD hide:YES afterDelay:0.8];
//        
//        //更新录音按钮样式
//        [self.recorderButton setTitle:@"按住说话" forState:UIControlStateNormal];
//        [self setRecorderButtonNormalImage];
//        DDLogInfo(@"录音太短");
//    }
//    else {
//        
//        //隐藏HUD
//        [HUD hide:YES];
//        
//        //更新录音按钮样式
//        [self.recorderButton setTitle:@"按住说话" forState:UIControlStateNormal];
//        [self setRecorderButtonNormalImage];
//        
//        //        //完成录音
//        //        if ([self.delegate
//        //             respondsToSelector:@selector(sendRecordData:recordString:recordDuration:)]) {
//        //            [self.delegate sendRecordData:self.wavRecorder.recordData
//        //                             recordString:self.wavRecorder.recordString
//        //                           recordDuration:self.wavRecorder.recordDuration];
//        //        }
//        DDLogInfo(@"结束录音");
//    }
}

- (IBAction)recordButtonDragEnter:(id)sender
{
//    //手指上滑动作
//    _customHUD.showCancelTip = NO;
//    HUD.labelColor = [UIColor whiteColor];
//    HUD.labelText = @"手指上滑，取消发送";
//    [_customHUD showMicroPhoneImg];
//    
//    //更新录音按钮样式
//    [self.recorderButton setTitle:@"松开发送" forState:UIControlStateNormal];
//    [self setRecorderButtonPressedImage];
    
}

- (IBAction)recordButtonDragExit:(id)sender
{
//    //手指离开动作
//    // HUD：显示取消录音提示
//    _customHUD.showCancelTip = YES;
//    HUD.labelText = @"松开手指，取消发送";
//    HUD.labelColor = [UIColor redColor];
//    [_customHUD showCancelRecordTip];
//    
//    //更新录音按钮样式
//    [self.recorderButton setTitle:@"松开发送" forState:UIControlStateNormal];
//    [self setRecorderButtonPressedImage];
    
}

- (IBAction)cancelRecord:(id)sender
{
    
//    // HUD
//    _customHUD.showCancelTip = NO;
//    [HUD hide:YES];
//    
//    //取消录音
//    [self.wavRecorder stopRecord];
//    
//    //更新录音按钮样式
//    [self.recorderButton setTitle:@"按住说话" forState:UIControlStateNormal];
//    [self setRecorderButtonNormalImage];
    
}

/*
#pragma mark - recorder delegate
//倒计时结束
- (void)didFinishRecording:(NSData*)data duration:(CGFloat)duration
{
    //停止录音
    [self.wavRecorder stopRecord];
    [self iFlyStartListening];
    _customHUD.showCancelTip = NO;
    
    //隐藏HUD
    [HUD hide:YES];
    
    //更新录音按钮样式
    [self.recorderButton setSelected:NO];
    [self.recorderButton setHighlighted:NO];
    [self.recorderButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [self setRecorderButtonNormalImage];
    
    //    //完成录音
    //    if ([self.delegate
    //         respondsToSelector:@selector(sendRecordData:recordString:recordDuration:)]) {
    //        [self.delegate sendRecordData:data
    //                         recordString:self.recordString
    //                       recordDuration:duration];
    //    }
    
    DDLogInfo(@"结束录音");
}

//录音进入倒计时
- (void)startCountingDown
{
    //HUD显示倒计时
    [_customHUD showCountDown];
    
    @weakify(self);
    
    //倒计时结束
    [_customHUD setDidFinishCounting:^{
        @strongify(self);
        self->HUD.labelText = @"说话时间太长";
        [self.customHUD showWarningImg];
        self.customHUD.showCancelTip = NO;
        [self->HUD hide:YES afterDelay:1.0];
        
    }];
}

- (void)recordError:(NSError *)error
{
    
}

#pragma mark - iFly
- (void)iFlyStartListening
{
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_STREAM forKey:@"audio_source"];//设置音频数据模式为音频流
    BOOL ret  = [_iFlySpeechRecognizer startListening];
    
    
    if (ret) {
        [NSThread detachNewThreadSelector:@selector(sendAudioThread) toTarget:self withObject:nil];
    }
    else
    {
        
    }
}

// 写入音频流线程
- (void)sendAudioThread
{
    DDLogInfo(@"%s[IN]",__func__);
    NSData *data = [NSData dataWithData:self.wavRecorder.recordData];    //从文件中读取音频
    
    int count = 10;
    unsigned long audioLen = data.length/count;
    
    
    for (int i =0 ; i< count-1; i++) {    //分割音频
        char * part1Bytes = malloc(audioLen);
        NSRange range = NSMakeRange(audioLen*i, audioLen);
        [data getBytes:part1Bytes range:range];
        NSData * part1 = [NSData dataWithBytes:part1Bytes length:audioLen];
        
        int ret = [self.iFlySpeechRecognizer writeAudio:part1];//写入音频，让SDK识别
        free(part1Bytes);
        
        
        if(!ret) {     //检测数据发送是否正常
            DDLogInfo(@"%s[ERROR]",__func__);
            [self.iFlySpeechRecognizer stopListening];
            
            
            return;
        }
    }
    
    //处理最后一部分
    unsigned long writtenLen = audioLen * (count-1);
    char * part3Bytes = malloc(data.length-writtenLen);
    NSRange range = NSMakeRange(writtenLen, data.length-writtenLen);
    [data getBytes:part3Bytes range:range];
    NSData * part3 = [NSData dataWithBytes:part3Bytes length:data.length-writtenLen];
    
    [_iFlySpeechRecognizer writeAudio:part3];
    free(part3Bytes);
    [_iFlySpeechRecognizer stopListening];//音频数据写入完成，进入等待状态
    DDLogInfo(@"%s[OUT]",__func__);
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    
    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];
    if (self.recordString.length != 0) {
        self.recordString = [NSString stringWithFormat:@"%@%@", self.recordString,resultFromJson];
    }
    else{
        self.recordString = resultFromJson;
    }
    
    DDLogInfo(@"\n听写结果-----%@\n",self.recordString);
    
    if (isLast)
    {
        //完成录音
        if ([self.delegate
             respondsToSelector:@selector(sendRecordData:recordString:recordDuration:)]) {
            _isSent = YES;
            [self.delegate sendRecordData:self.wavRecorder.recordData
                             recordString:self.recordString
                           recordDuration:self.wavRecorder.recordDuration];
        }
        
    }
    else{
        DDLogInfo(@"result=%@",self.recordString);
    }
    
}

// 识别结束回调方法
- (void)onError:(IFlySpeechError *)error
{
    
    DDLogInfo(@"111");
    
    DDLogInfo(@"errorCode:%d",[error errorCode]);
    if (!_isSent) {
        //完成录音
        if ([self.delegate
             respondsToSelector:@selector(sendRecordData:recordString:recordDuration:)]) {
            _isSent = YES;
            [self.delegate sendRecordData:self.wavRecorder.recordData
                             recordString:self.recordString
                           recordDuration:self.wavRecorder.recordDuration];
        }
    }
}


#pragma mark - hud
- (void)showHUD
{
    [HUD hide:YES];
    HUD = nil;
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc]
               initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    }
    
    if (_customHUD == nil) {
        _customHUD = [[TPRecorderHUD alloc] init];
    }
    
    HUD.customView = _customHUD;
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD show:YES];
}
*/

@end
