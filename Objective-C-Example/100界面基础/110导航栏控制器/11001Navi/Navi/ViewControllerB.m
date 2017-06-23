//
//  ViewControllerB.m
//  Navi
//
//  Created by niit on 16/2/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerB.h"

#import "ViewControllerA.h"
#import "ViewControllerC.h"
#import "ViewControllerD.h"

@interface ViewControllerB ()

@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // 1 左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];
//    UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationItem.leftBarButtonItems = @[leftItem,leftItem2];
    
    // 2 中间标题
//    self.title = [NSString stringWithFormat:@"%i",self.navigationController.viewControllers.count];
    // =>
    //self.navigationItem.title
    //self.tabBarItem.title
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"鸡腿",@"大排"]];
    seg.frame = CGRectMake(0, 0, 100, 30);
    self.navigationItem.titleView = seg;
    
    // 3 右侧按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@",self.navigationController.viewControllers);
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
