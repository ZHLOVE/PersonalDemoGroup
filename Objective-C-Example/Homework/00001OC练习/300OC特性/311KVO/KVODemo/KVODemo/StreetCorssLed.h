//
//  StreetCorssLed.h
//  KVODemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义灯的颜色的枚举类型
enum LedColor
{
    kLedColorRed,
    kLedColorYellow,
    kLedColorGreen,
    KLedColorMax
};
// 起别名 enum LedColor -> LedColor;
typedef enum LedColor LedColor;

// 枚举类型转字符串
NSString *colorToString(LedColor color);


@interface StreetCorssLed : NSObject

// 灯的颜色
@property (nonatomic,assign) LedColor ledColor;

@end
