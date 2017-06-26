//
//  ViewController.m
//  网易新闻UIScrollView
//
//  Created by student on 16/2/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

//@property(nonatomic,strong)IBOutlet UIButton *lastBtn;

@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;

@property (nonatomic,weak) UIView *moveView;


@end



@implementation ViewController



- (void)viewDidLoad {
 
    [super viewDidLoad];
    
    NSArray *arr = @[@"头条",@"娱乐",@"热点",@"体育",@"无锡",@"订阅",@"财经",@"科技",@"汽车",@"时尚",@"图片",@"房产"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 360, 100)];
    //背景色
    scrollView.backgroundColor = [UIColor whiteColor];
    //设置内容尺寸,宽360，放12个Button
    scrollView.contentSize = CGSizeMake(360*2, 0);
    //隐藏滑动条
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    self.scrollView.delegate =self;
  
    for (int i =0; i<12; i++) {
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(60*i, 30, 45, 30)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(60*i, 30, 45, 30);
        btn.tag = i+1000;
        CGFloat r = arc4random()%255/255.0;
        CGFloat g = arc4random()%255/255.0;
        CGFloat b = arc4random()%255/255.0;
        btn.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:0.8];
//        btn.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
        //设文字
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        //设置被选中时候的颜色
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:btn];
//        self.lastBtn = [btn viewWithTag:1000];
      
    }
    
    [self.view addSubview:self.scrollView];

    // 添加滑动块
    UIView *moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 45, 4)];
    moveView.backgroundColor = [UIColor  grayColor];
    [scrollView addSubview:moveView];
    self.moveView = moveView;
}



- (IBAction)btnPressed:(UIButton *)sender {
    
//    NSLog(@"按钮%ld被点击了",sender.tag);
    // 1. 先将所有按钮取消选中状态

    for (UIButton *v in self.scrollView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            {
                UIButton *tmpBtn = v;
                tmpBtn.selected = NO;
            }
        }
    }
    // 2. 将当前按的按钮设置成选中状态
    sender.selected = YES;
    
//    UIButton *thisBtn = sender;
//    thisBtn.backgroundColor = [UIColor blackColor];
//    self.lastBtn.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.6];
//    self.lastBtn = thisBtn;
    // 3. 移动滑块
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    long int index = sender.tag - 1000;
    self.moveView.frame = CGRectMake(60*index, 60, 45, 4);
    [UIView commitAnimations];

    
}


@end
