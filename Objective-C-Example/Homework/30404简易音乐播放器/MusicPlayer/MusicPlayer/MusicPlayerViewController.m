//
//  MusicPlayerViewController.m
//  MusicPlayer
//
//  Created by student on 16/4/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "MusicPlayerViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface MusicPlayerViewController ()<AVAudioPlayerDelegate>




@property (weak, nonatomic) IBOutlet UIImageView *musicPlayerImgView;
@property (weak, nonatomic) IBOutlet UIButton *lyricBtn;//歌词
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicSingerLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *infoPlayLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoPlayLeftLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UIView *viewAction;

//声音
@property (nonatomic,assign) SystemSoundID soundID;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,assign) NSTimeInterval playTime;
@property (nonatomic,assign) BOOL playing;
@end

@implementation MusicPlayerViewController

SingletonM(MusicPlayerViewController)



- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //目前点进来同一首歌会从头播放
    [self playingMusic:self.music];
}

- (void)playingMusic:(Music *)music{
    //如果歌名相同就不重新播放
    if (self.musicNameLabel.text != music.name) {
        self.musicNameLabel.text = music.name;
        self.musicSingerLabel.text = music.singer;
        NSString *imgName = music.icon;
        self.musicPlayerImgView.image = [UIImage imageNamed:imgName];
        [self showMeTheUI];
        //播放音乐
        NSURL *fileName = [[NSBundle mainBundle]URLForResource:music.filename withExtension:nil];
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileName error:nil];
        self.slider.maximumValue = self.player.duration;// 时长
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
        [self.player play];
        self.playing = YES;
    }else if (!self.playing){
        //同一首歌结束并且没有换歌,执行以下代码
        self.musicNameLabel.text = music.name;
        self.musicSingerLabel.text = music.singer;
        NSString *imgName = music.icon;
        self.musicPlayerImgView.image = [UIImage imageNamed:imgName];
        [self showMeTheUI];
        //播放音乐
        NSURL *fileName = [[NSBundle mainBundle]URLForResource:music.filename withExtension:nil];
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileName error:nil];
        self.slider.maximumValue = self.player.duration;// 时长
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
        [self.player play];
    }else{
        
    }
        
    
    self.player.delegate = self;
}

-(IBAction)backUp:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 播放/暂停
- (IBAction)playMusic:(UIButton *)sender{
    if (self.playing) {
         [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.player pause];
        self.playTime = self.player.currentTime;
        self.playing = NO;
    }else{
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.player play];
        self.player.currentTime = self.playTime;
        self.playing = YES;
    }
}

// 更新信息
- (void)updateInfo
{
    self.slider.value = self.player.currentTime;
    // 获得音频文件总时间
    NSTimeInterval duration = self.player.duration;
    // 获得分
    int minute = (int)duration / 60;
    int currentMin = (int)self.player.currentTime / 60;
    // 获得秒
    int currentSec = (int)self.player.currentTime % 60;
    int second = (int)duration % 60;
    self.infoPlayLabel.text = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    self.infoPlayLeftLabel.text = [NSString stringWithFormat:@"%02d:%02d",currentMin,currentSec];
}

// 修改当前播放进度
- (IBAction)sliderChanged:(id)sender
{
    self.player.currentTime = self.slider.value;
}

//播放结束时候调用代理方法,重复播放
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
     self.playing = NO;//表示播放停止
    [self playingMusic:self.music];
   
}
//上一首
- (IBAction)previousBtnPressed:(id)sender{
    if (self.num == 0) {
        self.num = (self.musicArray.count-1);
    }else{
        self.num--;
    }
    Music *music = self.musicArray[self.num];
    self.music = music;
    [self playingMusic:music];
//    NSLog(@"%@",music.name);
}
//下一首
- (IBAction)nextBtnPressed:(id)sender{
    if (self.num == (self.musicArray.count-1)) {
        self.num = 0;
    }else{
        self.num ++;
    }
    Music *music = self.musicArray[self.num];
    self.music = music;
    [self playingMusic:music];
//    NSLog(@"%@",music.name);
}

//界面显示
- (void)showMeTheUI{
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [self.previousBtn setBackgroundImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [self.lyricBtn setBackgroundImage:[UIImage imageNamed:@"lyric_normal"] forState:UIControlStateNormal];
    [self.viewInfo setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3]];
    [self.viewAction setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.5]];
    //设置滑动条样式
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"point_selected"] forState:UIControlStateHighlighted];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"point_normal"] forState:UIControlStateNormal];
    
    //控件触发的方法
    [self.playBtn addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.previousBtn addTarget:self action:@selector(previousBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
}
@end
