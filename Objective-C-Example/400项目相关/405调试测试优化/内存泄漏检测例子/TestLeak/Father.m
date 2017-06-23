//
//  Father.m
//  TestLeak
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "Father.h"

@implementation Father

- (instancetype)init
{
    NSLog(@"Father %s",__func__);
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"Father %s",__func__);
}

@end
