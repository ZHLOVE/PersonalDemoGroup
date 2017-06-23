//
//  Student.m
//  单例模式
//
//  Created by niit on 16/3/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Student.h"

// 方式1:GCD
static Student *instance = nil;

@implementation Student

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (Student *)shareStudent
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Student alloc] init];
    });
    return instance;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return instance;
}

@end
