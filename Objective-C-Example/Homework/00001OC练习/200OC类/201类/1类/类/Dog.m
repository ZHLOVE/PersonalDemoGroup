//
//  Dog.m
//  类
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Dog.h"

@implementation Dog


//2 方法
- (void)eat
{
    self.weight += 0.5;
    NSLog(@"%@ 当前体重是:%g",self.name,self.weight);
}
- (void)sing
{
    NSLog(@"%@:汪~汪",self.name);
}

- (void)printInfo
{
    char colorStr[5][10] = {"黑色","白色","黄色","黑白","棕色"};
    printf("%s",colorStr[self.color]);
}
//// setter getter方法
//- (void)setColor:(NSString *)c
//{
//    color = c;
//}
//- (NSString *)color
//{
//    return color;
//}
//
//- (void)setName:(NSString *)n
//{
//    name = n;
//}
//- (NSString *)name
//{
//    return name;
//}
//
//- (void)setWeight:(float)w
//{
//    weight = w;
//}
//- (NSString *)wieght
//{
//    return weight;
//}

@end
