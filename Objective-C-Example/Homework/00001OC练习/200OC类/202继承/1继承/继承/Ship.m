//
//  Ship.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Ship.h"

@implementation Ship

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"船";
        self.speed = 0;
    }
    return self;
}

// 方法
- (void)printInfo
{
    NSLog(@"%@ 航速:%i",self.name,self.speed);
}

@end
