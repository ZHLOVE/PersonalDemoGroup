//
//  MRDataBase.h
//  logDemo
//
//  Created by MccRee on 2017/7/20.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogTable.h"
#import "RelationTable.h"
#import "SendTable.h"


@interface MRDataBase : NSObject

/**
 *  单例初始化建库建表
 */
+ (instancetype)sharedMRDataBase;

#pragma mark -日志表
/**
 数据插入日志表
 */
- (void)insertDataToLogTable:(LogTable *)log;

/**
 从日志表选出state为0的日志插入发送表,40条一分页
 */
- (void)insertSendTableAccordToLogState;

#pragma mark -关系表
/**
 数据插入关系表
 */
- (void)insertDataToRelationTable:(RelationTable *)relation;

#pragma mark -发送表
/**
 搜索发送成功的数据,删除发送表，关系表，日志表中发送成功的
 */
- (void)searchSendTableAndClearSuccessData;

/**
 发送表中发送状态0的改成2,同时更新发送表状态并更新retryseqid,同时日志表state+1;
 */
- (void)handleLogAccordToSendState;

/**
 发送成功更新发送表中发送状态
 */
- (void)successUpdateSendTableState:(NSString *)seqid;

/**
 发送失败时,更新发送表状态并更新retryseqid,同时日志表state+1;
 */
- (void)failedUpdateSendTable:(NSString *)seqid;

/**
 拿到发送表中需要发送的数据
 
 @return 要发送的
 */
- (NSArray *)getDataFromSendTableToSend;
#pragma mark -其他















@end
