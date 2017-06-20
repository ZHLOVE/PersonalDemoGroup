//
//  DataBase.m
//  LGJ
//
//  Created by student on 16/5/12.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "DataBase.h"
#import "DataModel.h"
#import <FMDB.h>
@implementation DataBase

SingletonM(DataBase)


/**
 *  查询所有数据
 *
 *  @return 数组中存放数据模型
 */
+ (NSArray *)quaryAllData{
    NSMutableArray *mArray = [NSMutableArray array];
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"LGJ.sqlite"];
    FMDatabase *db =  [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = @"select * from T_CookGoods";
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            DataModel *model = [[DataModel alloc]init];
            model.gid = [[result stringForColumn:@"id"] intValue];
            model.name = [result stringForColumn:kName];
            model.image = [result stringForColumn:kImage];
            model.counts = [result stringForColumn:kCounts];
            model.dayFrom = [result stringForColumn:kDayFrom];
            model.dayTo = [result stringForColumn:kDayTo];
            model.type = [result stringForColumn:kType];
            [mArray addObject:model];
        }
    }
    return [mArray copy];
}


/**
 *  插入一条数据
 */
+ (BOOL)insertDataWithName:(NSString *)name
                andImgName:(NSString *)imageName
                  andCount:(NSString *)count
                andDayFrom:(NSString *)dayF
                  andDayTo:(NSString *)dayT
                   andType:(NSString *)type{
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"LGJ.sqlite"];
    FMDatabase *db =  [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = @"INSERT INTO T_CookGoods(name,image,counts,dayFrom,dayTo,type) VALUES(%@,%@,%@,%@,%@,%@)";
        [db executeUpdateWithFormat:sql,name,imageName,count,dayF,dayT,type];
        [db close];
        return YES;
    }else{
        return NO;
    }
}

/**
 *  打开数据库
 */
+ (void)openDB{
    // 连接创建数据库
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"LGJ.sqlite"];
    FMDatabase *db =  [FMDatabase databaseWithPath:dbPath];
    [db open];
    DLog(@"连接数据库成功:%@",dbPath);
    [db close];
}

/**
 *  创建数据库
 */
+ (void)createDataBase{
    // 连接创建数据库
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"LGJ.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    DLog("%@",dbPath);
    // 连接数据库
    if([db open])
    {
        DLog(@"打开数据库成功");
        // 创建表格
        NSString *sql = @"CREATE TABLE IF NOT EXISTS T_CookGoods ("
        "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "
        "name TEXT,"
        "image TEXT,"
        "counts TEXT,"
        "dayFrom TEXT,"
        "dayTo TEXT,"
        "type TEXT"
        ")";
        if([db executeUpdate:sql])
        {
            DLog(@"创建表格成功");
        }
        else
        {
            DLog(@"创建失败");
        }
    }
    else
    {
        DLog(@"打开数据库失败");
    }
}


/**
 *  删除一条数据
 */
+ (void)deleteWithGid:(int) gid{
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"LGJ.sqlite"];
    FMDatabase *db =  [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_CookGoods WHERE id = '%d' ",gid];
        [db executeUpdate:sql];
        [db close];
    }

}

/**
 *  更新一条数据
 */
+ (BOOL)updateWithModel:(DataModel *)model{
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"LGJ.sqlite"];
    FMDatabase *db =  [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE T_CookGoods SET name = '%@',counts = '%@',dayFrom = '%@',dayTo = '%@',type = '%@' WHERE id = '%d'",model.name,model.counts,model.dayFrom,model.dayTo,model.type,model.gid];
        [db executeUpdate:sql];
        [db close];
        return YES;
    }else{
        return NO;
    }
}
@end

