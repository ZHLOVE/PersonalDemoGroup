//
//  ViewController.m
//  Animations例子
//
//  Created by student on 16/3/18.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 1. UIView视图切换动画
// 用于实现视图简单切换动画效果(默认有4种动画效果)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    // 翻转回来
    [UIView setAnimationRepeatAutoreverses:YES];
    // 动画方式
    [UIView setAnimationTransition:arc4random_uniform(4)+1 forView:self.view cache:YES];
    [UIView commitAnimations];
    
}

@end
