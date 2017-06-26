//
//  ViewController.m
//  ViewDemo
//
//  Created by student on 16/2/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
//    v1.bounds = CGRectMake(-30, -30, 100, 100); //修改bounds,x,y之后，影响子视图的位置
//    v1.bounds = CGRectMake(0, 0, 200, 200); //修改bounds,width,height之后，影响自己的frame,同时影响子视图的位置
    v1.backgroundColor = [UIColor redColor];
    [self.view addSubview:v1];
    
    UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    v2.backgroundColor = [UIColor greenColor];
    [v1 addSubview:v2];
    
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 100, 100)];
    v3.backgroundColor = [UIColor blueColor];
    //变换(缩放，旋转)
    v3.transform = CGAffineTransformScale(v3.transform, 0.5, 0.5);
    [self.view addSubview:v3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
