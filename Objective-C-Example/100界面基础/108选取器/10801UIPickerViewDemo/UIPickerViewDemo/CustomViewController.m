//
//  CustomViewController.m
//  UIPickerViewDemo
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "CustomViewController.h"

// 添加音乐相关头文件
#import <AudioToolbox/AudioToolbox.h>

// 4

@interface CustomViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    // 声音ID
    SystemSoundID winSoundID;
    SystemSoundID normalSoundID;
    
}
@property (nonatomic,strong) NSArray *images;
@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.images = @[[UIImage imageNamed:@"apple"],
                    [UIImage imageNamed:@"bar"],
                    [UIImage imageNamed:@"cherry"],
                    [UIImage imageNamed:@"crown"],
                    [UIImage imageNamed:@"lemon"],
                    [UIImage imageNamed:@"seven"]];
}


- (IBAction)btnPressed:(id)sender
{
    BOOL win = NO;
    for (int i=0; i<5; i++)
    {
        // 随机
        int sel = arc4random()%6;
        // 设定i列的位置为sel
        [self.pickView selectRow:sel inComponent:i animated:YES];
        
        // 自己加入判断逻辑,如果有连续3个一样图案，就是赢了
        // ...
    }
    if(win)
    {
        [self playWinSound];
    }
    else
    {
        [self playNormalSound];
    }

}

//URL 统一资源定位符是对可以从互联网上得到的资源的位置和访问方法的一种简洁的表示，是互联网上标准资源的地址。互联网上的每个文件都有一个唯一的URL，
//NSURL 文件的网络位置(也可以是本地文件的位置)
#pragma mark 播放声音
- (void)playWinSound
{
    if(winSoundID == 0)// 如果还未注册
    {
        // 声音文件的位置
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"win" withExtension:@"wav"];
        // 注册短声音
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &winSoundID);
    }
    // 通过声音ID,播放声音
    AudioServicesPlayAlertSound(winSoundID);
}

- (void)playNormalSound
{
    if(normalSoundID == 0)
    {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"crunch" withExtension:@"wav"];
        // 注册短声音
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &normalSoundID);
    }
    AudioServicesPlayAlertSound(normalSoundID);
}

#pragma mark 为PickerView提供数据 及 处理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 6;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.images[row]];
    
    return imageView;
}

// 宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 52;
}
// 高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 46;
}
@end
