//
//  School.m
//  NotificationDemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "School.h"

#import "def.h"

@implementation School
{
    int count;
}

- (instancetype)initWithName:(NSString *)n
{
    self = [super init];
    if (self) {
        self.name = n;
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendNoti) userInfo:nil repeats:YES];
    }
    return self;
}

+ (instancetype)schoolWithName:(NSString *)n
{
    return [[[self class] alloc] initWithName:n];
}

- (void)sendNoti
{
    
    NSLog(@"学校发放假通知！");
    NSNotification *n1 = [NSNotification notificationWithName:kNotificationHoliday object:self userInfo:@{@"文件号":@(++count),@"放假日期":@"几号到几号"}];
    [[NSNotificationCenter defaultCenter] postNotification:n1];
    
    NSNotification *n2 = [NSNotification notificationWithName:kNotificationMeeting object:self userInfo:@{@"文件号":@(++count),@"部门":@"教学部"}];
    [[NSNotificationCenter defaultCenter] postNotification:n2];
}

@end
