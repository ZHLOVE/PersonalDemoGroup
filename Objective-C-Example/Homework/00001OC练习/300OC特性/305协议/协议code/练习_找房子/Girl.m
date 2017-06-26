//
//  Girl.m
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Girl.h"

@implementation Girl

// 烧饭
- (void)cook
{
    NSLog(@"女朋友:煮个泡面");
}

// 洗衣服
- (void)wash
{
    NSLog(@"女朋友:洗衣服");
}

// 找房子
- (int)findHouse
{
    //    500~4000
    //(5-40) * 100
    //((0-35)+5)*100;
    int result = (arc4random()%36+5) * 100;
    NSLog(@"女朋友小张:找到一间%i的房子",result);
    return result;
    
}
@end
