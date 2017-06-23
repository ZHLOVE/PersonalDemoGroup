//
//  SummaryViewController.m
//  Calculation
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "SummaryViewController.h"

// 全局变量,定义在.m文件
// 统计总共计算了多少次
int calCount = 0;

@interface SummaryViewController ()

@end

@implementation SummaryViewController

// 将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.infoLabel.text = [NSString stringWithFormat:@"总共计算了%i次",calCount];
}

@end
