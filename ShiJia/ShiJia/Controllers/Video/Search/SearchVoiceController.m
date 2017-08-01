//
//  SearchVoiceController.m
//  HiTV
//
//  Created by jzb on 15/7/30.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "SearchVoiceController.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "RecognizerFactory.h"
#import "ISRDataHelper.h"
@interface SearchVoiceController ()<IFlySpeechRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *speachLabel;
@property (weak, nonatomic) IBOutlet UIButton *speachBtn;
@property (weak, nonatomic) IBOutlet UIImageView *leftWaveImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightWaveImg;

//语音识别对象
@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;
@property (nonatomic, strong) NSString             * result;

@property (nonatomic, copy) SpeechResultBlock copyBlock;

@end

@implementation SearchVoiceController

- (id)initWithSpeechResult:(SpeechResultBlock)speechResult
{
    if (self = [super init]) {
        self.copyBlock = speechResult;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"语音搜索"];
    
    [self.speachBtn addTarget:self action:@selector(touchTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.speachBtn addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    //创建识别
    _iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
    _iFlySpeechRecognizer.delegate = self;
    self.result = @"";
    // Do any additional setup after loading the view from its nib.
}

//语音按住事件
-(void)touchTouchDown
{
    [self speechStart];
    self.leftWaveImg.hidden = NO;
    self.rightWaveImg.hidden = NO;
    [self.speachBtn setImage:[UIImage imageNamed:@"识别中"] forState:UIControlStateHighlighted];
}
//语音按钮松开
-(void)touchUpOutside
{
    [self speechStop];
    self.leftWaveImg.hidden = YES;
    self.rightWaveImg.hidden = YES;
    [self.speachBtn setImage:[UIImage imageNamed:@"语音助手"] forState:UIControlStateNormal];
}

#pragma mark IFlyRecognizerViewDelegate
-(void)speechStart
{
    //设置为录音模式
    [self.iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    bool ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
        
    }
    else
    {
        
    }
}
-(void)speechStop
{
    [_iFlySpeechRecognizer stopListening];
    
}

- (void) onBeginOfSpeech
{
    DDLogInfo(@"onBeginOfSpeech");
    
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 *
 * @see
 */
- (void) onEndOfSpeech
{
    DDLogInfo(@"onEndOfSpeech");
    
}

/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    
    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];
    
    self.result =[NSString stringWithFormat:@"%@%@", self.result,resultFromJson];
    
    if (isLast)
    {
        DDLogInfo(@"听写结果(json)：%@测试",  self.result);
        self.result = [self.result stringByReplacingOccurrencesOfString:@"。" withString:@""];
        if (self.copyBlock) {
            self.copyBlock(self.result);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        DDLogInfo(@"result=%@",self.result);
    }
    
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    
    DDLogInfo(@"111");
    
    DDLogError(@"errorCode:%d",[error errorCode]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
