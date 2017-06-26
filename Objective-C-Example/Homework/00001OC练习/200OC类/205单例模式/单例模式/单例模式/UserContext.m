//
//  UserContext.m
//  单例模式
//
//  Created by niit on 15/12/31.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "UserContext.h"

// static 静态变量.存储在存储区.该区域的数据在整个程序运行期间不会被释放。
// 静态全局变量 本模块的全局变量

// 2 定义一个这个类的静态变量指针
static UserContext *instance = nil;

@implementation UserContext

// 3 实现这个类方法
+ (UserContext *)sharedUserContext
{
    if(instance == nil)
    {
        // 第一次访问sharedUserContext，instance是nil,所以要创建。
        // 再次访问sharedUserContext,instance是静态全局变量,不会丢失,保持之前的值。则返回已创建的对象给调用者
        instance = [[UserContext alloc] init];
    }
    return instance;
}

@end
