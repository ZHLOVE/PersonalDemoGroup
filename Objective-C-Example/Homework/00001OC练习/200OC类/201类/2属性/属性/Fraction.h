//
//  Fraction.h
//  类
//
//  Created by niit on 15/12/23.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 分数类
@interface Fraction : NSObject
{
//    int numerator;// 分子
//    int denominator;// 分母
}

// 分子
@property int numerator;

// =>
// 属性的功能:帮助你写了以下代码
// 1 定义一个是实例变量
//{
//  int _numerator
//}
// 2 编写了以下方法
//- (void)setNumerator:(int)n;
//- (int)numerator;


//// setter getter方法
//- (void)setNumerator:(int)n;
//- (int)numerator;

// 分母
@property int denominator;

//- (void)setDenominator:(int)d;
//- (int)denominator;

- (void)print;// 打印


@end
