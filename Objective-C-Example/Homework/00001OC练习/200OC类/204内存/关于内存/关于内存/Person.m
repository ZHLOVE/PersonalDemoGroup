//
//  Person.m
//  关于内存
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)n
{
    self = [super init];
    if (self) {
        self.name = n;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"我被销毁了");
}

@end
