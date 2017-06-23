//
//  SQLiteManager.h
//  SQLiteDemo
//
//  Created by niit on 16/4/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"
@interface SQLiteManager : NSObject

SingletonH(SQLiteManager)

// DDL
// 打开数据库 创建表
- (void)openDB:(NSString *)dbName;

// DML (增加 删除 修改)
- (void)addStudentByStuId:(int)stuId
                     name:(NSString *)name
                      age:(int)age
                    class:(NSString *)stuClass;
- (void)deleteStudent:(int)stuId;
- (void)updateStudentByStuId:(int)stuId
                        name:(NSString *)name
                         age:(int)age
                       class:(NSString *)stuClass;

// DQL (查询)
- (NSArray *)findAllStudents;

@end
