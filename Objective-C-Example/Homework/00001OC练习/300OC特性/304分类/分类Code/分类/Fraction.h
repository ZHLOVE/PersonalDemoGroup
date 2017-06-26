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

@property (nonatomic,assign) int numerator;
@property (nonatomic,assign) int denominator;

- (void)print;// 打印

@end

