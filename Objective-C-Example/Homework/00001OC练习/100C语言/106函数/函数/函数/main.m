//
//  main.m
//  函数
//
//  Created by niit on 15/12/21.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>


// 类似出c语言里的#include
#import "myFunc.h"
#import "myFunc2.h"

// 函数的功能:
// 1 模块化
// 2 编写一次 多次调用
// 3 函数间相互独立

//返回值类型 函数名(参数类型 参数名1，参数类型 参数名2 ,...)
//{
//    具体语句
//    ...
//    return 计算的结果
//}

// 1 无参数无返回值的函数

// void 无返回值
// printStar 函数名
// () 无参数
void printStar()
{
    for(int i=0;i<=50;i++)
    {
        printf("*");
    }
    printf("\n");
}

// 2 有参数有返回值
// int 返回真整型数据
// min 函数名
// (int x,int y) 传入2个参数
int min(int x,int y)// 形式参数
{
    printf("min中x,y地址:%p,%p\n",&x,&y);
    int result = x>y?y:x;
    return result;
}

int max(int x,int y)
{
    printf("max中x,y地址%p,%p\n",&x,&y);
    int result = x>y?x:y;
    return result;
}


// 求平均值
float average(int a[],int count)
{
    float result;
    // ...
    return result;
}

// 一个标准的函数的注释
/*
 函数名:printNStar
 作者:
 日期:
 功能:
 输入参数:int n; // 多少个*号
 
 返回值: 返回值
 
 修改记录:
 */
void printNStar(int n)
{
    for (int i=0; i<n; i++)
    {
        printf("*");
    }
    printf("\n");
}

// foo

// f(n) = f(n-1)*n
// ...
// f(5) = f(4)*5
// f(4) = f(3)*4
// f(3) = f(2)*3
// f(2) = f(1)*2
// f(1) = 1


int allValue = 100;


int main(int argc, const char * argv[]) {
    @autoreleasepool {

#pragma mark - 1 调用无参数无返回值的函数
//        printStar(); // 调用打星函数
//        for(int i=1;i<=9;i++)
//        {
//            for(int j=1;j<=9;j++)
//            {
//                printf("%5i",i*j);
//            }
//            printf("\n");
//        }
//        printStar();// 调用打星函数
        
#pragma mark - 2 调用有参数有返回值的函数
        int x=10,y=100;
        printf("main中x,y地址:%p,%p\n",&x,&y);
        int result = min(x,y);// 实际参数
        printf("%i,%i中较小的数:%i\n",x,y,result);
        
        result = max(x,y);
        printf("%i,%i中较大的数:%i\n",x,y,result);
        
        // 练习:
        // 编写以下函数
        //1 void printNStar(int n);// 传入n，打印n个星号
        //2 int max(int x,int y);//计算较大值
        //3 实现打印1,2,3,...,n功能
        //4 实现计算1+2+...+n功能
        //5 float cube(float a);//求立方值
        //6 float roundArea(float r);//求圆面积 3.1415926*r*r
        //7 float roundPerimeter(float r);//求圆的周长 2*3.1415926*r
        // 编写一个函数,输入n,n为偶数时,求1/2+1/4+1/6+...+1/n,n为奇数时,求1/1+1/3+1/5+...+1/n
        
#pragma mark - 3 数组作为函数
        int a[5]={100,23,34,345,634};
        int all = sum(a,5);
        printf("all = %i",all);
        
        // 练习:
        // float average(int a[],int count);//求数组的平均值
        //用以下语句测试
        int b[10] ={95,68,79,100,69,55,96,93,78,65};
        float aver = average(b,10);
        printf("平均值=%f\n",aver);
        
#pragma mark - 4 递归
        // 程序调用自身的编程技巧称为递归(recursion)
        // 通常把一个大型复杂的问题层层转化为一个与原问题相似的规模较小的问题来求解.
//        注意：
//        递归就是在过程或函数里调用自身；
//        在使用递归策略时，必须有一个明确的递归结束条件，
        
        // 例子:
        // 使用递归方式求n! (n!= 1*2*3*n!)
        // n! = (n-1)! *n
        // ...
        // 3! = 2!*3
        // 2! = 1!*2
        // 1! = 1
        
        int n=4;
//        printf("\n请输入n:");
//        scanf("%d",&n);
        printf("%d! = 1*2*...*%d = %d",n,n,foo(n));
        
        // 练习:以下用递归实现
        // * 计算1+2+...+n
        // * 使用递归实现打印n个菲波那切数(0 1 1 2 3 5 8 13 21 34 54 ...)
        //   f(n) = f(n-1) + f(n-2)
        
#pragma mark - 5 系统数学函数
        // 查询笔记,找到、调用合适的系统数学函数计算得到结果
        // 1) 求2的5次方
        printf("%f\n",pow(2, 5));
        // 2) 求2的平方根
        // 3) 求不大于3.1415926最大的整数
        // 4) 求-3.5的绝对值
        // 5) 找到数学中计算对数的函数(log)
        // 6) 找到数学中三角函数正弦的函数
        
        
        // 测试全局变量
        printSomthing();
        printf("allValue = %i",allValue);
        
    }
    return 0;
}



