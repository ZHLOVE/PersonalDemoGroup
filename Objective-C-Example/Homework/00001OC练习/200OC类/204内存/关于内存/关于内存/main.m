//
//  main.m
//  关于内存
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"
#import "Children.h"
#import "Father.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
#pragma mark - 非ARC机制
        // 在Build settings里 搜索automatic
        // 找到Objective-C Automatic Reference Counting 设置为 NO
        
//        // 非ARC下,对象用完了，你要去释放
//        Person *p = [[Person alloc] init];
//        NSLog(@"计数 = %lu",(unsigned long)[p retainCount]);
//        Person *p2 = [p retain];
//        NSLog(@"计数 = %lu",(unsigned long)[p retainCount]);
//        Person *p3 = [p retain];
//        NSLog(@"计数 = %lu",(unsigned long)[p retainCount]);
//        
//        // 释放 release 就是让计数-1.一但对象计数=0，则自动释放。
//        [p release];
//        NSLog(@"计数 = %lu",(unsigned long)[p retainCount]);
//        [p2 release];
//        NSLog(@"计数 = %lu",(unsigned long)[p retainCount]);
//        [p3 release];
//        NSLog(@"计数 = %lu",(unsigned long)[p retainCount]);
//        
//        // 自动释放
//        Person *p4 = [[[Person alloc] init] autorelease];
        
#pragma mark - ARC机制
        // 只要有强引用的指针指向它，他就不会被释放。如果没有强引用指针指向，则会自动释放。
        // strong 强引用
        // weak 弱引用
        // 局部的指针变量在作用域内也是强引用

        // 例子1
//        Person *p1 = [[Person alloc] init];
//        __weak Person *p2 = p1;//声明p2是弱引用 它是维持不住内存中的对象
//        p1 = nil;
        
        // 例子2
//        Person *p1 = [[Person alloc] initWithName:@"小明"];
//        p1.myDog = [[Dog alloc] initWithName:@"阿黄"];
//        
//        Person *p2 = [[Person alloc] initWithName:@"张三"];
//        p2.neighbourDog = p1.myDog;
//
//        NSLog(@"邻居家的狗:%@ %@",p2.neighbourDog,p2.neighbourDog.name);
//        p1.myDog = nil;
//        NSLog(@"邻居家的狗:%@",p2.neighbourDog);
        
//        p2.myDog = [[Dog alloc] initWithName:@"小白"];
//        p1.neighbourDog = p2.myDog;
//        p2.neighbourDog = p1.myDog;
        
        // 例子3
        Father *f = [[Father alloc] init];
        f.name = @"李四";
        
        Children *c = [[Children alloc] init];
        c.name = @"李五";
        
        c.myFather = f;
        [c printMyFamilyInfo];
        
        f = nil;// 父亲不在了
        [c printMyFamilyInfo];        
        
        
        
        [[NSRunLoop currentRunLoop] run];

    }
    return 0;
}
