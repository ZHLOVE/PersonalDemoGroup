//
//  TestClass.m
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "TestClass.h"

@implementation TestClass

// 没有参数没返回值
- (void)printInfo
{
    // __func__ C语言里的宏定义 代表当前正在执行的函数或方法
    NSLog(@"%s",__func__);
}

// 一个参数
- (void)printInfo2:(NSNumber *)a
{
    NSLog(@"%s %@",__func__,a);
}

// 两个参数无返回值
- (void)printInfo3:(NSNumber *)a andB:(NSNumber *)b
{
    NSLog(@"%s %@ %@",__func__,a,b);
}

// 两个参数，有返回值
- (NSNumber *)printInfo4:(NSNumber *)a andB:(NSNumber *)b
{
    int result = [a intValue] + [b intValue];
    
    return @(result);
}

@end
