//
//  ViewController.m
//  10302FlashView
//
//  Created by student on 16/1/29.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end



@implementation ViewController

- (void)addButtonWithTitle:(NSString *)title andFrame:(CGRect)frame andTag:(int)n andColor:(UIColor *)color
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.tag = 1;
    [btn addTarget:self
            action:@selector(creatView:)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)creatView:(UIButton *)sender{
//    CGRect rect = [UIScreen mainScreen].bounds;
//    CGSize size = rect.size;//屏幕大小+80

    CGFloat x = arc4random()%335;
    CGFloat y = arc4random()%507 + 120;
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(x,y,40,40)];
    CGFloat red = (arc4random()%256)/256.0;
    CGFloat green = (arc4random()%256)/256.0;
    CGFloat blue = (arc4random()%256)/256.0;
    [aView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.6]];
    [self.view addSubview:aView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButtonWithTitle:@"creatView" andFrame:CGRectMake(120, 60, 150, 20) andTag:1 andColor:[UIColor blackColor]];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
