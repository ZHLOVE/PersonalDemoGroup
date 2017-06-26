//
//  CommFunc.h
//  类方法
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommFunc : NSObject

// 颜色值转换成颜色字符串
+ (NSString *)colorStr:(int)color;

// 两个参数
+ (int)addA:(int)a andB:(int)b;
//add:and:

// 三个参数
//+ (void)setStuId:(int)stuId andName:(NSString *)name andAge:(int)age;
//setStuId:andName:andAge:



@end
