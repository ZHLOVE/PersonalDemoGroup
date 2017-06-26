//
//  main.m
//  blockDemo
//
//  Created by niit on 16/1/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 全局变量
int gNumber = 100;

// 无参数 无返回值的函数
void printSomething()
{
    NSLog(@"Hello World!");
}

typedef void (^MyBlockType2)(int);// 定义了一个类型的别名?  一个有一个参数无返回值的block类型 别名

// 函数，一个参数是int型，另外一个是block类型
void repeat(int n,MyBlockType2 aBlock)
{
    for(int i=0;i<n;i++)
    {
        aBlock(i);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        // 关于block
        // * block值 一段代码,代码块
        // * block变量 存放代码块的变量
        // * ^ block的语法标记
        // * block 和 函数很类似
        //   1) 一段代码，实现一段功能
        //   2) 有参数
        //   3) 返回值
        //   4) 调用方式一样
        
#pragma mark - 第一个block例子
        //
        int multiplier = 7;
        
        int (^foo)(int);
        // 定义了一个foo的block变量
        // 类型 int (^)(int) 的block
        
        // 给这个foo变量赋值,值是一段代码
        foo = ^(int num)
        {
            return num * multiplier;
        };
        
        // 执行block
        NSLog(@"%i",foo(3));
        
#pragma mark - 如何定义使用block
        
        // 格式:
        // 返回值 (^block变量名)(参数列表) = ^(参数列表){具体代码};
#pragma mark 1.最简单的block(无参数 无返回值的block)
        
        // 无参数 无返回值的block值
//        ^()
//        {
//            NSLog(@"Hello World!");
//        }
        
        // 一个block变量(无参数 无返回值的block变量)
//        void (^aBlock)(void);
//        
//        // 给这个block变量赋值
//        aBlock = ^()
//        {
//            NSLog(@"Hello World!");
//        };
        
        // 定义并赋值
//        void (^aBlock)(void) = ^()
//        {
//            NSLog(@"Hello World!");
//        };
//        
//        // 执行调用block
//        aBlock();
        
#pragma mark 2.带参数带返回值的block
        void (^bBlock)(int);// 带一个参数无返回值的block变量
        void (^cBlock)(int,int);// 带两个参数无返回值的block变量
        int (^dBlock)(int,int);// 带两个参数有返回值的block变量
        
        // block变量只能存放和它类型完全一致的block值
        
//        bBlock = ^(int num)
//        {
//            NSLog(@"传入的值是%i,平方=%i",num,num*num);
//        };
//        
//        cBlock = ^(int num1,int num2)
//        {
//            NSLog(@"%i + %i = %i",num1,num2,num1+num2);
//        };
//        
//        dBlock = ^(int num1,int num2)
//        {
//            return num1+num2;
//        };
//        
//        bBlock(10);
//        cBlock(20,30);
//        int result = dBlock(40,50);
//        NSLog(@"%i + %i = %i",40,50,result);
        
        // 练习一下:编写以下相应的block,并测试
        // 1 定义一个block变量并赋值,功能是打印100个*(提示无参数无返回值)
        // 2 定义一个block求1+2+3+...+n(要有返回值）
        // 3 定义一个block求传入数的平方值(要有返回值）
        // 4 定义一个block求三个书中最小值(要有返回值）
        
#pragma mark - block中使用全局变量和局部变量的问题
        
#pragma mark 1.全局变量(访问并修改)
        
        void (^eBlock)(void) = ^()
        {
            gNumber++;
            NSLog(@"gNumber = %i",gNumber);
        };
        eBlock();
        NSLog(@"gNumber = %i",gNumber);
        
#pragma mark 2 局部变量
//        int localNumber = 500;
        
//        void (^fBlock)(void) = ^()
//        {
//            localNumber++;// 报错
//            NSLog(@"localNumber = %i",localNumber);
//        };
//        fBlock();
        
        // 机上__block关键字,block中可以修改这个局部变量
        __block int localNumber = 500;
        void (^fBlock)(void) = ^()
        {
            localNumber++;
            NSLog(@"localNumber = %i",localNumber);
        };
        fBlock();
        NSLog(@"localNumber = %i",localNumber);
        
#pragma mark - 用typedef给block类型起别名

//        int (^gBlock)(int,int);
//        // gBlock 是 block变量
//        // int (^)(int,int) 是block类型
//        gBlock = ^(int n1,int n2)
//        {
//            return n1-n2;
//        };
        
        // 定义别名 // int (^)(int,int) => MyBlockType
        typedef int (^MyBlockType)(int,int);
        // 用别名定义hBlock变量
        MyBlockType hBlock;
        // 给变量赋值
        hBlock = ^(int n1,int n2)
        {
            return n1*n2;
        };
        
        // 练习:
        // 1 编写一个能打印n个星号的block变量，先用typedef定义别名
        // 2 定义一个将字符串中@"-"符号替换去掉的block(传入NSString,返回NSString),先用typedef定义别名
        // 3 定义一个统计名字数组中有多少个新张的人的数量(传入NSArray,返回int)的block，先用typedef定义别名
        // @[@"张三",@"乔布斯",@"比尔盖茨",@"张小明",@"张长长",@"章长"];
        
#pragma mark - block可以作为函数、方法参数及返回值
        
//        MyBlockType2 iBlock = ^(int n)
//        {
//            NSLog(@"%i",n*2);
//        };
//        repeat(10, iBlock);
        
        repeat(100, ^(int n)
        {
            NSLog(@"%i",n*n);
        });
        
#pragma mark - block应用之处
        
        // 可用于遍历字典和数组
        NSDictionary *aDict = @{@"10001":@"张三",
                                @"10002":@"李四",
                                @"10003":@"张五",
                                @"10004":@"赵五"};
        NSArray *aArr = @[@"张三",@"乔布斯",@"比尔盖茨",@"小明"];
        
//        for(NSString *name in aArr)
//        {
//            NSLog(@"%@",name);
//            if([name isEqualToString:@"乔布斯"])
//            {
//                break;
//            }
//        }
//
//        for(NSString *key in aDict.allKeys)
//        {
//            NSLog(@"%@ %@",key,aDict[key]);
//        }
        
        [aArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 遍历的代码
            NSLog(@"%@ 下标:%i",obj,idx);
            if([obj isEqualToString:@"乔布斯"])
            {
                *stop = YES;//停止遍历
            }
        }];

        [aDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
        {
            NSLog(@"%@ %@",key,obj);
            if([obj isEqualToString:@"张五"])
            {
                *stop = YES;//停止遍历
            }
        }];
        
        //学号    姓名   年龄  身高   体重  语文成绩 数学成绩 英语成绩
        //1001  王晓明   13   135    50      65      95      59
        //1002  张三     14   135    50      63      53      33
        //1003  李四     15   125    50      49      95      80
        //1004  王五     13   132    50      65      66      90
        //1005  库克     14   129    50      55      95      59
        //使用字典或数组或类存放以上数据
        
        //使用block遍历
        //输出所有要补考的人员名单
        //输出要补考2门及两门以上的人员名单
        
    }
    return 0;
}
