//
//  main.m
//  NotificationDemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Teacher.h"
#import "Student.h"
#import "School.h"

#import "Father.h"
#import "Child.h"

#pragma mark - 通知的类
// 1 NSNotifiacaitonCenter (通知中心)
// 通知中心就一个，是单例对象 [NSNotificationCenter defaultCenter]

// 2 NSNotifiacaiton (通知)
//     name(通知名 NSString)
//     object(参数1 id)
//     userInfo(参数2 NSDictionary）

// 通知
// * 属于观察者模式

#pragma mark - 发送通知的方法
// 可以使用一下三个方法发通知
//- (void)postNotification:(NSNotification *)notification;
//- (void)postNotificationName:(NSString *)aName object:(id)anObject;
//- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
//anObject一般用来表示谁发送了这个消息。
//第一个方法直接把定义好的notification发出，notification的初始化方法如下：
//+ (id)notificationWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)userInfo
//第二个方法只定义了消息名和发消息者，没有传递实际的参数，貌似也可以把anObject自身作为消息传递出去，这个还没有搞懂。差不多就是作为observer可以回调poster。
//第三个方法指定消息名称，发消息者，并且传递了userInfo。也就相当于初始化了一个notification，并且用第一个方法发出。
//如果object：nil表示以广播方式发消息或者得到消息，这个时候只要消息名字是对的就可以得到这个消息。
//object：用来表示 谁发送的消息，或者从谁得到消息。
//参数应该在userInfo里面传递。
//NSNotification的作用是在同一程序的不同类中传递参数，传递的方法是把参数放在NSDictionary类型的userInfo中。


int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        // 教师对象
//        // 学生A 学生B 学生C
//        School *aSchool = [School schoolWithName:@"无锡市第一个中学"];
//        
//        Teacher *aTeacher = [[Teacher alloc] initWithName:@"李老师"];
//        
//        Student *stu1 = [[Student alloc] initWithName:@"小明"];
//        Student *stu2 = [[Student alloc] initWithName:@"张三"];
//        Student *stu3 = [[Student alloc] initWithName:@"李四"];
//        Student *stu4 = [[Student alloc] initWithName:@"王五"];
        
// 练习:
// 1 添加一个School类 学校类
// 定时发送通知
// a) 放假通知 学生和老师都要接收
//    通知名:@"Holiday"
//    通知内容:第几号文件,放假几号-几号
// b) 开会通知 老师接收
//    通知名:@"Meeting"
//    通知内容:第几号文件,某某部门到会议室开会。
// 老师和学生注册相应需要接收的通知及通知处理方法，并显示。

// 2 一个孩子对象 一个父亲对象
// 让父亲对象知道自己的孩子是谁(父亲类里创建孩子的弱引用，以便父亲类直接操作孩子对象)
// 孩子定时减少饥饿值，当饥饿值小于60,发出哭的通知
// 父亲注册接收哭的通知，处理。给孩子喂奶(修改孩子的饥饿值+100)
        Child *aChild = [[Child alloc] init];
        Father *aFather = [[Father alloc] init];
        
        [[NSRunLoop currentRunLoop] run];

    }
    return 0;
}
