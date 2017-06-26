//
//  ClassB.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "ClassB.h"

@implementation ClassB

// 方法名、参数个数及类型、返回值类型都与父类的方法相同
// 重载、重写、覆盖(override) 子类定义的方法会覆盖父类的方法
- (void)initVal
{
    // 如果需要的情况，可以先调用父类的initVal
//    [super initVal];
    
    // 执行本类的相关代码
    y = 20;
    NSLog(@"x = %i",x);
}

- (void)printInfo
{
    y=20;
    NSLog(@"%i,%i",x,y);
}



@end
