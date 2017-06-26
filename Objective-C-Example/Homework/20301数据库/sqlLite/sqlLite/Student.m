//
//  Students.m
//  sqlLite
//
//  Created by student on 16/4/14.
//  Copyright © 2016年 Five. All rights reserved.
//

#import "Student.h"

#import "SQLiteManager.h"
@implementation Student

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //        [self setValuesForKeysWithDictionary:dict];
        
        self.stuId = [dict[@"StuID"] longLongValue];
        self.stuName = dict[@"name"];
        self.stuAge = [dict[@"age"] longValue];
        self.stuClass = dict[@"class"];
    }
    return self;
}

+ (instancetype)studentWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

//增删改
// 增加
- (BOOL)insertStudent
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO StudentInfo (StuID,name,age,class) VALUES (%i,'%@',%i,'%@');",self.stuId,self.stuName,self.stuAge,self.stuClass];
    
    return [[SQLiteManager shareSQLiteManager] execSQL:sql];
}
// 删除
- (BOOL)deleteStudent
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM StudentInfo WHERE StuID = %ld;",self.stuId];
    
    return [[SQLiteManager shareSQLiteManager] execSQL:sql];
}
// 修改
- (BOOL)updateStudent
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE StudentInfo SET name = '%@', age = %i,class = '%@' WHERE StuID = %ld",self.stuName,self.stuAge,self.stuClass,self.stuId];
    
    return [[SQLiteManager shareSQLiteManager] execSQL:sql];
}

// 查询
+ (NSArray *)queryStudents
{
    NSString *sql = @"SELECT * FROM StudentInfo";
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
