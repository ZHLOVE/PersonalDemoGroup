//
//  ViewController.m
//  NaviTouMing
//
//  Created by MBP on 16/7/13.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)titleLabel{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"透明导航条";
    [label sizeToFit];
    return label;
}

- (void)setUI{

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imgView.image = [UIImage imageNamed:@"BG.jpg"];
    [self.view addSubview:imgView];


    //自定义透明navigationBar
    UINavigationBar *navi = self.navigationController.navigationBar;
    navi.tintColor = [UIColor redColor];
    //设置导航条透明,注意只能设置UIBarMetricsDefault才能把分割线去掉
    [navi setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉分割线
    navi.translucent = YES;
    [navi setShadowImage:[UIImage new]];
//    self.navigationItem.titleView = [self titleLabel];
    self.navigationItem.title = @"透明导航条";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
@end
