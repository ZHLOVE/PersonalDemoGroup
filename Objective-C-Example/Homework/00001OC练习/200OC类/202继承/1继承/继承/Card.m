//
//  Card.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Card.h"

@implementation Card

// 存钱
- (void)addMoney:(float)m
{
    self.money+=m;
    NSLog(@"存款成功!");
    [self printMoney];
}

// 取钱
- (BOOL)pickupMoney:(float)m
{
    if(self.money>=m)
    {
        self.money-=m;
        NSLog(@"取钱成功!");
        [self printMoney];
        return YES;
    }
    else
    {
        NSLog(@"取钱失败!");
        [self printMoney];        
        return NO;
    }
}

- (void)printMoney
{
    NSLog(@"当前余额:%g",self.money);
}
@end
