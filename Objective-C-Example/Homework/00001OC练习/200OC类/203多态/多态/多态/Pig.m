//
//  Pig.m
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Pig.h"

@implementation Pig

- (id)init
{
    self = [super init]; // 调用父类的初始化方法
    if(self)
    {
        // 本类的初始化代码
        self.name = @"猪星人";
    }
    return self;
}

- (void)sing
{
    NSLog(@"%@:呼噜呼噜呼噜呼噜呼噜",self.name);
}

- (void)climbTree
{
    NSLog(@"%@:爬到树上睡觉.",self.name);
}

@end
