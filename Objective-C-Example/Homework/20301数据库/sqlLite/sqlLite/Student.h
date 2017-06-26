//
//  Students.h
//  sqlLite
//
//  Created by student on 16/4/14.
//  Copyright © 2016年 Five. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic,assign) long stuId;
@property (nonatomic,copy) NSString *stuName;
@property (nonatomic,assign) int stuAge;
@property (nonatomic,copy) NSString *stuClass;

// 增加
- (BOOL)insertStudent;
// 删除
- (BOOL)deleteStudent;
// 修改
- (BOOL)updateStudent;
//查询
+ (NSArray *)queryStudents;

@end
