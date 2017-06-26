//
//  Fraction.m
//  类
//
//  Created by niit on 15/12/23.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Fraction.h"

@implementation Fraction

// 1)如果不写
// 自动创建带下划线的实例变量

// 2)
//@synthesize numerator;
// 创建于属性名同名的实例变量名

// 3)
//@synthesize numerator = nnn;
// 创建于自己指定的nnn的实例变量名

//- (void)setNumerator:(int)n
//{
//    // n 局部变量  形参 作用域本方法内 局部的变量
//    // numerator  实例变量 本类任何地方都可以使用
//    numerator = n;
//}
//
//- (int)numerator
//{
//    return numerator;
//}
//
//
//- (void)setDenominator:(int)d
//{
//    denominator = d;
//}
//
//- (int)denominator
//{
//    return denominator;
//}

- (void)print
{
    NSLog(@"%i/%i",_numerator,_denominator);
}


- (void)add:(Fraction *)bFraction
{
    //自己 和 bFraction相加 结果保存到自己
    
    // 自己的分子和分母
//    self.numerator self.denominator
//    _numerator
//    _denominator
    
    // 传入分数的分子和分母
//    bFraction.numerator
//    bFraction.denominator
    
    int n,d;
    
    // 结果
    // 分子
    n = self.numerator * bFraction.denominator + self.denominator * bFraction.numerator;
    // 分母
    d = self.denominator * bFraction.denominator;
    
    self.numerator = n;
    self.denominator = d;
    
    // 调用本身的约分方法进行约分
    [self reduce];
}

- (void)sub:(Fraction *)bFraction
{
    int n,d;
    
    // 分子
    n = self.numerator * bFraction.denominator - self.denominator * bFraction.numerator;
    // 分母
    d = self.denominator * bFraction.denominator;
    
    self.numerator = n;
    self.denominator = d;
    
    [self reduce];
}

- (void)mul:(Fraction *)bFraction
{
    
}

- (void)div:(Fraction *)bFraction
{
    
}

// 约分
- (void)reduce
{
    // 3/6 => 1/2
    // 实现本身约分
    
    
}

@end
