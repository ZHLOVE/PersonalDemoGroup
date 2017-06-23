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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginBtnX1Pressed:(id)sender
{
    BOOL logined = [NetManager loginWithUserName:self.usernameTextField.text andPassword:self.pwdTextField.text];
    if(logined)
    {
        // 提示登陆成功
        [SVProgressHUD showWithStatus:@"登陆成功"];
        // 1s后跳转下以页面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 隐藏HUD
            [SVProgressHUD dismiss];
            // 跳转下一页
            [self performSegueWithIdentifier:@"gotoMain" sender:nil];
        });
    }
    else
    {
        // 登陆失败 显示错误信息
        NSString *message = @"登陆失败";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *aciton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:aciton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
