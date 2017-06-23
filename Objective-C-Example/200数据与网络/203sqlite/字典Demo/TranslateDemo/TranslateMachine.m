//
//  TranslateMachine.m
//  TranslateDemo
//
//  Created by Qiang on 15/4/13.
//  Copyright (c) 2015年 QiangTech. All rights reserved.
//

#import "TranslateMachine.h"
#import <sqlite3.h>

sqlite3 *db;

@interface TranslateMachine()
{

}

@end

@implementation TranslateMachine

+ (NSString *)dbPath
{
    // 打包
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"myDict" ofType:@"db"];
//    NSLog(@"%@",filePath);

    // 沙盒
//    NSArray *myPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *myDocPath=myPath[0];
//    NSString *filePath=[myDocPath stringByAppendingPathComponent:@"myDict.db"];
//    NSLog(@"%@",filePath);
    
    return filePath;
}

+ (NSString *)translate:(NSString *)sourceText
{
    NSString *filename = [self dbPath];
    NSString *result = nil;
    if (sqlite3_open([filename UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(NO,@"数据库打开失败。");
    } else
    {
        NSString *sqlStr = [NSString stringWithFormat: @"SELECT explain FROM Words WHERE word = '%@'",sourceText];
        NSLog(@"%@",sqlStr);
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                char *field1 = (char *)sqlite3_column_text(statement, 0);
                result = [[NSString alloc] initWithUTF8String:field1];
                break;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return result;
}
@end
