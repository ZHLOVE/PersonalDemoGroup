//
//  ViewControllerE.m
//  PresentViewController
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerE.h"

@interface ViewControllerE ()


@end

@implementation ViewControllerE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.resultLabel.text = [NSString stringWithFormat:@"%i",self.num];
}

- (IBAction)cancelBtnPressed:(id)sender
{
    // 取消当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)popEBtnPressed:(id)sender
{
    // 创建一个ViewControllerE对象
    ViewControllerE *vcE = [[ViewControllerE alloc] init];// init时会查找同名的nib对对象进行初始化
    
    // 窗口样式
    vcE.modalPresentationStyle = UIModalPresentationFullScreen;// iPhone只有全屏方式
    vcE.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 切换动画方式
    //    UIModalTransitionStyleCoverVertical = 0,
    //    UIModalTransitionStyleFlipHorizontal __TVOS_PROHIBITED,
    //    UIModalTransitionStyleCrossDissolve,
    //    UIModalTransitionStylePartialCurl NS_ENUM_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED,
    
    // 代码弹出视图控制器对象
    [self presentViewController:vcE animated:YES completion:nil];
}

@end
