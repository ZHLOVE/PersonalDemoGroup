//
//  main.m
//  HelloWorldDemo
//
//  Created by qiang on 16/1/26.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

// * 代码注释
// 1 单行注释 //
// 加注释、取消注释快捷键 cmd+/
// 2 多行注释 /*... */

// 引入头文件
#import <Foundation/Foundation.h>

// 程序入口函数
int main(int argc, const char * argv[])
{
    // 自动释放池
    @autoreleasepool
    {
        // 你的代码写在这里
        NSLog(@"Hello, World!");
    }
    // 程序返回,0代表程序正常运行了
    return 0;
}

// * 关于main函数
// main 一个特殊的函数,是程序的入口,程序从这个函数开始运行
// int 是保留字 代表整型
// ()里是2个参数
// int argc 传入的是有几个参数
// const char *argv[] 传入的参数具体内容

// * 自动释放池
//@autoreleasepool
//{
//}
// 池中的自动释放对象在池释放时释放

// * 日志输出
// printf("Hello, World!\n");
// NSLog(@"Hello, World!");
// NSLog()是Objective-C中Foundation基础框架提供的一个日志输出函数

// * return 0
// 程序返回,0代表程序正常运行了。

// 注意:
// C语言中每一条语句后面都必须有;号
// C语言中除了""引起来的地方及注释,其它任何地方都不能出现中文
// main函数中的return 0;可以写,也可以不写
// main函数前面的int可以写, 可以不写
// main函数后面的()不可以省略
// 不要把main写错了
// 同一程序中只能有一个main函数