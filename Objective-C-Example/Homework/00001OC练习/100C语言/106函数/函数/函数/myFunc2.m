//
//  myFunc2.m
//  函数
//
//  Created by niit on 15/12/21.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "myFunc2.h"

// 其他模块定义了一个allValue，本模块也要用。
extern int allValue;

// 计算数组总和
// 数组作为参数
// a[] 数组名
// count 数组长度
int sum(int a[],int count)
{

    
    int result = 0;
    for (int i=0; i<count; i++)
    {
        result+= a[i];
    }
    return result;
}

void printSomthing()
{
    printf("allValue = %i",allValue);
    allValue = 200;
}