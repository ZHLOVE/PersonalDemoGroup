//
//  ViewController.m
//  UIView
//
//  Created by qiang on 16/1/29.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%s",__func__);
    
#pragma mark UIView的基本属性方法
    // 1 创建
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
    view1.backgroundColor = [UIColor yellowColor];
    view1.tag = 101;
    [self.view addSubview:view1];
    
    // 2 通过tag再次找到这个视图
    UIView *tmpView = [self.view viewWithTag:101];
    tmpView.backgroundColor = [UIColor blackColor];// 背景色
    
    // 3 视图位置
    // frame属性 坐标和大小
    // bounds属性 (0,0,宽，高)
    //    view1.frame.origin.x = 100; 错误!
    CGRect frame = view1.frame;
    frame.origin.x = 120;
    view1.frame = frame;
    
    // 4 嵌套
    UIView *view01 = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    UIView *view02 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    UIView *view03 = [[UIView alloc] initWithFrame:CGRectMake(0, 50,40,40)];
    UIView *view04 = [[UIView alloc] initWithFrame:CGRectMake(40,50,40,40)];
    
    view01.backgroundColor = [UIColor blueColor];
    view02.backgroundColor = [UIColor redColor];
    view03.backgroundColor = [UIColor yellowColor];
    view04.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:view01];
    [view01 addSubview:view02];
    [view01 addSubview:view03];
    [view01 addSubview:view04];
    
    NSLog(@"%@",self.view.subviews);
    
    // 5 父视图、子视图
    //    NSLog(@"view01的子视图:%@",view01.subviews);
    //    NSLog(@"view01:%@",view01);
    //    NSLog(@"view02的父视图:%@",view02.superview);
    
    // 6 移除
    [view03 removeFromSuperview];
    
    // 移除view01下的所有子view
//    for (UIView *view in view01.subviews)
//    {
//        [view removeFromSuperview];
//    }
    
    // 7 前后置关系
    UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectMake(0,310,200,40)];
    labelA.text = @"A";
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(15,325,200,40)];
    labelB.text = @"B";
    UILabel *labelC = [[UILabel alloc] initWithFrame:CGRectMake(30,340,200,40)];
    labelC.text = @"C";
    labelA.textAlignment = NSTextAlignmentLeft;
    labelB.textAlignment = NSTextAlignmentLeft;
    labelC.textAlignment = NSTextAlignmentLeft;
    labelA.backgroundColor = [UIColor redColor];
    labelB.backgroundColor = [UIColor greenColor];
    labelC.backgroundColor = [UIColor blueColor];
    [self.view addSubview:labelA];
    [self.view addSubview:labelB];
    [self.view addSubview:labelC];
    
    labelA.tag = 201;
    labelB.tag = 202;
    labelC.tag = 203;
    
#warning 注意:经测试，如果采用AutoLayout Size,可能会遇到StoryBoard上放置的控件在ViewDidAppear才创建好的，问题，把Size classes取消又打开。又可以了。
    UILabel *tmpLabel = [self.view viewWithTag:103];
    tmpLabel.text = @"O(∩_∩)O哈哈~";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
    NSLog(@"%@",self.view.subviews);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
    
    // 通过tag查找视图对象
//    UILabel *tmpLabel = [self.view viewWithTag:103];
//    tmpLabel.text = @"O(∩_∩)O哈哈~";
    
    NSLog(@"self.view的子视图:%@",self.view.subviews);
}

- (IBAction)hideBtnPressed:(id)sender
{
    self.redView.hidden = !self.redView.hidden;
    [self.hideBtn setTitle:self.redView.hidden?@"取消隐藏":@"隐藏" forState:UIControlStateNormal];
}

// 往前放
- (IBAction)bringFront:(id)sender
{
    UILabel *labelA  = [self.view viewWithTag:201];
    UILabel *labelB  = [self.view viewWithTag:202];
    UILabel *labelC  = [self.view viewWithTag:203];
    
    // 1
    //    [self.view addSubview:labelA];
    // 2
    [self.view bringSubviewToFront:labelA];
    // 3
        [self.view insertSubview:labelA aboveSubview:labelC];
}

// 往后放
- (IBAction)sendBack:(id)sender
{
    UILabel *labelA  = [self.view viewWithTag:201];
    UILabel *labelB  = [self.view viewWithTag:202];
    UILabel *labelC  = [self.view viewWithTag:203];
    // 1
    [self.view sendSubviewToBack:labelC];
    // 2
//    [self.view insertSubview:labelC belowSubview:labelA];
}

- (IBAction)changeColor:(id)sender {
    
    // UIColor
    // 参数0.0~1.0 随机色
    self.redView.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:(arc4random()%255)/255.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
