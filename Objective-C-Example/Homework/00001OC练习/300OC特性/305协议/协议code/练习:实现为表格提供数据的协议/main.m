//
//  main.m
//  练习:实现为表格提供数据的协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Table.h"
#import "Controller.h"

// MVC 设计模式
int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        Table *table = [[Table alloc] init];
        // 定义一个叫Controller的类，实现为表格提供数据的协议，为表格提供数据，不要修改Table类
        Controller *controller = [[Controller alloc] init];
        table.delegate = controller;
        [table print];

    }
    return 0;
}
