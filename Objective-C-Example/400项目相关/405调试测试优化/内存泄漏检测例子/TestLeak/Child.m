//
//  Child.m
//  TestLeak
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "Child.h"

@implementation Child

- (instancetype)init
{
    NSLog(@"Child %s",__func__);
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"Child %s",__func__);
}
@end
