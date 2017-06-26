//
//  CommFunc.m
//  类方法
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "CommFunc.h"

@implementation CommFunc

// 颜色转换
+ (NSString *)colorStr:(int)color
{
    switch (color) {
        case 0:
            return @"黑色";
            break;
        case 1:
            return @"白色";
            break;
        case 2:
            return @"红色";
            break;
            
        default:
            break;
    }
    return nil;
}

+ (int)addA:(int)a andB:(int)b
{
    return a+b;
}

@end
