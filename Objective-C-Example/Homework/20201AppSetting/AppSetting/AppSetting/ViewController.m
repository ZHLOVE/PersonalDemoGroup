//
//  ViewController.m
//  AppSetting
//
//  Created by student on 16/3/16.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrapLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrapSpeedLabel;

@property (weak, nonatomic) IBOutlet UILabel *favoriteTeaLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCandyLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteGameLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteExcuseLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteSinLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1. 程序载入的时候读取更新界面信息
    [self updateInfo];
    
    // 2. 监听程序进入前台的通知,更新界面信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSLog(@"%s",__func__);
    // 3. 第二个页面回来的时候，更新下界面信息
    [self updateInfo];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateInfo
{
    // 从NSUserDefaults中使用指定的key将信息读取处理
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@", [d objectForKey:@"username"]);
    NSLog(@"%@",[d valueForKey:@"password"]);
    
    self.usernameLabel.text = [d valueForKey:@"username"];
    self.passwordLabel.text = [d valueForKey:@"password"];
    self.protocolLabel.text = [d valueForKey:@"protocol"];
    self.wrapLabel.text = [d boolForKey:@"wrap"]?@"开":@"关";
    self.wrapSpeedLabel.text = [NSString stringWithFormat:@"%f",[d floatForKey:@"wrapSpeed"]];
    
    self.favoriteTeaLabel.text = [d valueForKey:@"favoriteTea"];
    self.favoriteCandyLabel.text = [d valueForKey:@"favoriteCandy"];
    self.favoriteGameLabel.text = [d valueForKey:@"favoriteGame"];
    self.favoriteExcuseLabel.text = [d valueForKey:@"favoriteExcuse"];
    self.favoriteSinLabel.text = [d valueForKey:@"favoriteSin"];
    
}

@end
