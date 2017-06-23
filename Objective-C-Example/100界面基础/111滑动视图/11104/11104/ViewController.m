//
//  ViewController.m
//  11104
//
//  Created by niit on 16/3/1.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,weak) UIScrollView *scrollView;

@property (nonatomic,weak) UIView *moveView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 22, 320, 50)];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    // 添加按钮
    for (int i=0; i<10; i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80*i, 0, 80, 50)];
        [btn setTitle:[NSString stringWithFormat:@"新闻%i",i+1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i==0)
        {
            btn.selected = YES;
        }
        
        [scrollView addSubview:btn];
    }
    
    // 添加滑动块
    UIView *moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 80, 10)];
    moveView.backgroundColor = [UIColor redColor];
    [scrollView addSubview:moveView];
    self.moveView = moveView;
    
    // 设置scrollView的内容尺寸
    scrollView.contentSize = CGSizeMake(80*10, 50);
    self.scrollView = scrollView;
    
}

- (void)btnPressed:(UIButton *)sender
{
    // 1. 先将所有按钮取消选中状态
    for (UIView *v in self.scrollView.subviews)
    {
        if([v isKindOfClass:[UIButton class]])
        {
            UIButton *tmpBtn = v;
            tmpBtn.selected = NO;
        }
    }
    // 2. 将当前按的按钮设置成选中状态
    sender.selected = YES;
    
    // 3. 移动滑块
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    int index = sender.tag - 100;
    self.moveView.frame = CGRectMake(80*index, 40, 80, 10);
    [UIView commitAnimations];
}

@end
