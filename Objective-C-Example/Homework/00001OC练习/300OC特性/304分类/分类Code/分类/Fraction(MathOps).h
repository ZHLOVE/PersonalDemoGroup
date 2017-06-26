//
//  Fraction(MathOps).h
//  分类
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Fraction.h"

@interface Fraction(MathOps)
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
