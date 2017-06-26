//
//  ViewController.m
//  UIScrollViewDemo
//
//  Created by student on 16/2/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 180)];
    view1.backgroundColor = [UIColor redColor];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(375, 0, 375, 180)];
    view2.backgroundColor = [UIColor blueColor];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(375*2, 0, 375, 180)];
    view3.backgroundColor = [UIColor greenColor];
    
    self.scrollView.frame = CGRectMake(0, 200, 375, 375);
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
    [self.scrollView addSubview:view3];
    //1 内容尺寸
    self.scrollView.contentSize = CGSizeMake(375*3, 0);
    self.scrollView.backgroundColor = [UIColor blackColor];
    //2 分页
    self.scrollView.pagingEnabled = YES;
    //3 是否反弹
    self.scrollView.bounces = YES;
    //4 滑动条样式
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 告诉代理人是谁，谁为它处理事件
    self.scrollView.delegate = self;
    
    //添加pageControll
    [self.view addSubview:self.pageControl];
    //1 总共有几页
    self.pageControl.numberOfPages = 3;
    //2 当前第几页
    self.pageControl.currentPage = 0;
    //3 颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
   
}


#pragma mark - 为scrollView提供事件处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%s",__func__);
    // 当前内容偏移的位置，计算当前是第几页
    // 内容偏移:contentOffset
    self.pageControl.currentPage = scrollView.contentOffset.x/375;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
