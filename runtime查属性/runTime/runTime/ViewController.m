//
//  ViewController.m
//  runTime
//
//  Created by MBP on 2017/3/7.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self printIvar:[UIButton class]];
}



- (void)printIvar:(Class)class {
    // count记录变量的数量IVar是runtime声明的一个宏
    unsigned int count = 0;
    // 获取类的所有属性变量
    Ivar *menbers = class_copyIvarList(class, &count);
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

@end
