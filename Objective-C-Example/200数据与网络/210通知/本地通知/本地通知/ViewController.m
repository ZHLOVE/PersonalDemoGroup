//
//  ViewController.m
//  本地通知
//
//  Created by niit on 16/4/1.
//  Copyright © 2016年 NIIT. All rights reserved.
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
    NSLog(@"%s",__func__);
    [self addLocalNotification];
}

- (IBAction)cancelNotiBtnPressed:(id)sender
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *notis = app.scheduledLocalNotifications;
    
    for (UILocalNotification *n in notis)
    {
        NSDictionary *dict = n.userInfo;
        if([dict[@"notiId"] isEqualToString:@"1"])
        {
            [app cancelLocalNotification:n];

        }
    }
    
    // 取消所有
    //            [app cancelAllLocalNotifications];
    
    
}
- (void)addLocalNotification
{
    // 有问题
    UILocalNotification *n = [[UILocalNotification alloc] init];
    
    // 1. 触发的时间
    n.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    n.timeZone = [NSTimeZone defaultTimeZone];
    
    // 2. 是否要重复触发
    n.repeatInterval = 0;
    //kCFCalendarUnitMinute; 每分钟
    
    // 3. 显示的信息
//alertBody             是一串现 实提醒内容的字符串（NSString），如果alertBody未设置的话，Notification被激发时将不现实提醒。
//alertAction也         是一串字符（NSString），alertAction的内容将作为提醒中动作按钮上的文字(提醒在在设置中设置为中间的时候)，如果未设置的话，提醒信息中的动作按钮将显示为 “View”相对文字形式。
    n.alertBody = @"时间到了,洗洗睡吧";
    n.alertAction = @"去睡觉了";// 动作按钮上的文字(在通知设置为中间显示时才会显示按钮)
    
    // 4. 声音
    n.soundName = @"myMusic.caf";
    
    // 5. 角标
    n.applicationIconBadgeNumber = [UIApplication sharedApplication].scheduledLocalNotifications.count+1;
    
    // 6. 附带的信息
    n.userInfo = @{@"notiId":@"1"};
    
    // 计划这个通知
    [[UIApplication sharedApplication] scheduleLocalNotification:n];
    
    
//    // 可用
//    // 创建通知
//    UILocalNotification *n = [[UILocalNotification alloc] init];
//    
//    // 通知设置
//    
//    // 1 时间
//    n.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
//    // 时间的区域
//    //    n.timeZone = [NSTimeZone defaultTimeZone];
//    
//    // 2 是否循环重复触发
//    n.repeatInterval = 0;//kCFCalendarUnitMinute;
//    
//    // 3 内容
//    //alertBody              是一串现 实提醒内容的字符串（NSString），如果alertBody未设置的话，Notification被激发时将不现实提醒。
//    //alertAction也         是一串字符（NSString），alertAction的内容将作为提醒中动作按钮上的文字，如果未设置的话，提醒信息中的动作按钮将显示为 “View”相对文字形式。
//    n.alertBody = @"时间到了,洗洗睡吧A!";
//    n.alertAction = @"查看";
//    
//    // 4 声音
//    n.soundName = @"myMusic.caf";
//    
//    // 5 程序角标
//    n.applicationIconBadgeNumber = [UIApplication sharedApplication].scheduledLocalNotifications.count + 1;
//    
//    // 6 附带信息
//    n.userInfo = @{@"notiId":@"1"};
//    
//    // 计划这个通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:n];
//    
}

@end
