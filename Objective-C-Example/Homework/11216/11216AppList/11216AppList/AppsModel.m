//
//  AppsModel.m
//  11216AppList
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "AppsModel.h"

@implementation AppsModel

- (instancetype)initWithDict:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:d];
    }
    return self;
}

+ (instancetype)AppsModelWith:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
