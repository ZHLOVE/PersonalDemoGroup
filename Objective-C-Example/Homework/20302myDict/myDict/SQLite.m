//
//  SQLite.m
//  myDict
//
//  Created by student on 16/4/13.
//  Copyright © 2016年 Five. All rights reserved.
//

#import "SQLite.h"

#import <sqlite3.h>
@interface SQLite()
{
    //数据库指针
    sqlite3 *db;
}
@end
@implementation SQLite

SingletonM(SQLite)
- (void)openDB{
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"myDict" ofType:@"db"];
    NSLog(@"%@",dbPath);
    //如果已存在，就打开，不存在则新建一个数据库文件
    if (sqlite3_open([dbPath UTF8String],&db) == SQLITE_OK) {
        //数据库打开成功
        
        NSLog(@"数据连接成功");
    }else{
        //数据库打开失败
         NSLog(@"数据连接失败");
    }

}

- (NSArray *)quaryInfoWithStr:(NSString *)str{
    NSMutableArray *mArr = [NSMutableArray array];
//    NSString *sql =[NSString stringWithFormat:@"SELECT word,explain,phonetic from Words where word like '%@%'",str]; //模糊查询带%不启用
//    NSString *sql =[NSString stringWithFormat:@"SELECT word,explain,phonetic from Words where word like '%@%'",str];
    NSString *sql =[NSString stringWithFormat:@"SELECT word,explain,phonetic from Words where word like '%@'",str];
    NSLog(@"%@",sql);
    //句柄
    sqlite3_stmt *stmt;
    //预处理
    //预编译SQL语句，检查错误
    //数据库对象，SQL语句 -1 &操作数据库的指针，nil
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) ==SQLITE_OK) {
        //2查询数据
        //step代表从里面查询出一条数据
        while (sqlite3_step(stmt) == SQLITE_ROW ) {
            //信息就在stmt中
            char *wordChar = sqlite3_column_text(stmt, 0);
            char *explainChar = sqlite3_column_text(stmt, 1);
            char *phoneticChar = sqlite3_column_text(stmt, 2);
            
            NSString *word = [[NSString alloc] initWithUTF8String:wordChar];
            NSString *explain = [[NSString alloc] initWithUTF8String:explainChar];
            NSString *phonetic = [[NSString alloc] initWithUTF8String:phoneticChar];
//            NSLog(@"%@ %@ %@",word,explain,phonetic);
            NSDictionary *dict = @{@"word":word,
                                   @"explain":explain,
                                   @"phonetic":phonetic};
            [mArr addObject:dict];

        }
    }
    return [mArr copy];

}
@end
