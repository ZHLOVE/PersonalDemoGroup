//
//  Fraction(MathOps).m
//  分类
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Fraction(MathOps).h"

@implementation Fraction(MathOps)

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