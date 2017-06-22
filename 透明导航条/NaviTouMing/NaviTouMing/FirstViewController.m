//
//  FirstViewController.m
//  NaviTouMing
//
//  Created by MBP on 16/7/13.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"


@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"下一页" style:UIBarButtonItemStylePlain target:self action:@selector(btnPressed:)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage new] style:UIBarButtonItemStylePlain target:self action:@selector(btnPressed:)];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


- (void)btnPressed:(id)sender{
    NSLog(@"%@",sender);
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UINavigationBar *)customNavigationBar{
    //自定义透明navigationBar
    UINavigationBar *navi = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];;
    navi.tintColor = [UIColor redColor];
    //设置导航条透明,注意只能设置UIBarMetricsDefault才能把分割线去掉
    [navi setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉分割线 
    navi.translucent = YES;
    [navi setShadowImage:[UIImage new]];
    return navi;
}
@end
