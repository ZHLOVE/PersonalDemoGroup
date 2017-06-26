# 例子代码

```objc
//
//  ViewController.m
//  ViewAndViewController
//
//  Created by niit on 16/1/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// 视图完成加载
- (void)viewDidLoad {
    // 先让父类的方法执行
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%s",__func__);
    
    // 1 创建
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
    view1.backgroundColor = [UIColor yellowColor];
    view1.tag = 101;
    [self.view addSubview:view1];
    
    // 2 通过tag再次找到这个视图
    UIView *tmpView = [self.view viewWithTag:101];
    tmpView.backgroundColor = [UIColor blackColor];

    
    // 3 视图位置
    // frame属性 坐标和大小
    // bounds属性 (0,0,宽，高)
//    view1.frame.origin.x = 100; 错误
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
    
    // 5 属性
    NSLog(@"view01的子视图:%@",view01.subviews);
    NSLog(@"view01:%@",view01);
    NSLog(@"view02的父视图:%@",view02.superview);
    
    // 6 移除
    [view03 removeFromSuperview];
    
    // 移除view01下的所有子view
    for (UIView *view in view01.subviews)
    {
        [view removeFromSuperview];
    }
    
    
    // 7 前后关系
    UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectMake(400,310,200,40)];
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
    
}

// 将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
    
}

// 已经显示
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
    
#warning 有问题，待会儿查看
    UILabel *tmpLabel = [self.view viewWithTag:103];
    tmpLabel.text = @"O(∩_∩)O哈哈~";
    
    NSLog(@"self.view的子视图:%@",self.view.subviews);
}

// 将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s",__func__);
}

// 已经消失
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%s",__func__);
}

//- (void)viewDidUnload
//{
//    
//}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideBtnPressed:(id)sender
{
    self.redView.hidden = !self.redView.hidden;
    [self.hideBtn setTitle:self.redView.hidden?@"取消隐藏":@"隐藏" forState:UIControlStateNormal];
    
}

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
//    [self.view insertSubview:labelA aboveSubview:labelC];
}

- (IBAction)sendBack:(id)sender
{
    UILabel *labelA  = [self.view viewWithTag:201];
    UILabel *labelB  = [self.view viewWithTag:202];
    UILabel *labelC  = [self.view viewWithTag:203];
    // 1
//    [self.view sendSubviewToBack:labelC];
    // 2
    [self.view insertSubview:labelC belowSubview:labelA];
}

- (IBAction)changeColor:(id)sender {
    
    // 参数0.0~1.0 随机色
    self.redView.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:(arc4random()%255)/255.0];
}
@end

```