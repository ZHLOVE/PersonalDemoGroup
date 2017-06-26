//
//  ViewController_B.m
//  Navi
//
//  Created by student on 16/2/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController_B.h"
#import "ViewController_A.h"
#import "ViewController_C.h"
#import "ViewController_D.h"
@interface ViewController_B ()

@end

@implementation ViewController_B

- (void)viewDidLoad {
    [super viewDidLoad];
    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftItem;
    //中间按钮
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"雪菜",@"扁尖"]];
    seg.frame = CGRectMake(0, 0, 100, 44);
    self.navigationItem.titleView = seg;
    //右侧按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
}



- (IBAction)pushA:(id)sender{
    ViewController_A *vA = [[ViewController_A alloc]init];
    [self.navigationController pushViewController:vA animated:YES];
}

- (IBAction)pushB:(id)sender{
    ViewController_B *vB = [[ViewController_B alloc]init];
    [self.navigationController pushViewController:vB animated:YES];
}

- (IBAction)pushC:(id)sender{
    ViewController_C *vC = [[ViewController_C alloc]init];
    [self.navigationController pushViewController:vC animated:YES];
}

- (IBAction)pushD:(id)sender{
    ViewController_D *vD = [[ViewController_D alloc]init];
    [self.navigationController pushViewController:vD animated:YES];
}

- (IBAction)pop:(id)sender
{
    // 1. 弹出当前页面
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)popTo2:(id)sender
{
    // 2. 弹出到指定的页面
    // viewControllers 导航栏压入的所有视图控制器数组
    if(self.navigationController.viewControllers.count>2)
    {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}

- (IBAction)popToRoot:(id)sender
{
    // 3. 弹出所有页面返回根
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
