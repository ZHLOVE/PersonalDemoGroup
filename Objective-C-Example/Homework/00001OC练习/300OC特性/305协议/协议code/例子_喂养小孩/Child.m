//
//  Child.m
//  NSRunLoop和NSTimer
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Child.h"

#import "Father.h"
#import "Mother.h"

@implementation Child

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(cry:)
                                       userInfo:nil
                                        repeats:YES];
        self.hungry = 100;
    }
    return self;
}

// 定时器触发了这个方法，这个形参指向触发此方法的定时器对象
- (void)cry:(NSTimer *)t
{
    self.hungry -= 10;
    NSLog(@"饥饿度:%i",self.hungry);
    
    if(self.hungry<= 0)
    {
        NSLog(@"饿死了");
        [t invalidate];// 关闭定时器(将计时器从NSRunLoop中移除)
    }
    else if(self.hungry<= 60)
    {
        NSLog(@"哇~~~~~~~~,我饿");
        // 让代理人喂养我
        [self.delegate feedChild:self];
        
        // 对于协议里的可选方法，需要先判断一下代理人有没有实现
        if([self.delegate respondsToSelector:@selector(playWithChild:)])
        {
            [self.delegate playWithChild:self];
        }
    }
}

@end
