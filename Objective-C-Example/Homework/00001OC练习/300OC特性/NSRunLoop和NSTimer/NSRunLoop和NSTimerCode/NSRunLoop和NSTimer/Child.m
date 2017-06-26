//
//  Child.m
//  NSRunLoop和NSTimer
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Child.h"

@implementation Child

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [NSTimer scheduledTimerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(cry:)
                                       userInfo:nil
                                        repeats:YES];
    }
    return self;
}

// 定时器触发了这个方法，这个形参指向触发此方法的定时器对象
- (void)cry:(NSTimer *)t
{
    static int i=0;
    if(i++>=10)
    {
        NSLog(@"饿死了");
        [t invalidate];// 关闭定时器(将计时器从NSRunLoop中移除)
    }
    else
    {
        NSLog(@"哇~~~~~~~~,我饿");
    }
}

@end
