//
//  main.m
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Animal.h"
#import "Cat.h"
#import "Dog.h"
#import "Pig.h"

#import "Rectangle.h"
#import "Circle.h"

#import "TestClass.h"

// NSObject类的几个方法
// 1
//- (BOOL)isKindOfClass:(Class)aClass;// 判断对象是不是aClass类或aClass类的子类的对象
//- (BOOL)isMemberOfClass:(Class)aClass;// 判断对象是不是aClass类对象
// 2
//- (BOOL)respondsToSelector:(SEL)aSelector;//判断对象是否能够执行某方法
// 3
//- (id)performSelector:(SEL)aSelector;// 让对象执行某个方法
//- (id)performSelector:(SEL)aSelector withObject:(id)object;// 让对象执行某个方法,带上参数object
//- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;// 让对象执行某个方法,带上参数object1,object2

// Objective-C语言的特殊类型
// 1 id类型
// 可以用来指向任何类型的对象
//id a = [[Cat alloc] init];
//a = [[Dog alloc] init];

// 2 SEL类型
// 相当于函数指针
//SEL sel = @selector(sing);
//SEL sel = @selector(sing:);
//SEL sel = @selector(initWithWidth:andHeight:);

// 3 Class类型
//Class c = [Cat class];

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        
#pragma mark - 多态例子
        
        //Animal *animals[3];
        id animals[3];// id 泛类型 可指向任何对象 不需要*
        
        animals[0] = [[Cat alloc] init];
        animals[1] = [[Dog alloc] init];
        animals[2] = [[Pig alloc] init];
        
        for (int i=0; i<3; i++)
        {
            // 唱歌
            [animals[i] sing];
            
            // 1 如果是猫,去爬树
            // 方法:
//            if([animals[i] isKindOfClass:[Cat class]])// 判断对象是不是猫类
//            {
//                // 1 泛类型不会报错. Animals指针会报错
//                //                [animals[i] climbTree];
//                
//                // 2 把方法名放到SEL变量里
//                SEL sel = @selector(climbTree);
//                [animals[i] performSelector:sel];
//                [animals[i] performSelector:@selector(climbTree)];// 让对象执行爬树
//            }
            
            // 2 判断对象能否爬树啊
            SEL sel = @selector(climbTree);
            if( [animals[i] respondsToSelector:sel])// 判断对象是否能够执行爬树
            {
                [animals[i] performSelector:sel];
            }
        }
        
#pragma mark - 使用performSelector让对象执行方法
//- (id)performSelector:(SEL)aSelector;// 让对象执行某个方法
//- (id)performSelector:(SEL)aSelector withObject:(id)object;// 让对象执行某个方法,带上参数object
//- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;// 让对象执行某个方法,带上参数object1,object2
        
        TestClass *test = [[TestClass alloc] init];
        // 1
        //            [test printInfo];
        // 2
        [test performSelector:@selector(printInfo)];
        
        // 有1个参数
        [test performSelector:@selector(printInfo2:) withObject:@(10)];
        
        // 有2个参数
        [test performSelector:@selector(printInfo3:andB:) withObject:@(10) withObject:@(20)];
        
        // 返回值
        NSNumber *n = [test performSelector:@selector(printInfo4:andB:) withObject:@(10) withObject:@(20)];
        NSLog(@"结果:%@",n);
        
#pragma mark - 练习
        //1 定义一个图形类
        //- (float)area;//面积
        //- (float)perimetter;//周长
        //- (void)printInfo;打印输出 面积周长信息
        //派生一个长方形类
        //派生一个圆形类            //创建一个图形类对象的数组
        //打印输出所有对象的信息
        
        Graphics *g[2];
        g[0] = [[Circle alloc] initWithR:50];
        g[1] = [[Rectangle alloc] initWithWidth:50 andHeight:100];
        
        for (int i=0; i<2; i++)
        {
            [g[i] printInfo];
        }
        
        //2 利用之前创建的游戏角色类、英雄类、怪物类并修改创建一个新的游戏
        //游戏内有10个怪物,1个玩家,1个公主
        //游戏规则:
        //怪物、公主随机走动
        //玩家要避开怪物,与公主重合。
        
        
    }
    return 0;
}
