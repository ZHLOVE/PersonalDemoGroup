
//
//  NewsModel.m
//  11215
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (instancetype)initWithDict:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:d];
    }
    return self;
}

+ (instancetype)NewsModelWith:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
