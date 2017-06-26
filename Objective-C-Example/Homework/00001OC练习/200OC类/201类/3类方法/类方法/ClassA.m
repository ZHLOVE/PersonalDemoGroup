//
//  ClassA.m
//  类方法
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "ClassA.h"

int classACount=0;

@implementation ClassA

// 重写父类的初始化方法
- (id)init
{
    self = [super init];
    if(self)
    {
        classACount++;
    }
    return self;
}

// 对象销毁的时候,会自动执行dealloc方法
- (void)dealloc
{
    classACount--;
}

+ (int)classACount
{
    return classACount;
}

@end
