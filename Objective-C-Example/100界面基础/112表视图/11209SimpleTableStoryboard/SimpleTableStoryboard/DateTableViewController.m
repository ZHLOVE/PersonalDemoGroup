//
//  DateTableViewController.m
//  SimpleTableStoryboard
//
//  Created by niit on 16/3/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DateTableViewController.h"

@interface DateTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    NSDate *d = [NSDate date];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterFullStyle];// 日期
    [f setTimeStyle:NSDateFormatterNoStyle];// 时间
    self.dateLabel.text = [f stringFromDate:d];
    [f setDateStyle:NSDateFormatterNoStyle];// 日期
    [f setTimeStyle:NSDateFormatterFullStyle];// 时间
    self.timeLabel.text = [f stringFromDate:d];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
