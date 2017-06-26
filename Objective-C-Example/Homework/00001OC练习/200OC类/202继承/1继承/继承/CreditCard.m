//
//  CreditCard.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "CreditCard.h"

#import "def.h"

@implementation CreditCard

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.creditMoney = kCreditMoneyDefault;
    }
    return self;
}

- (instancetype)initWithCredit:(float)credit
{
    self = [super init];
    if (self) {
        self.creditMoney = credit;
    }
    return self;
}


- (BOOL)pickupMoney:(float)m
{
    if(self.money + self.creditMoney >= m)
    {
        self.money -= m;
        NSLog(@"刷卡成功!");
        [self printMoney];
        return YES;
    }
    else
    {
        NSLog(@"刷卡失败!");
        [self printMoney];        
        return NO;
    }
}
@end
