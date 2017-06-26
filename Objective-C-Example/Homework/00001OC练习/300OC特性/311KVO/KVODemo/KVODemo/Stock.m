//
//  Stock.m
//  KVODemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Stock.h"

@implementation Stock

- (instancetype)initWithName:(NSString *)n andPrice:(float)p
{
    self = [super init];
    if (self) {
        self.name = n;
        self.price = p;
        
        // 创建定时器 定时器加入到事件循环
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changePrice) userInfo:nil repeats:YES];
    }
    return self;
}


- (void)changePrice
{
    // 涨跌多少钱
    float change = (arc4random()%11)/10.0 - 0.5;// -0.5~0.5
    
    // 以下几行代码，打印顺序会有问题
    NSLog(@"Step 1:改变self.price");
    self.price += change;// 改变self.price,立即触发监看这个对象这个属性的监看人执行相应监看方法
    NSLog(@"Step 3");    
    NSLog(@"%@ 当前价格:%g",self.name,self.price);
    
    // 用局部变量先保存新价格，用于打印一下，解决这这个问题
//    float tmpPrice = self.price + change;
//    NSLog(@"%@ 当前价格:%g",self.name,tmpPrice);
//    
//    self.price = tmpPrice;// 改变self.price //触发相应监看方法
}

@end
