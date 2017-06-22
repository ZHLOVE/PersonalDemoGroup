//
//  UIColor+HexColor.h
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor *)colorWithHex:(long)hexColor;
// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
