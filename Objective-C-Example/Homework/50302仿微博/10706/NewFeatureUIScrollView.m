//
//  NewFeatureUIScrollView.m
//  10706
//
//  Created by student on 16/3/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NewFeatureUIScrollView.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface NewFeatureUIScrollView ()<UIScrollViewDelegate>

@property (strong,nonatomic) IBOutlet UIButton *btnEnterWeibo;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
//@property (strong,nonatomic)IBOutlet UITabBarController *tabBarController;

@end

@implementation NewFeatureUIScrollView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageNamesArray = @[@"new_feature_1",@"new_feature_2",@"new_feature_3",@"new_feature_4"];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.NewFeaturescrollView.frame = CGRectMake(0, 0, width,height);
    //背景色
    self.NewFeaturescrollView.backgroundColor = [UIColor whiteColor];
    //设置内容尺寸
    self.NewFeaturescrollView.contentSize = CGSizeMake(width*4, height);
    //隐藏滑动条
    self.NewFeaturescrollView.showsHorizontalScrollIndicator = NO;
    //分页
    self.NewFeaturescrollView.pagingEnabled = YES;
    //代理
    self.NewFeaturescrollView.delegate =self;
    
    for (int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageNamesArray[i]]];
        imageView.frame = CGRectMake(width*i, 0, width, height);
        if (i == 3) {
            //设置进入微博按钮
            UIButton *btnEnterWB = [UIButton buttonWithType:UIButtonTypeCustom];
//            btnEnterWB.frame = CGRectMake(width/2-180, height-285, 372, 85);
            btnEnterWB.frame = CGRectMake(width*3, height-285, 372, 85);
            [btnEnterWB setImage:[UIImage imageNamed:@"new_feature_button"] forState:UIControlStateNormal];
            [btnEnterWB setImage:[UIImage imageNamed:@"new_feature_button_highlighted"] forState:UIControlStateHighlighted];
            [btnEnterWB addTarget:self action:@selector(btnEnterWB:) forControlEvents:UIControlEventTouchUpInside];
             self.btnEnterWeibo = btnEnterWB;
//            [imageView addSubview:self.btnEnterWeibo]; 视图上面无法点击事件
        }
        [self.NewFeaturescrollView addSubview:imageView];
    }
    //设置pageControl
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(width/2-10, height-10, 20, 10)];
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1.00 green:0.51 blue:0.00 alpha:1.00];
    self.pageControl = pageControl;
    
    [self.view addSubview:self.NewFeaturescrollView];
    [self.NewFeaturescrollView addSubview:self.btnEnterWeibo];
    [self.view addSubview:pageControl];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.pageControl.currentPage = scrollView.contentOffset.x/width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnEnterWB:(UIButton *)sender {
//    HomeViewController *homeVC = [[HomeViewController alloc]init];
//    //窗口样式
//    homeVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    homeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    // 代码弹出视图控制器对象
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *appDelegate = app.delegate;
    [appDelegate loadMainTabBar];
    // 方式2: 模态窗口方式弹出
//        UITabBarController *tabBarController = [appDelegate mainTabBarController];
    //    [self presentViewController:tabBarController animated:YES completion:nil];
}

@end

















