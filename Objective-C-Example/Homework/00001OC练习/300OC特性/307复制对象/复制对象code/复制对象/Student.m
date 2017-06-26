//
//  Student.m
//  复制对象
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Student.h"

@implementation Student

- (instancetype)initWithId:(NSString *)tmpId andName:(NSString *)n andReward:(int)r
{
    self = [super init];
    if (self) {
        self.stuId = tmpId;
        self.stuName = n;
        self.reward = r;
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    // 具体复制的功能代码
    
    // 1 创建一个新的对象
    Student *stu = [[[self class] allocWithZone:zone] init];
    // 2 把原先对象的数据复制到新对象上去
    stu.stuId = _stuId;
    stu.stuName = _stuName;
    stu.reward = _reward;
    // 3 把新建的对象返回给调用者
    
    return stu;
}

// 如果定义实现了 - (NSString *)description，使用NSLog(@"%@",对象);打印对象，显示的是这个方法返回的结果。
- (NSString *)description
{
    return [NSString stringWithFormat:@"学号:%@ 姓名:%@ 成绩:%i",self.stuId,self.stuName,self.reward];
}
@end
