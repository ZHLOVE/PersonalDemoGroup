//
//  SJWavRecorder.m
//  ShiJia
//
//  Created by yy on 16/5/10.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "TPWavRecorder.h"

#import "TPFileOperation.h"

#define kAudioFilePath @"test.m4a"

@interface TPWavRecorder ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer   *player;
@property (nonatomic, copy)   NSString        *recordPath;
@property (nonatomic, readwrite, strong) NSData *recordData; //语音data
@property (nonatomic, readwrite, assign) CGFloat recordDuration;//语音时长

@end


@implementation TPWavRecorder

{
    NSTimer *recordTimer;
    int duration;
    
    //音频输入队列
    AudioQueueRef				_audioQueue;
}

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initRecorder];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(recordWasInterrupted:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)initRecorder
{
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 8000], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
                              [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: 16], AVLinearPCMBitDepthKey,
                              [NSNumber numberWithBool: NO], AVLinearPCMIsBigEndianKey,
                              [NSNumber numberWithBool: NO], AVLinearPCMIsFloatKey,
                              nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    self.recordPath = [TPFileOperation getVoiceMessagePathWithName:@"record.wav"];
    NSURL *fileUrl = [NSURL fileURLWithPath:self.recordPath];
    
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc]initWithURL:fileUrl settings:settings error:&error];
    self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder peakPowerForChannel:0];
}

#pragma mark - recorder operation
- (void)startRecord
{
    if (!self.recorder.isRecording) {
       
        duration = 0;
        
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
       
        if (recordTimer == nil) {
            recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        }
       
        [self.recorder record];
        [recordTimer fire];
    }
}

- (void)stopRecord
{
    if ([self.recorder isRecording]) {
        
        duration = 0;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        [recordTimer invalidate];
        recordTimer = nil;
        [self.recorder stop];
        self.recordData = [NSData dataWithContentsOfFile:self.recordPath];
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{

}

#pragma mark - play operation
- (void)play
{
    NSError *error;
    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.recordPath] error:&error];
    [self.player setVolume:1];
    [self.player prepareToPlay];
    [self.player setDelegate:self];
    [self.player play];
}

-(void)initPlayer
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
#pragma clang diagnostic pop
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    audioSession = nil;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[UIDevice currentDevice]setProximityMonitoringEnabled:NO];
    [self.player stop];
    self.player=nil;
}


#pragma mark - timer
- (void)handleTimer
{
    if (duration >= 60) {
        
        DDLogInfo(@"录音时间到");
        [self stopRecord];
        self.recordDuration = 60;
        duration = 0;
        if ([self.delegate respondsToSelector:@selector(didFinishRecording:duration:)]) {
            [self.delegate didFinishRecording:self.recordData duration:self.recordDuration];
        }
        self.recordData = nil;
        
    }
    else{
        //更新光谱图、音量
        [self.recorder updateMeters];
        [self volumeLevel];
        
        duration++;
        self.recordDuration = duration;
        if (duration >= 50) {
            [self.delegate startCountingDown];
        }
        DDLogInfo(@"已录了: %zd 秒",duration);
    }
}

- (CGFloat)volumeLevel
{
    float       level;                // The linear 0.0 .. 1.0 value we need.
    const float minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float       decibels    = [self.recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    DDLogInfo(@"volumeLevel:%f\n",level);
    if (self.recordVolumeChanged) {
        self.recordVolumeChanged(level);
    }
    return level;
}

#pragma mark - Notification
- (void)recordWasInterrupted:(NSNotification *)notification
{
    AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    switch (type)
    {
        case AVAudioSessionInterruptionTypeBegan:
        {
//            [self stopRecord];
            break;
        }
        case AVAudioSessionInterruptionTypeEnded:
        {
            AVAudioSessionInterruptionOptions option = [notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
            if (option == AVAudioSessionInterruptionOptionShouldResume)
            {
//                [self startRecord];
            }
            break;
        }
        default:
        {
            break;
        }
    }
    [self stopRecord];
}

@end
