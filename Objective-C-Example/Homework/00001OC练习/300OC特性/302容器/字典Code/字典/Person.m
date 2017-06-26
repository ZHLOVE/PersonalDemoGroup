//
//  Person.m
//  字典
//
//  Created by niit on 16/1/5.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithTel:(NSNumber *)t andName:(NSString *)n andAddress:(NSString *)a
{
    self = [super init];
    if (self) {
        self.tel = t;
        self.name = n;
        self.address = a;
    }
    return self;
}

@end
