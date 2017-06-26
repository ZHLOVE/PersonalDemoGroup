//
//  Graphics.m
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Graphics.h"

@implementation Graphics

- (void)printInfo//打印输出 面积周长信
{
    NSLog(@"面积:%g 周长:%g",[self area],[self perimeter]);
}
@end
