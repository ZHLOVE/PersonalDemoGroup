//
//  ViewController.m
//  test1
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// 代码方式将ViewController中的View为UIControl类对象
- (void)loadView
{
    UIControl *control = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setView:control];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = [UIColor redColor];

    // 添加事件
    UIControl *control = self.view;
    [control addTarget:self action:@selector(backgroundTap) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
}

- (void)backgroundTap
{
    // 关闭编辑状态
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
