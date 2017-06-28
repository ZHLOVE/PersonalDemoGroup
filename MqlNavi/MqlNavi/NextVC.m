//
//  NextVC.m
//  MqlNavi
//
//  Created by MBP on 2017/4/14.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "NextVC.h"
#import "ViewController.h"
#import "UIViewController+NaviGradient.h"
@interface NextVC ()

@end

@implementation NextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
    self.title = @"导航条透明";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];


    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic.jpg"]];
    imgView.frame = self.view.frame;
    [self.view addSubview:imgView];

    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(toBackView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    [btn setTitle:@"GoNext" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navBarBgAlpha = @"0.0";
}


- (void)toBackView {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)toNextView {
    ViewController *nextVC = [[ViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
