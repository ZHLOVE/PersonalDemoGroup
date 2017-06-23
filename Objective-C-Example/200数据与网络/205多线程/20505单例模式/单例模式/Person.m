//
//  Person.m
//  单例模式
//
//  Created by niit on 16/3/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Person.h"

// 方式2:@synchronized

@implementation Person

static Person *instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
        }
    }
    return instance;
}

+ (Person *)shareStudent
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [[Person alloc] init];
        }
    }
    return instance;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return instance;
}
@end
