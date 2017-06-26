//
//  Person.m
//  属性
//
//  Created by niit on 15/12/24.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Person.h"

@implementation Person

// @synthesize  可以指定属性名对应的实例变量名
@synthesize age=_age;

// 你写的setter方法会覆盖掉属性帮你生成的setter方法
// 不要在setter get方法里使用self.属性名 应该用实例变量名
- (void)setAge:(int)a
{
    if(a>=1 && a<120)
    {
        _age= a;
    }
    else
    {
        _age = 1;
    }
}

- (int)age
{
    return _age*10;
}

- (void)printInfo
{
    NSLog(@"%i岁",self.age);//=>  NSLog(@"%i岁",[self age]); // 180
    NSLog(@"%i岁",_age);
}

@end
