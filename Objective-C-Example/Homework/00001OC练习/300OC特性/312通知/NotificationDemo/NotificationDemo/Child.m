//
//  Child.m
//  NotificationDemo
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Child.h"

#import "def.h"

@implementation Child

- (instancetype)init
{
    self = [super init];
    if (self) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)update
{
    self.hungry -= 10;
    NSLog(@"小孩饥饿值:%i",self.hungry);
    if(self.hungry<60)
    {
        NSLog(@"小孩:我饿了");
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCry object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCry object:self];
    }
}
@end
