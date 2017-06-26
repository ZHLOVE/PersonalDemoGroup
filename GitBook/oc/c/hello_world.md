# Hello World!

```
//
//  main.m
//  HelloWorld
//
//  Created by qiang on 15/12/16.
//  Copyright © 2015年 Qiangtech. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}
```


#1 代码注释
####1) 单行注释 // (快捷键 cmd+/)
####2) 多行注释 /\* \*/

***

#2 引入头文件
```
#import <Foundation/Foundation.h>
```
引入Objective-C基础库头文件

在 Objective-C 中，#import 被当成 #include 指令的改良版本来使用。除此之外，#import 确定一个文件只能被导入一次，这使你在递归包含中不会出现问题。使用哪一个还是由你来决定。一般来说，在导入 Objective-C 头文件的时候使用 #import，包含 C 头文件时使用 #include。
***
#3 程序入口
```
int main(int argc, const char * argv[])
```
#####main 一个特殊的函数,程序的入口,程序从这个函数开始执行
#####int 是保留字 代表整型，代表函数的返回值类型
#####(int argc, const char * argv[])里是2个函数的参数
#####int argc 传入的是有几个参数
#####const char *argv[] 字符串数组,保存的是传入的参数具体内容 
***
#4 自动释放池
```
@autoreleasepool {

 }
```
池中的自动释放对象在池释放时释放
***
#5 NSLog日志输出
```
printf("Hello, World!\n");
NSLog(@"Hello, World!");
```
NSLog()是Objective-C中Foundation基础框架提供的一个日志输出函数
Foundation框架中的函数名、类名都以NS(NEXTSTEP)开头

#6 return 0
程序返回,0代表程序正常运行了。