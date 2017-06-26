//
//  ViewController.m
//  10510
//
//  Created by 马千里 on 16/2/21.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:205.0/255.0 alpha:1.0];
    self.subUiView.backgroundColor = [UIColor whiteColor];
    self.signInBtn.backgroundColor = [UIColor redColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTap:(id)sender {
    [self.view endEditing:YES];
}



- (IBAction)signInBtnPressed:(UIButton *)sender {
    NSString *name = self.userNameTextField.text;
    NSString *passwd = self.userPaswdTextField.text;
    NSString *verCode = self.verCode.text;
    
    UIAlertView *alertViewSussed = [[UIAlertView alloc]initWithTitle:nil message:@"登陆成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    UIAlertView *alertViewFaild = [[UIAlertView alloc]initWithTitle:nil message:@"登陆失败,用户名/密码/验证码错误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    if ([name isEqualToString:@"admin"]&&[passwd isEqualToString:@"123456"]) {
        [alertViewSussed show];
    }else{
        [alertViewFaild show];
    }
    
}
@end
