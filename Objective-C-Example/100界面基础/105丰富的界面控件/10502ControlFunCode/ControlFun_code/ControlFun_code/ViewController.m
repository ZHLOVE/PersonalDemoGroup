//
//  ViewController.m
//  ControlFun_code
//
//  Created by niit on 16/2/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,weak) UITextField *usernameTextField;
@end

@implementation ViewController


// self.view  UIView类->UIControl类
- (void)loadView
{
    UIControl *control = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setView:control];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
    self.usernameTextField = textField;
    
    UIControl *control = self.view;
    [control addTarget:self action:@selector(backgroundTap) forControlEvents:UIControlEventTouchDown];
}

- (void)backgroundTap
{
//    [self.view endEditing:YES];

#pragma mark 第一响应者
    // 第一响应者 理解为当前获得焦点的对象
    // 取消第一响应者
    [self.usernameTextField resignFirstResponder];
    
//    - (nullable UIResponder*)nextResponder; // 下一个响应者，一般是父级对象
//    
//    - (BOOL)canBecomeFirstResponder;    // 判断对象能否成为第一响应者
//    - (BOOL)becomeFirstResponder;       // 设置为第一响应者
//    
//    - (BOOL)canResignFirstResponder;    // 判断能否取消第一响应者
//    - (BOOL)resignFirstResponder;       // 取消第一响应者
//    
//    - (BOOL)isFirstResponder;           // 判断当前是否为第一响应者
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
