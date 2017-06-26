//
//  Agent.m
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Agent.h"

@implementation Agent

// 找房子
- (int)findHouse
{
    // 返回一个范围的数值
    //800~3000
    //8~30 * 100
    //(0~22)+8 *100
    
    int result = (arc4random()%23+8) * 100;
    NSLog(@"中介:找到一间%i的房子",result);
    return result;
}
@end
