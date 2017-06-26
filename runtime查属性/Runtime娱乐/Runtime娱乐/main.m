//
//  main.m
//  Runtime娱乐
//
//  Created by MBP on 2017/1/24.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        NSString *myName = @"张三";

        // count记录变量的数量IVar是runtime声明的一个宏
        unsigned int count = 0;
        // 获取类的所有属性变量
        Ivar *menbers = class_copyIvarList([myName class], &count);
        NSLog(@"count : %i",count);
        for (int i = 0; i < count; i++) {
            Ivar var = menbers[i];
            // 将IVar变量转化为字符串,这里获得了属性名和类型
            const char *memberName = ivar_getName(var);
            const char *memberType = ivar_getTypeEncoding(var);
            NSLog(@"%s----%s", memberName, memberType);
            //并不能打印父类属性
        }

    }
    return 0;
}



