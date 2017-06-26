//
//  Monster.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Monster.h"

@implementation Monster


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.name = @"怪物";
    }
    return self;
}

- (void)walkOneStep
{
    [self move:arc4random()%kDirectionMax];
}

@end
