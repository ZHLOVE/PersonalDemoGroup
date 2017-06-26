//
//  main.m
//  DataTypeDemo
//
//  Created by qiang on 16/1/26.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
#pragma mark 标识符
        /*
         enum   a+b    a-b    a_b    _ab   2abc   'abc'
         "abc"  <abc>  a2bc   abc*8
         */
        
#pragma mark 变量
        int x;// 声明一个整形变量，就是告诉计算机,当前函数中有这个变量
        x = 1;// 变量赋值,将1存入到变量中
        float y;
        y = 1.0;
        int z = 1;// 变量的声明和赋值连在了一起
        
#pragma mark 常量
        //下面都是常量，不可以被改变
        5;// 整形常量
        3.14;// 浮点型常量
        'C';// 字符型常量
        "SSSSS";// 字符串常量
        
    }
    return 0;
}
