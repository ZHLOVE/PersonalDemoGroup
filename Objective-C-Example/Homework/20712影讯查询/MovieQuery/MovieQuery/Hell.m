//
//  Hell.m
//  MovieQuery
//
//  Created by student on 16/4/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "Hell.h"

@implementation Hell

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+ (instancetype)dataWithDict:(NSDictionary *)d
{
    return [[self alloc]initWithDict:d];
}

@end
