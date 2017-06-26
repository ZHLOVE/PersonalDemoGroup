//
//  ViewController.m
//  LocalNotification
//
//  Created by student on 16/4/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNotiBtnPressed:(id)sender {
    [self addLocalNotification];
}

- (IBAction)cancelNotiBtnPressed:(id)sender {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *notis = app.scheduledLocalNotifications;
    for (UILocalNotification *n in notis)
    {
        NSDictionary *dict = n.userInfo;
        if([dict[@"notiId"] isEqualToString:@"1"])
        {
            n.applicationIconBadgeNumber --;
            [app cancelLocalNotification:n];
            
        }
    }
    
    // 取消所有
    //            [app cancelAllLocalNotifications];
}

- (void)addLocalNotification
{
    //有问题
    UILocalNotification *n = [[UILocalNotification alloc]init];
    //1触发时间
    n.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    n.timeZone = [NSTimeZone defaultTimeZone];
    //2是否要重复触发
    n.repeatInterval = 0;
    //kCFCalendarUnitMinute; 每分钟
    //3显示的信息
    n.alertBody = @"时间到了,洗洗睡吧";
    n.alertAction = @"时间到了,洗洗睡吧";
    //4 声音
    n.soundName = @"myMusic.caf";
    //5 角标
    n.applicationIconBadgeNumber = [UIApplication sharedApplication].scheduledLocalNotifications.count+1;
    //6 附带的信息
    n.userInfo = @{@"notiId":@"1"};
    //计划这个通知
    [[UIApplication sharedApplication] scheduleLocalNotification:n];
    
    
    
    
    
    
    
    
    
    
    
}

























@end
