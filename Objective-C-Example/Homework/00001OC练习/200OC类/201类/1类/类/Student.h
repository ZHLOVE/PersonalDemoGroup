//
//  Student.h
//  类
//
//  Created by niit on 15/12/25.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

// 实例变量:
// 学号 姓名 年龄

// 1 属性
// 基本类型  assign
@property (nonatomic,assign) int stuId;
// NSString 用copy
@property (nonatomic,copy) NSString *stuName;

@property (nonatomic,assign) int stuAge;

// strong
// weak

// 2 方法
- (void)printInfo;

@end
