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

/**
 *  执行操作语句(创建表格、插入、删除、修改)
 *
 *  @param sql 要执行的SQL语句
 *
 *  @return 执行是否成功
 */
- (BOOL)execSQL:(NSString *)sql;

/**
 *  执行查询语句
 *
 *  @param sql 要执行的SQL语句
 *
 *  @return 结果数组
 */
- (NSArray *)querySQL:(NSString *)sql;

@end
