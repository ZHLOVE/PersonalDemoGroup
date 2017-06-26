//
//  ViewController.m
//  Demo
//
//  Created by student on 16/2/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak)IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak)IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 375, 210)];
    scrollView.backgroundColor = [UIColor blackColor];
    //设置内容尺寸
    scrollView.contentSize = CGSizeMake(375*6, 0);
    //分页
//    scrollView.pagingEnabled = YES;
    //隐藏滑动条
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    //设置代理
    self.scrollView.delegate = self;
    
    
    [self.view addSubview:scrollView];
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
    UIImageView *imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3"]];
    UIImageView *imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"4"]];
    UIImageView *imageView5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"5"]];
    UIImageView *imageView6 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"6"]];
    //设置内容位置
    imageView1.frame = CGRectMake(0, 0, 75, 210);
    imageView2.frame = CGRectMake(175, 0, 75, 210);
    imageView3.frame = CGRectMake(175*2, 0, 75, 210);
    imageView4.frame = CGRectMake(175*3, 0, 75, 210);
    imageView5.frame = CGRectMake(175*4, 0, 75, 210);
    imageView6.frame = CGRectMake(175*5, 0, 75, 210);
    //添加子视图
    [scrollView addSubview:imageView1];
    [scrollView addSubview:imageView2];
    [scrollView addSubview:imageView3];
    [scrollView addSubview:imageView4];
    [scrollView addSubview:imageView5];
    [scrollView addSubview:imageView6];
    //设置pageControl
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(375/2, 220, 20, 10)];
    pageControl.numberOfPages = 6;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x/375;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
