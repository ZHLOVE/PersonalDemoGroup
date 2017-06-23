//
//  Students.h
//  SQLiteDemo
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
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

+ (NSArray *)queryStudents;

@end
