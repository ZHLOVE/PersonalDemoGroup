//
//  DateViewController.m
//  UIPickerViewDemo
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()



@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed:(id)sender
{
    // NSDate -> NSString
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [f stringFromDate:self.datePicker.date];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你所选的时间是" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)dateChanged:(id)sender {
    
    NSDate *now = [NSDate date];
    NSTimeInterval t = [now timeIntervalSinceDate:self.datePicker.date];
    self.infoLabel.text = [NSString stringWithFormat:@"你所选的时间和当前时间的间隔%g天",fabs(t/60.0/60.0/24.0)];
}



@end
