//
//  Cat.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Cat.h"

@implementation Cat

- (id)init
{
    self = [super init]; // 调用父类的初始化方法
    if(self)
    {
        // 本类的初始化代码
        self.name = @"喵星人";
    }
    return self;
}

- (void)sing
{
    NSLog(@"%@:瞄 喵喵喵喵喵喵喵",self.name);
//    NSLog(@"%@:瞄 喵喵喵喵喵喵喵",_name);// 不能，属性生成的_name属于Animal私有的实例变量
    
}

- (void)climbTree
{
    NSLog(@"%@:爬到树上看看有没有鸟蛋.",self.name);
}
@end
