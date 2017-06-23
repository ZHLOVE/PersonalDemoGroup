//
//  ViewController.m
//  Net2
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import <TBXML.h>
#import <SVProgressHUD.h>

#import "NetManager.h"
#import "def.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 添加相关网络请求结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail:) name:kNotificationLoginFail object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)loginBtnPressed:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在登陆"];
    
    NetManager *net = [NetManager shareNetManager];
    [net loginWithUserName:self.usernameTextField.text andPassword:self.pwdTextField.text];
}

#pragma mark NetManagerDelegate Method

// 实现代理方法,更新界面信息
- (void)loginSuccess
{
    // 提示登陆成功
      [SVProgressHUD showWithStatus:@"登陆成功"];
      // 1s后跳转下以页面
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          // 隐藏HUD
          [SVProgressHUD dismiss];
          // 下一页
          [self performSegueWithIdentifier:@"gotoMain" sender:nil];
      });

}

- (void)loginFail:(NSNotification *)n
{
    NSError *error = n.userInfo[@"error"];
      [SVProgressHUD dismiss];
        NSString *message = [NSString stringWithFormat:@"错误信息:%@",[error localizedDescription]];
      // 登陆失败 显示错误信息
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *aciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          //[self dismissViewControllerAnimated:YES completion:nil];
          [self dismissViewControllerAnimated:YES completion:nil];
      }];
      [alert addAction:aciton];
      [self presentViewController:alert animated:YES completion:nil];
}


@end
