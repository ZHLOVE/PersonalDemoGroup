//
//  main.m
//  类方法
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClassA.h"
#import "CommFunc.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
        // 例子1
//        ClassA *a = [[ClassA alloc] init];
//        ClassA *b = [[ClassA alloc] init];
//        ClassA *c = [[ClassA alloc] init];
//        ClassA *d = [[ClassA alloc] init];
//        ClassA *e = [[ClassA alloc] init];
//        NSLog(@"有%i个ClassA",[ClassA classACount]);
        
        // 类方法 与 实例方法的区别?
        // 类方法 用类名调用
        // [ClassA alloc] 中 alloc 就是类方法
        // 实例方法用实例对象进行调用
        // init 是实例方法

        // 例子2
        int c = 2;
        NSLog(@"%@",[CommFunc colorStr:c]);
        
        // 练习:
        //为CommFunc添加类方法,并在main中测试
        //1 实现传入的2个参数的加减乘除功能，将计算结果返给会调用者，并在main中测试
        NSLog(@"1+2 = %i",[CommFunc addA:1 andB:2]);
        
        //2 判断传入的year是否闰年的方法
        
        //3 传入年月返回当前月有几天
        

    }
    return 0;
}
