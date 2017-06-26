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
//    // 1 实例变量
//    int numerator;// 分子
//    int denominator;// 分母
}

// 2 方法
//// setter getter方法
//- (void)setNumerator:(int)n;
//- (int)numerator;
//
//- (void)setDenominator:(int)d;
//- (int)denominator;

// assign 基本类型

@property (nonatomic,assign) int numerator;
@property (nonatomic,assign) int denominator;

- (void)print;// 打印

// 加减乘除
// 传入另外一个Faction对象,进行加减运算，保存在本身这个对象
- (void)add:(Fraction *)bFraction;
- (void)sub:(Fraction *)bFraction;
- (void)mul:(Fraction *)bFraction;
- (void)div:(Fraction *)bFraction;

// 约分
// 1/3 + 1/6  = 3/6  =>  1/2
- (void)reduce;


@end
