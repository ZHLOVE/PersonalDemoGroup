//
//  ViewController.m
//  Net2_Delegate
//
//  Created by student on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "def.h"
#import <TBXML.h>
#import <SVProgressHUD.h>
#import "NetManager.h"
@interface ViewController ()<NetManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passwd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //添加相关网络请求结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail:) name:kNotificationLoginFail object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (IBAction)loginBtnPressed:(id)sender {
    NetManager *net = [NetManager shareNetManager];
    net.delegate = self;
    [net loginWithUserName:self.userName.text andPasswd:self.passwd.text];
}

//登陆回调
- (void)loginSuccess{
    //提示登陆成功
    [SVProgressHUD showWithStatus:@"登陆成功"];
    //1s后跳转以下页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier:@"gotoNext" sender:nil];
    });
    
}
- (void)loginFail:(NSNotification *)n{
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
