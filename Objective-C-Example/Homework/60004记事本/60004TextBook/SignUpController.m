//
//  SignUpController.m
//  60004TextBook
//
//  Created by 马千里 on 16/3/13.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "SignUpController.h"


@interface SignUpController ()

@end

@implementation SignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save{
   

}

- (IBAction)signUpBtnPress:(UIButton *)sender {
    NSMutableDictionary *userAccount = [NSMutableDictionary dictionary];
    [userAccount setObject:self.userNameTextField.text forKey:@"userName"];
    [userAccount setObject:self.passwdTextField.text forKey:@"passwd"];
    [userAccount setObject:self.emailTextField.text forKey:@"email"];
    
    if (self.userNameTextField.text.length && self.passwdTextField.text.length) {
        
   
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mArray = [NSMutableArray array];
    mArray = [[userDefault objectForKey:@"account"] mutableCopy];
    if (mArray == nil) {
        NSMutableArray *newArray = [NSMutableArray array];
        [newArray addObject:[userAccount copy]];
        [userDefault setObject:[newArray copy] forKey:@"account"];
        [userDefault synchronize];
    }else{
        [mArray addObject:[userAccount copy]];
        [userDefault setObject:[mArray copy] forKey:@"account"];
        [userDefault synchronize];
    }
    
    
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"注册成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAlertAction = [UIAlertAction actionWithTitle:@"寡人知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertControl  addAction:sureAlertAction];
    [self presentViewController:alertControl animated:YES completion:nil];
    }else{
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息没填" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAlertAction = [UIAlertAction actionWithTitle:@"寡人知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertControl  addAction:sureAlertAction];
        [self presentViewController:alertControl animated:YES completion:nil];

    }
}



- (IBAction)cancelBtnPress:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
