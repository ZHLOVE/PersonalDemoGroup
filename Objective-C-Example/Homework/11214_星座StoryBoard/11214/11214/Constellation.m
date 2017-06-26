//
//  Constellation.m
//  11214
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "Constellation.h"

@implementation Constellation

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)ConstellationWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
