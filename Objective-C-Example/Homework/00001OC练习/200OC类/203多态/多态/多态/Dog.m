//
//  Dog.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Dog.h"

@implementation Dog

- (id)init
{
    self = [super init]; // 调用父类的初始化方法
    if(self)
    {
        // 本类的初始化代码
        self.name = @"汪星人";
    }
    return self;
}

- (void)sing
{
    NSLog(@"%@:汪汪汪汪汪汪汪汪汪",self.name);
}
@end
