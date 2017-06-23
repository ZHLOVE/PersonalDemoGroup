//
//  FatherViewController.m
//  Home
//
//  Created by Qiang on 15/3/2.
//  Copyright (c) 2015年 NIIT. All rights reserved.
//

#import "FatherViewController.h"

#import "HappinessViewController.h"

@interface FatherViewController ()

@end

@implementation FatherViewController


#pragma mark - Navigation


//将要沿着连线进行跳转的时候执行
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //segue 连线
    //两个重要属性
    //identifier 连线的名字
    //destinationViewController 目标视图控制器
    
    HappinessViewController *destVC=(HappinessViewController *)segue.destinationViewController;
    
    if([segue.identifier isEqualToString:@"answer1"])
    {
        destVC.happiness = 0;
    }
    else     if([segue.identifier isEqualToString:@"answer2"])
    {
        destVC.happiness = 60;
    }
    else
    {
        destVC.happiness = 100;
    }

    
}


@end
