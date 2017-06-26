//
//  Friend.m
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Friend.h"

@implementation Friend


// 找房子
- (int)findHouse
{
//    500~4000
    //(5-40) * 100
    //((0-35)+5)*100;
    int result = (arc4random()%36+5) * 100;
    NSLog(@"小张:找到一间%i的房子",result);
    return result;

}
@end
