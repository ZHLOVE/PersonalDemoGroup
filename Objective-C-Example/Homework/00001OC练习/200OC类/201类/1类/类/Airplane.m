//
//  Car.m
//  类
//
//  Created by niit on 15/12/23.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Airplane.h"

// 类的实现部分
@implementation Airplane

// setter getter 方法 实现
- (void)setColor:(NSString *)c// 设置值
{
    color = c;
}

- (NSString *)color
{
    return color;
}

- (void)setPrice:(int)p
{
    price = p;
}
- (int)price
{
    return price;
}

- (void)setBrand:(NSString *)b
{
    brand = b;
}
- (NSString *)brand
{
    return brand;
}

- (void)drive
{
    NSLog(@"汽车开动了");
}

- (void)addOil
{
    NSLog(@"汽车加油了");
}

- (void)printCarInfo
{
    NSLog(@"我的车是%@的%@,价格:%i万",color,brand,price);
}

@end
