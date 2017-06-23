//
//  Students.m
//  SQLiteDemo
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Student.h"

#import "SQLiteManager.h"

@implementation Student

//"name TEXT,"
//"age INTEGER,"
//"class TEXT,"
//"stuId INTEGER"

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
//        [self setValuesForKeysWithDictionary:dict];
        
        self.stuId = [dict[@"stuId"] longLongValue];
        self.stuName = dict[@"name"];
        self.stuAge = [dict[@"age"] longValue];
        self.stuClass = dict[@"class"];
    }
    return self;
}

+ (instancetype)studentWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

// 增加
- (BOOL)insertStudent
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO T_Students (stuId,name,age,class) VALUES (%i,'%@',%i,'%@');",self.stuId,self.stuName,self.stuAge,self.stuClass];
 
    return [[SQLiteManager shareSQLiteManager] execSQL:sql];
}
// 删除
- (BOOL)deleteStudent
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_Students WHERE stuId = %i;",self.stuId];
    
    return [[SQLiteManager shareSQLiteManager] execSQL:sql];
}
// 修改
- (BOOL)updateStudent
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE T_Students SET name = '%@', age = %i,class = '%@' WHERE stuId = %i",self.stuName,self.stuAge,self.stuClass,self.stuId];
    
    return [[SQLiteManager shareSQLiteManager] execSQL:sql];
}

// 查询
+ (NSArray *)queryStudents
{
    NSString *sql = @"SELECT * FROM T_Students";
    NSArray *results = [[SQLiteManager shareSQLiteManager] querySQL:sql];
    
    NSMutableArray *mArr=[NSMutableArray array];
    for (NSDictionary *dict in results)
    {
        Student *stu = [Student studentWithDict:dict];
        [mArr addObject:stu];
    }
    return mArr;
}

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"学号:%i 姓名:%@ 年龄:%i 班级:%@",self.stuId,self.stuName,self.stuAge,self.stuClass];
    return str;
}

@end
