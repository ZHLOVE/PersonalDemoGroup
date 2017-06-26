//
//  Video.m
//  Net2_Delegate
//
//  Created by student on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
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
