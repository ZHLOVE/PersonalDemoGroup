//
//  ViewController2.m
//  AppSettingsDemo
//
//  Created by niit on 16/3/16.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet UISlider *wrapSpeedSlider;

@property (weak, nonatomic) IBOutlet UISwitch *wrapSwitch;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 更新界面信息
    [self updateInfo];
    
    // 监听程序进入前台的通知,在系统且回到本程序时，更新以下界面信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc
{
    // 移除通知(必要!)
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateInfo
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    self.wrapSwitch.on = [d boolForKey:@"wrap"];
    self.wrapSpeedSlider.value = [d floatForKey:@"wrapSpeed"];
}

- (IBAction)backBtnPressed:(id)sender
{
    // 关闭模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchChanged:(UISwitch *)sender
{
    // 设置设置值
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setBool:sender.on forKey:@"wrap"];
    [d synchronize];
}
- (IBAction)sliderChanged:(UISlider *)sender
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setFloat:sender.value forKey:@"wrapSpeed"];
    [d synchronize];
}


@end
