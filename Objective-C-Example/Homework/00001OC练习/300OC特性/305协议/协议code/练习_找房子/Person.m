//
//  Person.m
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Person.h"

@implementation Person
{
    NSTimer *t;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        t  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dailyNeedToDo) userInfo:@"某参数" repeats:YES];

    }
    return self;
}


- (void)dailyNeedToDo
{
    static int week = 1;
    NSLog(@"星期%i",week++);
    if(week>7)
    {
        week = 1;
    }

    [self askGirlDoSomething];
    [self call];
}

- (void)askGirlDoSomething
{
    [self.girlFriend cook];
    
    if([self.girlFriend respondsToSelector:@selector(wash)])
    {
        [self.girlFriend wash];
    }
}

// 打电话找房子
- (void)call
{
    // 小明打电话，询问代理人房价,如果=1000则，认为找到了。关闭定时器。
    int price = [self.delegate findHouse];
    if( price == 1000)
    {
        NSLog(@"小明:价格合适,这房子我要了!");
        [t invalidate];
    }
    else
    {
        NSLog(@"小明:价格不合适，再帮我继续找.");
    }
}

@end
