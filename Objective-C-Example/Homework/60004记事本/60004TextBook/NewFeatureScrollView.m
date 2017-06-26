//
//  NewFeatureScrollView.m
//  60004TextBook
//
//  Created by 马千里 on 16/3/12.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NewFeatureScrollView.h"

#import "AppDelegate.h"

@interface NewFeatureScrollView ()<UIScrollViewDelegate>

@property (strong,nonatomic) IBOutlet UIButton *btnEnterWeibo;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

//@property (strong, nonatomic) IBOutlet UIView *loginView;


@end

@implementation NewFeatureScrollView

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imageNamesArray = @[@"1",@"2",@"3",@"4"];
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
//        NSLog(@"%@",imageView);
        imageView.frame = CGRectMake(width*i, 0, width, height);
        if (i == 3) {
            //设置进入微博按钮
            UIButton *btnEnter = [UIButton buttonWithType:UIButtonTypeCustom];
            //            btnEnterWB.frame = CGRectMake(width/2-180, height-285, 372, 85);
            btnEnter.frame = CGRectMake(width*3+width/4, height-65, width/2, 35);
            [btnEnter setTitle:@"进入记事本" forState:UIControlStateNormal];
            [btnEnter setTitle:@"进入记事本" forState:UIControlStateHighlighted];
            [btnEnter setBackgroundColor:[UIColor colorWithRed:1.00 green:0.51 blue:0.00 alpha:1.00]];
            [btnEnter addTarget:self action:@selector(btnEnterWB:) forControlEvents:UIControlEventTouchUpInside];
            self.btnEnterWeibo = btnEnter;
//            [self imageViewAddsubView:imageView];
            
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

- (IBAction)btnEnterWB:(UIButton *)sender {
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *appDelegate = app.delegate;
    [appDelegate loadNoteTableVC];

}



//- (void)imageViewAddsubView:(UIImageView*)imgView{
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    self.loginView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
//    self.loginView.frame = CGRectMake(0, height-186, width, 186);
//    [imgView addSubview:self.loginView];
//}


//- (IBAction)signInBtnPressed:(UIButton *)sender {
//    NSLog(@"登陆%s",__func__);
//    
//}


//- (IBAction)signUpBtnPressed:(UIButton *)sender {
//}

@end
