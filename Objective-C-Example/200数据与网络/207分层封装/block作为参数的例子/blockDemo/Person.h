//
//  Person.h
//  blockDemo
//
//  Created by niit on 16/3/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic,copy) NSString *name;// 姓名
@property (nonatomic,assign) int age;// 年龄
@property (nonatomic,assign) int height;// 体重

@end
