//
//  DataModel.m
//  LGJ
//
//  Created by student on 16/5/12.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (instancetype)initWithDict:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:d];
    }
    return self;
}

+ (instancetype)dataWithDict:(NSDictionary *)d
{
    return [[self alloc]initWithDict:d];
}

@end
