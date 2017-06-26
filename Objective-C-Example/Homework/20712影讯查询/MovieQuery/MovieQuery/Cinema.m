//
//  Cinema.m
//  MovieQuery
//
//  Created by student on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "Cinema.h"

@implementation Cinema

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

//因为返回的JSON中是id,所以重写set方法改成uid
- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"])
        self.uid = value;
}


+ (instancetype)dataWithDict:(NSDictionary *)d
{
    return [[self alloc]initWithDict:d];
}

@end
