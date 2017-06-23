//
//  ViewControllerC.m
//  Navi
//
//  Created by niit on 16/2/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerC.h"

#import "ViewControllerB.h"
#import "ViewControllerA.h"
#import "ViewControllerD.h"

@interface ViewControllerC ()

@end

@implementation ViewControllerC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 显示导航栏控制器自带工具栏
    self.navigationController.toolbarHidden = NO;
    
    // 设置工具栏上的按钮项
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self  action:@selector(showSomething)];
    self.toolbarItems = @[item1];
    
}

- (void)showSomething
{
    NSLog(@"hello");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)pushA:(id)sender
{
    ViewControllerA *vcA = [[ViewControllerA alloc] init];
    [self.navigationController pushViewController:vcA
                                         animated:YES];
}
- (IBAction)pushB:(id)sender
{
    ViewControllerB *vcB = [[ViewControllerB alloc] init];
    [self.navigationController pushViewController:vcB
                                         animated:YES];
}
- (IBAction)pushC:(id)sender {
    ViewControllerC *vcC = [[ViewControllerC alloc] init];
    [self.navigationController pushViewController:vcC
                                         animated:YES];
    
}
- (IBAction)pushD:(id)sender {
    
    ViewControllerD *vcD = [[ViewControllerD alloc] init];
    [self.navigationController pushViewController:vcD
                                         animated:YES];
    
}

- (IBAction)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)popTo2:(id)sender
{
    if(self.navigationController.viewControllers.count>2)
    {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}

- (IBAction)popToRoot:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 切换隐藏状态
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES] ;// 导航栏隐藏状态
    [self.navigationController setToolbarHidden:!self.navigationController.toolbarHidden animated:YES];// 工具栏隐藏状态
}
@end
