//
//  Student.m
//  NotificationDemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Student.h"

#import "def.h"
#import "Teacher.h"

@implementation Student

- (instancetype)initWithName:(NSString *)n
{
    self = [super init];
    if (self) {
        self.name = n;
        
        // 2 向通知中心注册，我要接收通知
//        - (void)addObserver:(id)observer                  // 哪个对象要接受通知
//                   selector:(SEL)aSelector                // 通知来了什么方法处理
//                       name:(nullable NSString *)aName    // 什么通知?
//                     object:(nullable id)anObject;        // 附带对象
        
        // 向通知中心注册接收作业信息的通知
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(doHomework:) name:kNotificaitonHomeWork object:nil];
        // 向通知中心注册接收放假信息的通知
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(showHoliday:) name:kNotificationHoliday object:nil];
        
        // 对象向通知中心注册后，通知中心调度表里就有多一条记录，当有某对象发了这个类型通知，通知中心就会按照调度告知所有注册此类型通知的对象
        
        // 通知的处理可以用不同方法处理，也可以用同一个方法处理，然后在方法里判断一下noti.name是具体哪个通知
        
    }
    return self;
}

// 通知来了的处理
- (void)doHomework:(NSNotification *)noti
{
    // 把信息取出来
    Teacher *aTeacher = noti.object;
    NSDictionary *dict = noti.userInfo;//从userInfo属性取出一个字典
    
    NSLog(@"%@:好的，回去我会做%i作业:%@(%@的作业)",self.name,[dict[@"第几次"] intValue],dict[@"作业内容"],aTeacher.name);
}

- (void)showHoliday:(NSNotification *)n
{
    NSDictionary *dict = n.userInfo;
    
    NSLog(@"%@:%@ %@",self.name,dict[@"文件号"],dict[@"放假日期"]);
}


- (void)dealloc
{
//    - (void)removeObserver:(id)observer;  // 所有通知都不接收了
//    - (void)removeObserver:(id)observer name:(nullable NSString *)aName object:(nullable id)anObject; // 不接收某通知
    
    // 3 从通知中心移除自己
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
