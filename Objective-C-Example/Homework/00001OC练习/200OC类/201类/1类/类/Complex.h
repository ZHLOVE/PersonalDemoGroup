//
//  Complex.h
//  类
//
//  Created by niit on 15/12/24.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Complex : NSObject
{
    // 实例变量
    float real;
    float imaginary;
}

- (void)setReal:(float)r;
- (float)real;
- (void)setImaginary:(float)i;
- (float)imaginary;

- (void)print;

@end
