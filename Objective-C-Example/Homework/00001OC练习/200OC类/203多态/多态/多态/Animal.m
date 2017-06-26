//
//  Animal.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Animal.h"

@implementation Animal

// 重载 从NSObject继承过来的 init方法
- (id)init
{
    self = [super init]; // 调用父类的初始化方法
    if(self)
    {
        // 本类的初始化代码
        self.name = @"一只动物";
    }
    return self;
}

// 唱歌
- (void)sing
{
    NSLog(@"%@ 正在唱歌",self.name);
}

@end
