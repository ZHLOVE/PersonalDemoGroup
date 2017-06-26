//
//  Teacher.m
//  复制对象
//
//  Created by niit on 16/1/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher

- (id)copyWithZone:(nullable NSZone *)zone
{
    //1 创建一个新对象
    Teacher *newTeacher = [[[self class] allocWithZone:zone] init];
    //2 把当前值赋值给新对象
    newTeacher.name = _name;
    newTeacher.depart = _depart;
    //3 把新对象返回给调用者
    return newTeacher;
}
@end
