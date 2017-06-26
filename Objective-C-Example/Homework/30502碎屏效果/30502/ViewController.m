//
//  ViewController.m
//  30502
//
//  Created by student on 16/4/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import <AudioToolbox/AudioToolbox.h>
//#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
{
    // 定义一个系统声音ID
    SystemSoundID soundID;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *img = [UIImage imageNamed:@"home"];
    UIImageView *imgView= [[UIImageView alloc]initWithImage:img];
    imgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:imgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 摇一摇播放短声音(小于5s)
- (void)motionEnded:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event
{
        if(soundID == 0)
        {
            // 注册这个声音
            NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"glass" withExtension:@"wav"];
            // NSURL(Foundation OC语言) -> CFURLRef (CoreFoundation C语言)
            // 注册系统段声音
            AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(fileURL), &soundID);
        }
        // 播放
        AudioServicesPlaySystemSound(soundID);
    [self.view.subviews.lastObject removeFromSuperview];
    UIImage *img = [UIImage imageNamed:@"homebroken"];
    UIImageView *imgView= [[UIImageView alloc]initWithImage:img];
    imgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:imgView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIImage *img = [UIImage imageNamed:@"home"];
    UIImageView *imgView= [[UIImageView alloc]initWithImage:img];
    imgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:imgView];
}
@end
