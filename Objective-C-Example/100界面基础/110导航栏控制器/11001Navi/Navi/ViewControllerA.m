//
//  ViewControllerA.m
//  Navi
//
//  Created by niit on 16/2/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerA.h"

#import "ViewControllerB.h"
#import "ViewControllerC.h"
#import "ViewControllerD.h"

@interface ViewControllerA ()

@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@",self.navigationController.viewControllers);
}


- (IBAction)pushA:(id)sender
{
    ViewControllerA *vcA = [[ViewControllerA alloc] init];
    
    // self.navigationController 指向嵌这当前当前这个控制器的导航栏控制器对象
    // pushViewController 向导航栏压入一个新的控制器
    [self.navigationController pushViewController:vcA
                                         animated:YES];
}
- (IBAction)pushB:(id)sender
{
    ViewControllerB *vcB = [[ViewControllerB alloc] init];
    [self.navigationController pushViewController:vcB
                                         animated:YES];
}

- (IBAction)pushC:(id)sender
{
    ViewControllerC *vcC = [[ViewControllerC alloc] init];
    [self.navigationController pushViewController:vcC
                                         animated:YES];

}
- (IBAction)pushD:(id)sender
{
    ViewControllerD *vcD = [[ViewControllerD alloc] init];
    [self.navigationController pushViewController:vcD
                                         animated:YES];
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
