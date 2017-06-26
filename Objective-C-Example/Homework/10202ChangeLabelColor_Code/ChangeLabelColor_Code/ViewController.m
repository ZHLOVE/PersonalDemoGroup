//
//  ViewController.m
//  ChangeLabelColor_Code
//
//  Created by niit on 16/1/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// 将创建按钮的代码封装成一个方法
- (void)addButtonWithTitle:(NSString *)title andFrame:(CGRect)frame andTag:(int)tag andColor:(UIColor *)color
{
    // 创建按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    // 设置按钮文字
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
//    btn.font = [UIFont systemFontOfSize:50]; //deprecated 过时的属性或方法,在新版本里仍旧可以使用。
    btn.titleLabel.font = [UIFont systemFontOfSize:50];
    btn.tag = tag;
    
    // 添加事件处理
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

// 视图控制器的生命周期
// viewDidLoad 当视图载入的时候
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建Label
    self.label = [[UILabel alloc] init];
    self.label.frame = CGRectMake(40, 40, 200, 50);
    self.label.text = @"一段文字";
    self.label.textColor = [UIColor redColor];
    [self.view addSubview:self.label];
    
    // 创建3个按钮
    [self addButtonWithTitle:@"红色" andFrame:CGRectMake(25, 150, 100, 50) andTag:1 andColor:[UIColor redColor]];
    [self addButtonWithTitle:@"绿色" andFrame:CGRectMake(125, 150, 100, 50) andTag:2 andColor:[UIColor greenColor]];
    [self addButtonWithTitle:@"蓝色" andFrame:CGRectMake(225, 150, 100, 50) andTag:3 andColor:[UIColor blueColor]];
    
}

- (void)btnPressed:(UIButton *)sender
{
    NSLog(@"%@",sender);
    
    switch (sender.tag) {
        case 1:
            self.label.textColor = [UIColor redColor];
            break;
        case 2:
            self.label.textColor = [UIColor greenColor];
            break;
        case 3:
            self.label.textColor = [UIColor blueColor];
            break;
           
        default:
            break;
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
