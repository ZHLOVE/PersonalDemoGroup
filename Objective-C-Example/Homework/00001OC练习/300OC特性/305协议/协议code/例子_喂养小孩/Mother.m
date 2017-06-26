//
//  Mother.m
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Mother.h"

#import "Child.h"

@implementation Mother

- (void)feedChild:(Child *)c
{
    NSLog(@"母亲:母乳喂养小孩");
    c.hungry += 200;
    
}
@end
