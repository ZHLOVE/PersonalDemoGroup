//
//  Father.m
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Father.h"

#import "Child.h"

@implementation Father

- (void)feedChild:(Child *)c
{
    NSLog(@"把牛奶温一下，喂一下小孩");
    c.hungry = 100;
}

- (void)playWithChild:(Child *)c
{
    NSLog(@"父亲:抱抱小孩，逗逗小孩玩");
    c.happyniess += 10;
}

@end
