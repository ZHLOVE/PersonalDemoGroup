//
//  Movie.m
//  MovieQuery
//
//  Created by 马千里 on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "Movie.h"

@implementation Movie

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
