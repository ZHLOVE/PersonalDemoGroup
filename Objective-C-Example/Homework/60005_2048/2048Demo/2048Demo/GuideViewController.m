//
//  GuideViewController.m
//  2048Demo
//
//  Created by 马千里 on 16/3/18.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "GuideViewController.h"

#import "GameViewController.h"
@interface GuideViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (strong,nonatomic) UIButton *btnEnter;
@property (nonatomic,weak) UIPageControl *pageControl;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat heigth = [UIScreen mainScreen].bounds.size.height;
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, width, heigth)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(width*3, heigth);
    
    for (int i = 1;i<4;i++ ) {
        NSString *imgStr = [NSString stringWithFormat:@"tutorial_%i",i];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgStr]];
        imageView.frame = CGRectMake(width*(i-1), 0, width, heigth);
        if (i == 3) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width/2-60, heigth-200, 118, 20)];
            label.text = @"点击进入2048";
            label.backgroundColor = [UIColor grayColor];
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            [imageView addSubview:label];
            //添加点击手势
            UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDo:)];
            tapR.numberOfTapsRequired = 1;// 连续点击次数
            tapR.numberOfTouchesRequired = 1;// 手指数量
            [self.view addGestureRecognizer:tapR];
        }
        [self.scrollView addSubview:imageView];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(width/2-10, heigth-10, 20, 10)];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1.00 green:0.51 blue:0.0 alpha:1.0];
    self.pageControl = pageControl;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:pageControl];
    
 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.pageControl.currentPage = scrollView.contentOffset.x/width;
}

- (void)tapDo:(UITapGestureRecognizer *)g
{
    //判断只在最后一页才响应
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self.scrollView.contentOffset.x/width == 2) {
        NSLog(@"进入2048");
        GameViewController *gameVC = [[GameViewController alloc]init];
        gameVC.modalPresentationStyle = UIModalPresentationFullScreen;// iPhone只有全屏方式
        gameVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:gameVC animated:YES];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




















@end
