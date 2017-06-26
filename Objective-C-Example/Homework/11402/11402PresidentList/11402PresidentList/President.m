//
//  President.m
//  11402PresidentList
//
//  Created by student on 16/3/10.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "President.h"

@implementation President

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)PresidentWithDict:(NSDictionary *)dict{

    return [[self alloc]initWithDict:dict];
}

@end
