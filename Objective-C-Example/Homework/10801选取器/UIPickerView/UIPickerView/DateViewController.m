//
//  DateViewController.m
//  UIPickerView
//
//  Created by student on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  }


- (IBAction)btnPressed:(UIButton *)sender {
      //NSDate ->NSString
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy-MM-DD HH:MM:SS"];
    NSString *str = [f stringFromDate:self.datePicker.date];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"你所选的时间是" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)dateChange:(id)sender {
    
    NSDate *now = [NSDate date];
    NSTimeInterval t = [now timeIntervalSinceDate:self.datePicker.date];

    self.infoLabel.text = [NSString stringWithFormat:@"所选时间与当前时间间隔%g天",fabs(t/60.0/60.0/24.0)];
    

}
@end
