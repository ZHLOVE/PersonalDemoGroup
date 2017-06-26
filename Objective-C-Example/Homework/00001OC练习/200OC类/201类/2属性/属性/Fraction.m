//
//  Fraction.m
//  类
//
//  Created by niit on 15/12/23.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Fraction.h"

@implementation Fraction


//- (void)setNumerator:(int)n
//{
//    numerator = n;
//}
//- (int)numerator
//{
//    return numerator;
//}

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
    // self 代表自己本身这个对象
    
    NSLog(@"%i/%i",self.numerator,self.denominator);// 等同于 =>   NSLog(@"%i/%i",[self numerator],[self denominator]);
    NSLog(@"%i/%i",_numerator,_denominator);
}

@end
