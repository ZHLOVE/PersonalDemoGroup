//
//  Video.m
//  Net2
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Video.h"

@implementation Video

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+ (instancetype)videoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        [self setValue:value forKey:@"sid"];
    }
}

@end
