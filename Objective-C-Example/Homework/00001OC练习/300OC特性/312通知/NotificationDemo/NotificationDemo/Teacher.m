//
//  Teacher.m
//  NotificationDemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Teacher.h"
#import "def.h"

@implementation Teacher
{
    int count;// 第几次作业
}

- (instancetype)initWithName:(NSString *)n
{
    self = [super init];
    if (self) {
        self.name = n;
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendHomework) userInfo:nil repeats:YES];
        
        
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHoliday:) name:kNotificationHoliday object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMeeting:) name:kNotificationMeeting object:nil];
    }
    return self;
}

- (void)sendHomework
{
    // 布置作业
    NSLog(@"%@:布置作业了！",self.name);
    
    // 作业内容
    // 第几次作业
    NSDictionary *dict = @{@"第几次":@(++count),
                           @"作业内容":@"第101页第1道题"};
    
    // 向通知中心发通知
//- (void)postNotificationName:(NSString *)aName                        // 通知名称
//                      object:(nullable id)anObject                    // 参数1 (对象)
//                    userInfo:(nullable NSDictionary *)aUserInfo;      // 参数2 (字典)
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificaitonHomeWork
//                                                        object:self
//                                                      userInfo:dict];
    
    NSNotification *noti = [NSNotification notificationWithName:kNotificaitonHomeWork object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}


- (void)showHoliday:(NSNotification *)n
{
    NSDictionary *dict = n.userInfo;
    
    NSLog(@"%@:%@ %@",self.name,dict[@"文件号"],dict[@"放假日期"]);
}

- (void)showMeeting:(NSNotification *)n
{
    NSDictionary *dict = n.userInfo;
    
    NSLog(@"%@ %@ %@开会",self.name,dict[@"文件号"],dict[@"部门"]);
}

- (void)dealloc
{
    // 3 从通知中心移除自己
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
