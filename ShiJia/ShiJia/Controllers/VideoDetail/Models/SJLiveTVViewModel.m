//
//  SJLiveTVViewModel.m
//  ShiJia
//
//  Created by yy on 16/7/28.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLiveTVViewModel.h"

#import "iflyMSC/IFlySpeechRecognizer.h"
#import <iflyMSC/IFlySpeechConstant.h>
#import "RecognizerFactory.h"
#import "ISRDataHelper.h"

@interface SJLiveTVViewModel ()

//语音识别对象
@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;
@property (nonatomic, strong) NSData *recordData;
@property (nonatomic, readwrite, strong) NSString *recordString;

@property (nonatomic, assign) BOOL isPublicMessageSent;
@property (nonatomic, assign) BOOL isPrivateMessageSent;

@end

@implementation SJLiveTVViewModel

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupiFlyRecognizer];
    }
    return self;
}

#pragma mark - iFly
- (void)setupiFlyRecognizer
{
    // 创建识别对象
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
}


- (void)iFlyStartListening:(NSData *)wavData
{
    self.recordData = wavData;
    self.recordString = @"";
    self.isPublicMessageSent = NO;
    self.isPrivateMessageSent = NO;
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_STREAM forKey:@"audio_source"];    //设置音频数据模式为音频流
    BOOL ret  = [_iFlySpeechRecognizer startListening];
    
    
    if (ret) {
        [NSThread detachNewThreadSelector:@selector(sendAudioThread) toTarget:self withObject:nil];
    }
    else
    {
        
    }
}

/**
 写入音频流线程
 ****/
- (void)sendAudioThread
{
    DDLogInfo(@"%s[IN]",__func__);
    NSData *data = [NSData dataWithData:self.recordData];    //从文件中读取音频
    
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
            DDLogError(@"%s[ERROR]",__func__);
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

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast
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
//        if ([self.delegate
//             respondsToSelector:@selector(publicRoomSendRecordData:recordString:recordDuration:)]) {
//            _isSent = YES;
//            [self.delegate publicRoomSendRecordData:self.wavRecorder.recordData
//                                       recordString:self.recordString
//                                     recordDuration:self.wavRecorder.recordDuration];
//        }
        
        if (self.messageType == SJMessageTypePrivate) {
            if (self.didRecognizePrivateMessage) {
                self.isPrivateMessageSent = YES;
                self.didRecognizePrivateMessage(self.recordString);
                self.recordString = @"";
            }
        }
        else{
            if (self.didRecognizePublicMessage) {
                self.isPublicMessageSent = YES;
                self.didRecognizePublicMessage(self.recordString);
                self.recordString = @"";
            }

        }
        
    }
    else{
        DDLogInfo(@"result=%@",self.recordString);
    }
    
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)errorCode
{
    
    DDLogError(@"errorCode:%d",[errorCode errorCode]);
    if (self.messageType == SJMessageTypePrivate) {
        if (!self.isPrivateMessageSent && self.didRecognizePrivateMessage) {
            self.isPrivateMessageSent = YES;
            self.didRecognizePrivateMessage(self.recordString);
            self.recordString = @"";
        }
    }
    else{
        if (!self.isPublicMessageSent && self.didRecognizePublicMessage) {
            self.isPublicMessageSent = YES;
            self.didRecognizePublicMessage(self.recordString);
            self.recordString = @"";
        }
        
    }
}

@end
