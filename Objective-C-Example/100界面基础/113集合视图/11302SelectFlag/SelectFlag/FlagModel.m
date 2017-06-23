//
//  Flag.m
//  SelectFlag
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "FlagModel.h"

@implementation FlagModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)flagWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
