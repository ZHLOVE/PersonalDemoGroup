//
//  Student.h
//  归档
//
//  Created by niit on 16/1/12.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// Foundation定义的两个重要的协议
// NSCopying -> 实现对象赋值
// NSCoding -> 实现对象归档

// 对象要支持归档，需要让他支持NSCoding协议

@interface Student : NSObject<NSCoding>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int age;

@end
