//
//  ViewController.m
//  UIViewDemo
//
//  Created by niit on 16/2/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#pragma mark - alpha 透明度  和 hidden 隐藏
    // view.hidden = YES
    // view.alpha = 0.0 也是看不到
    
#pragma mark - frame 与 bounds(重要!)
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
//    NSLog(@"%@",NSStringFromCGRect(v1.bounds));// {{0,0},{100,100}}
//    v1.bounds = CGRectMake(-30, -30, 100, 100);// 修改bounds,x,y之后，影响子视图的位置
//    v1.bounds = CGRectMake(0, 0, 200, 200);// 修改bounds,width,height之后,影响自己的frame，同时影响了子视图在整体的位置
    // v1的左上角对于子视图的坐标起点是(-30,-30)
    v1.backgroundColor = [UIColor redColor];
    v1.clipsToBounds = YES;// 超出v1范围的内容,不显示
    [self.view addSubview:v1];
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    v2.backgroundColor = [UIColor greenColor];
    [v1 addSubview:v2];
    
#pragma mark - 变换(缩放、旋转、位移)
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 100, 100)];
    v3.backgroundColor = [UIColor blueColor];
//    v3.transform = CGAffineTransformScale(v3.transform, 1,0.5);
//    v3.transform = CGAffineTransformRotate(v3.transform, 0.2);
    v3.transform = CGAffineTransformTranslate(v3.transform, 20, 20);
    
    // transform 会改变frame,不改变bounds
    NSLog(@"%@",NSStringFromCGRect(v3.frame));
    NSLog(@"%@",NSStringFromCGRect(v3.bounds));
    [self.view addSubview:v3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
