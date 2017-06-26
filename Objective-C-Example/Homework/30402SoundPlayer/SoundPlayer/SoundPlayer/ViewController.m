//
//  ViewController.m
//  SoundPlayer
//
//  Created by student on 16/4/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
{
    // 定义一个系统声音ID
    SystemSoundID soundID;
}

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic,strong) AVAudioPlayer *player;

// 录制 播放
@property (nonatomic,strong) AVAudioRecorder *recorder2;
@property (nonatomic,strong) AVAudioPlayer *player2;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

#pragma mark -播放短声音(小于5s)
- (IBAction)btn4Pressed:(id)sender {
    if (soundID == 0) {
        //注册这个声音
        NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"burp_2" withExtension:@"aif"];
        // NSURL(Foundation OC语言) -> CFURLRef (CoreFoundation C语言)
        //注册系统段声音
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(fileUrl), &soundID);
    }
    //播放
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark -播放长声音
//播放
- (IBAction)btn1Pressed:(id)sender {
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"charleston1925_64kb" withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = self.player.duration;//时长
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
    [self.player play];
    
}

// 更新信息
- (void)updateInfo
{
    self.slider.value = self.player.currentTime;
    self.label.text = [NSString stringWithFormat:@"%.1f/%.1f",self.player.currentTime,self.player.duration];// 练习: 转换成分:秒格式 04:00
}


//停止
- (IBAction)btn2Pressed:(id)sender {
    [self.player stop];
}

//震动
- (IBAction)btn3Pressed:(id)sender {
    // 播放特殊的声音ID kSystemSoundID_Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


// 修改当前播放时间
- (IBAction)sliderChange:(id)sender {
    self.player.currentTime = self.slider.value;
}

#pragma mark - 录制相关

// 录制文件保存在沙盒里位置
- (NSURL *)fileURL
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString *filePath = [docPath stringByAppendingString:@"/1.caf"];
    NSURL *fileURL = [NSURL URLWithString:filePath];
    
    return fileURL;
}
//点录制按钮
- (IBAction)recordBtnPressed:(id)sender {
    if (self.recorder2.recording) {
        return;
    }
    if (self.player2.playing) {
        return;
    }
    //设置当前App音频回话模式为录音模式
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    
    //设置一下录制的设置
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0]
                forKey:AVSampleRateKey]; //采样率
    [settings setValue:[NSNumber numberWithInt:1]
                forKey:AVNumberOfChannelsKey];//通道的数目
    [settings setValue:[NSNumber numberWithInt:16]
                forKey:AVLinearPCMBitDepthKey];//采样位数  默认 16
    [settings setValue:[NSNumber numberWithBool:NO]
                forKey:AVLinearPCMIsBigEndianKey];//大端还是小端 是内存的组织方式
    [settings setValue:[NSNumber numberWithBool:NO]
                forKey:AVLinearPCMIsFloatKey];//采样信号是整数还是浮点数
    //创建录音对象
    self.recorder2 = [[AVAudioRecorder alloc]initWithURL:self.fileURL settings:settings error:nil];
    
}

- (IBAction)stopBtnPressed:(id)sender {
    if(self.recorder2.recording)
    {
        [self.recorder2 stop];
    }
    
    if(self.player2.playing)
    {
        [self.player2 stop];
    }
    
    self.label.text = @"停止中";
}
// App音频会话模式:
//AVAudioSessionCategoryAmbient         混音播放,可与其他音乐一起播放
//AVAudioSessionCategorySoloAmbient     后台播放，其他音乐停止
//AVAudioSessionCategoryPlayback        独占音乐播放
//AVAudioSessionCategoryRecord          录制
//AVAudioSessionCategoryPlayAndRecord   播放录制录制
//AVAudioSessionCategoryAudioProcessing 硬件解码器处理音频，期间不能播放和录制

- (IBAction)playBtnPressed:(id)sender {
    if(self.recorder2.recording)
    {
        return;
    }
    
    if(self.player2.playing)
    {
        return;
    }
    
    self.player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[self fileURL] error:nil];
    //设置当前App音频会话模式 为播放模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self.player2 play];
    self.label.text = @"播放中";
}









































@end
