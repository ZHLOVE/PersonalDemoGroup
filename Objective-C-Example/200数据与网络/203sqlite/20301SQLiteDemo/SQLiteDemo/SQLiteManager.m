//
//  SQLiteManager.m
//  SQLiteDemo
//
//  Created by niit on 16/4/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "SQLiteManager.h"

#import <sqlite3.h>

@interface SQLiteManager()
{
    // 数据库指针
    sqlite3 *db;
}

@end

@implementation SQLiteManager

SingletonM(SQLiteManager)

- (void)openDB:(NSString *)dbName
{
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dbName];
    NSLog(@"%@",dbPath);

    // sqlite3_open (数据库位置,&数据库指针地址)
    // 如果已存在，就打开已存在的数据库文件
    // 如果不存在,会新建一个数据库文件
    if(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功");
        // 创建表格
        [self createTable];
    }
    else
    {
        // 数据库打开失败,一般是由于路径问题造成失败
        NSLog(@"创建失败");
    }
}

#pragma mark - DDL
- (void)createTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS T_Students ("
    "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "
    "name TEXT,"
    "age INTEGER,"
    "class TEXT,"
    "stuId INTEGER"
    ")";
    
    NSLog(@"%@",sql);
    
    // sqlite3_exec 创建、删除、修改、更新 都使用该语句
    // sqlite3_exec (已经打开的数据库,SQL语句,执行完语句的回调函数,回函数的参数,nil)
    // 执行成功 返回 SQLITE_OK
    if(sqlite3_exec(db, [sql UTF8String], nil, nil, nil) == SQLITE_OK)
    {
        NSLog(@"sql语句执行成功");
    }
    else
    {
        NSLog(@"sql语句执行失败");
    }
}

#pragma mark - DML
- (void)addStudentByStuId:(int)stuId
                     name:(NSString *)name
                      age:(int)age
                    class:(NSString *)stuClass
{
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO T_Students (stuId,name,age,class) VALUES (%i,'%@',%i,'%@');",stuId,name,age,stuClass];
    NSLog(@"%@",sql);
    if(sqlite3_exec(db, [sql UTF8String], nil, nil, nil) == SQLITE_OK)
    {
        NSLog(@"sql语句执行成功");
    }
    else
    {
        NSLog(@"sql语句执行失败");
    }
}

- (void)deleteStudent:(int)stuId
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_Students WHERE stuId = %i;",stuId];
    NSLog(@"%@",sql);
    if(sqlite3_exec(db, [sql UTF8String], nil, nil, nil) == SQLITE_OK)
    {
        NSLog(@"sql语句执行成功");
    }
    else
    {
        NSLog(@"sql语句执行失败");
    }
}

- (void)updateStudentByStuId:(int)stuId
                     name:(NSString *)name
                      age:(int)age
                    class:(NSString *)stuClass
{
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE T_Students SET name = '%@', age = %i,class = '%@' WHERE stuId = %i",name,age,stuClass,stuId];
    NSLog(@"%@",sql);
    if(sqlite3_exec(db, [sql UTF8String], nil, nil, nil) == SQLITE_OK)
    {
        NSLog(@"sql语句执行成功");
    }
    else
    {
        NSLog(@"sql语句执行失败");
    }
}

#pragma mark - DQL
- (NSArray *)findAllStudents
{
    NSString *sql = @"SELECT stuId,name,age,class FROM T_Students";
    NSLog(@"%@",sql);

    // 数据的指针
    sqlite3_stmt *stmt;
    
    // 1 预处理
    // 预编译SQL语句,检查错误
    // (数据库对象,SQL语句,-1,&操作数据的指针,nil)
    NSMutableArray *stuList = [NSMutableArray array];
    
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1,&stmt,nil) == SQLITE_OK)
    {
        //2. 查询数据
        // sqlite3_step代表从里面查询出一条数据
        // 执行成功 返回 SQLITE_ROW ,否则就是已经查询完毕。
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            // 信息在stmt中
            int stuId = sqlite3_column_int(stmt, 0);
            char *stuName = sqlite3_column_text(stmt, 1);
            int stuAge = sqlite3_column_int(stmt, 2);
            char *stuClass = sqlite3_column_text(stmt, 3);
            
            NSString *name = [[NSString alloc] initWithUTF8String:stuName];
            NSString *stuC = [[NSString alloc] initWithUTF8String:stuClass];
            
            NSLog(@"%i %s %i %s",stuId,stuName,stuAge,stuClass);
            NSDictionary *dict = @{@"stuId":@(stuId),
                                   @"name":name,
                                   @"age:":@(stuAge),
                                   @"class":stuC};
            [stuList addObject:dict];
        }
    }
    
    return stuList;
}


@end
