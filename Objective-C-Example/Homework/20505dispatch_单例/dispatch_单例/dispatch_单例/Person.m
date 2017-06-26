//
//  Person.m
//  dispatch_单例
//
//  Created by student on 16/3/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "Person.h"

static Person *instance = nil;

@implementation Person

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (Person *)shareStudent{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Person alloc]init];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone{
    return instance;
}

@end

