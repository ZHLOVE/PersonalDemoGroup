//
//  main.m
//  变量类型补充
//
//  Created by niit on 15/12/23.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Func.h"

// 全局变量
int gNumber = 100;
//static int gNumber = 100;// 本模块的全局变量 其他模块不能使用

// 定义了一个枚举类型
enum Direction
{
    DirectionUp,//=> 0
    DirectionDown,//=> 1
    DirectionLeft,//=> 2
    DirectionRight,//=> 3
    DirectionMax // 4
};
typedef enum Direction Direction;

// 怪物类型
enum MonsterType
{
    Pig,         // 野猪怪     0
    SmallBoss = 10,   // 精英野猪怪  10
    Boss         // BOSS      11
};
typedef enum MonsterType MonsterType;

//
enum ChessType
{
    ChessTypeNone,    // 0
    ChessTypeBlack,   // 1
    ChessTypeWhite    // 2
};

// 练习
// 1 定义一个Month枚举类型,起别名,用这个类型定义一个变量并测试
//enum Month
// 2定义一个Week枚举类型,并起别名,用这个类型定义一个变量并测试

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        
        // 1 全局变量与局部变量
        printf("gNumber %i\n",gNumber);
        printSomething();
        printf("gNumber %i\n",gNumber);
        
        // 2 auto与static
        // 自动局部变量
        // 普通函数内声明的变量都是自动局部量,存储在内存中的栈区
        auto int a;//auto可以省略
        // 静态变量 存储在静态存储区
        static int b;//
        
        printABC();
        printABC();
        printABC();
        
        // 3 枚举类型
        Direction d;
        d = DirectionUp;// 赋值
//        d = 1;
        
        NSLog(@"d=%i",d);
        switch (d) {
            case DirectionUp:
                NSLog(@"向上走");
                break;
            case DirectionDown:
                NSLog(@"向下走");
                break;
            case DirectionLeft:
                NSLog(@"向左走");
                break;
            case DirectionRight:
                NSLog(@"向右走");
                break;
                
            default:
                break;
        }
        

        
        
        
    }
    return 0;
}
