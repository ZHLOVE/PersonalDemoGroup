//
//  Func.m
//  变量类型补充
//
//  Created by niit on 15/12/23.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Func.h"

// 定义外部变量(其他模块有个全局变量gNumber,这个模块要使用,需要进行声明)
// C语言下一般变量名命名会以g g_开头(global)
extern int gNumber;

void printSomething()
{
    gNumber = 200;
    printf("gNumber %i\n",gNumber);
}

void printABC()
{
    static int x = 0;
    
    // 加了static关键字后 为静态变量
    // 变量存放在静态存储区
    // 第一次会赋初值
    // 再次运行到这个定义的时候不会再给他赋值,它保持之前的数据
    
    printf("x= %i\n",x++);
}