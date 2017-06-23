//
//  ViewControllerD.m
//  Navi
//
//  Created by niit on 16/2/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerD.h"

#import "ViewControllerB.h"
#import "ViewControllerC.h"
#import "ViewControllera.h"


@interface ViewControllerD ()

@end

@implementation ViewControllerD

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    // self.navigationController.viewControllers 导航栏压入的所有视图控制器数组
    if(self.navigationController.viewControllers.count>2)
    {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}

- (IBAction)popToRoot:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
