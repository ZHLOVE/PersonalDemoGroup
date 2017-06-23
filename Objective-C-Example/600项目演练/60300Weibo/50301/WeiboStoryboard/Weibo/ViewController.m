//
//  ViewController.m
//  Weibo
//
//  Created by niit on 16/3/1.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1. 添加图片
    for (int i=0; i<4; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 568)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%i",i+1]];
        [self.scrollView addSubview:imgView];
    }
    
    // 2. 添加按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(320*3.5-372/2/2, 400, 372/2, 85/2)];
    [btn setBackgroundImage:[UIImage imageNamed:@"new_feature_button"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"new_feature_button_highlighted"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];

    // 3. 设置scrollView
    self.scrollView.contentSize = CGSizeMake(320*4,0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    // 4. 设置分页
    self.pageControl.numberOfPages = 4;
    self.pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
}

- (void)btnPressed
{
    NSLog(@"%s",__func__);
    
    // 沿着某条线跳转
    [self performSegueWithIdentifier:@"gotoMain" sender:nil];
}

#pragma mark -
// 滑动时改变分页控件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.scrollView.contentOffset.x/320.0;
}

@end
