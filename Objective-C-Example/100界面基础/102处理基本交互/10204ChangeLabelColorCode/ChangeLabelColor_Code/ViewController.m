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
- (void)addButtonWithTitle:(NSString *)title
                  andFrame:(CGRect)frame
                    andTag:(int)tag
                  andColor:(UIColor *)color
{
    // 创建按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];// 必须要指定frame,否则不可见.
    // 设置按钮文字
    [btn setTitle:title forState:UIControlStateNormal];
    // 设置按钮文颜色
    [btn setTitleColor:color forState:UIControlStateNormal];
    // 设置按钮字体
//    btn.font = [UIFont systemFontOfSize:50]; //警告信息:deprecated 淘汰的属性或方法,仍旧可以使用，建议使用新的属性和方法替代
    btn.titleLabel.font = [UIFont systemFontOfSize:50];
    // 设置tag
    btn.tag = tag;
    // 添加按钮事件处理
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
    // 设定位置大小
    self.label.frame = CGRectMake(40, 40, 200, 50);
    // 设置文字
    self.label.text = @"一段文字";
    // 设置文字颜色
    self.label.textColor = [UIColor redColor];
    // 添加到self.view
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

@end
