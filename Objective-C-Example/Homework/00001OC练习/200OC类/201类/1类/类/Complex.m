//
//  Complex.m
//  类
//
//  Created by niit on 15/12/24.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Complex.h"

@implementation Complex

- (void)setReal:(float)r
{
    real = r;
}

- (float)real
{
    return real;
}
- (void)setImaginary:(float)i
{
    imaginary = i;
}
- (float)imaginary
{
    return imaginary;
}

- (void)print
{
    NSLog(@"%f+%fi",real,imaginary);
}

@end
