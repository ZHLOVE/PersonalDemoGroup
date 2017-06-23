//
//  ViewControllerB.m
//  TransValue
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerD.h"

@interface ViewControllerD ()

@end

@implementation ViewControllerD


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    // 纯代码方式下的代码，不用xib,不用storyboard
//    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(70, 70, 180, 180)];
//    label.text = @"B";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:80];
//    [self.view addSubview:label];
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(140, 250, 100, 50)];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%s",__func__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%s",__func__);
}

- (void)dealloc
{
    NSLog(@"%s",__func__);     
}


- (IBAction)backBtnPressed:(id)sender
{
    // 回到前一页面
    [self.navigationController popViewControllerAnimated:YES];
}


@end
