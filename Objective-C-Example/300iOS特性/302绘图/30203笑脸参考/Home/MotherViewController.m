//
//  MotherViewController.m
//  Home
//
//  Created by Qiang on 15/3/2.
//  Copyright (c) 2015年 NIIT. All rights reserved.
//

#import "MotherViewController.h"

#import "HappinessViewController.h"

@interface MotherViewController ()
{
    int happy;
}
@end

@implementation MotherViewController

- (IBAction)btn1Pressed:(id)sender
{
    happy = 0;
    //按照某条连线进行跳转
    [self performSegueWithIdentifier:@"answer" sender:nil];
}

- (IBAction)btn2Pressed:(id)sender
{
    happy = 60;
    //按照某条连线进行跳转
    [self performSegueWithIdentifier:@"answer" sender:nil];
}

- (IBAction)btn3Pressed:(id)sender
{
    happy = 100;
    //按照某条连线进行跳转
    [self performSegueWithIdentifier:@"answer" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //将要跳转时将数值传递给它
    HappinessViewController *destVC=(HappinessViewController *)segue.destinationViewController;
    destVC.happiness = happy;
}


@end
