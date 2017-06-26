//
//  CommFunc.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "CommFunc.h"

@implementation CommFunc

+ (NSString *)colorStr:(Color)color
{
    switch (color) {
        case kColorBlack:
            return @"黑色";
            break;
        case kColorBrown:
            return @"棕色";
            break;
        case kColorBlue:
            return @"蓝色";
            break;
        case kColorGold:
            return @"金色";
            break;
        case kColorWhite:
            return @"白色";
            break;
        default:
            break;
    }
    return nil;
}

@end
