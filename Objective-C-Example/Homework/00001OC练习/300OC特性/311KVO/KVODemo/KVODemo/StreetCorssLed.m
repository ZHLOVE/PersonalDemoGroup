//
//  StreetCorssLed.m
//  KVODemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "StreetCorssLed.h"

// 枚举转字符串
NSString *colorToString(LedColor color)
{
    NSArray *colorStrArr = @[@"红灯",@"黄灯",@"绿灯"];
    return colorStrArr[color];
}

@implementation StreetCorssLed
{
    int count;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 每秒更新Led状态
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)update
{
    //红灯 5s
    //黄灯 1s
    //绿灯 3s
    //黄灯 1s
    LedColor tmpColor;
    switch (++count) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            tmpColor = kLedColorRed;
            break;
        case 6:
            tmpColor = kLedColorYellow;
            break;
        case 7:
        case 8:
        case 9:
            tmpColor = kLedColorGreen;
            break;
        case 10:
            tmpColor = kLedColorYellow;
            count = 0;
            break;
        default:
            break;
    }
    
    if(self.ledColor != tmpColor)
    {
        NSLog(@"切换至%@",colorToString(tmpColor));
        self.ledColor = tmpColor;
    }
}

@end
