//
//  DataBase.h
//  LGJ
//
//  Created by student on 16/5/12.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "def.h"
#import "Singleton.h"
#import "DataModel.h"
@interface DataBase : NSObject

SingletonH(DataBase)
/**
 *  打开数据库
 */
+ (void)openDB;
/**
 *  创建数据库
 */
+ (void)createDataBase;

/**
 *  插入一条数据
 */
+ (BOOL)insertDataWithName:(NSString *)name
                andImgName:(NSString *)imageName
                  andCount:(NSString *)count
                andDayFrom:(NSString *)dayF
                  andDayTo:(NSString *)dayT
                   andType:(NSString *)type;

/**
 *  查询所有数据
 *
 *  @return 数组中存放数据模型
 */
+ (NSArray *)quaryAllData;

/**
 *  删除一条数据
 */
+ (void)deleteWithGid:(int) gid;

/**
 *  更新一条数据
 */
+ (BOOL)updateWithModel:(DataModel *)model;

@end
