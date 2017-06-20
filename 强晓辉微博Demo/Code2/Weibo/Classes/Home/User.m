//
//  User.m
//  Weibo
//
//  Created by qiang on 5/4/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)userWithDict:(NSDictionary *)dict
{
    return [[[self class] alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"发帖人:%@ 头像地址:%@",self.name,self.profile_image_url];
}

@end
