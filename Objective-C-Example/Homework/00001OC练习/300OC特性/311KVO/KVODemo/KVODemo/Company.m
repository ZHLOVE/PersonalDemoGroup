//
//  Company.m
//  KVODemo
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Company.h"

@implementation Company

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 30天
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendMoney) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)sendMoney
{
    NSLog(@"公司:发钱了!+5000");
    self.xiaominCard.money += 5000;
}



@end
