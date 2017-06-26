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


@end



