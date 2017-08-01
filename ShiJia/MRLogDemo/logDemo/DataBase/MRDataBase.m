//
//  MRDataBase.m
//  logDemo
//
//  Created by MccRee on 2017/7/20.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "MRDataBase.h"
#import "JQFMDB.h"
#import "NSString+Conversion.h"

#define ContentCount 40 //一条发送记录所关联日志数
@interface MRDataBase()

@property(nonatomic,strong) JQFMDB *db;

@end

@implementation MRDataBase



+ (instancetype)sharedMRDataBase{
    static MRDataBase *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[MRDataBase alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        JQFMDB *db = [JQFMDB shareDatabase:@"logDB.sqlite" path:path];
        NSLog(@"logDB_Path=========>\n%@",path);
        if (![db jq_isExistTable:@"LogTable"]) {
            [db jq_createTable:@"LogTable" dicOrModel:[LogTable class]];
        }
        if (![db jq_isExistTable:@"RelationTable"]) {
            [db jq_createTable:@"RelationTable" dicOrModel:[RelationTable class]];
        }
        if (![db jq_isExistTable:@"SendTable"]) {
            [db jq_createTable:@"SendTable" dicOrModel:[SendTable class]];
        }
        
    });
    return instance;
}

#pragma mark -日志表
/**
 数据插入日志表
 */
- (void)insertDataToLogTable:(LogTable *)log{
    JQFMDB *db = [JQFMDB shareDatabase];
    [db jq_inDatabase:^{
        [db jq_insertTable:@"logTable" dicOrModel:log];
    }];

}


#pragma mark -关系表
/**
 数据插入关系表
 */
- (void)insertDataToRelationTable:(RelationTable *)relation{
    JQFMDB *db = [JQFMDB shareDatabase];
    [db jq_inDatabase:^{
        [db jq_insertTable:@"relationTable" dicOrModel:relation];
    }];

}


#pragma mark -发送表
/**
 数据插入发送表同时更新关系表,state排序后插入发送表
 @param logArr 待插入的日志表数据
 */
- (void)insertDataToSendTableUseLogArr:(NSArray *)logArr{
    SendTable *send = [[SendTable alloc]init];
    send.contentcount = [NSString stringWithFormat:@"%lu",(unsigned long)logArr.count];
    __block NSString *sendContxt = @"";
    [self.db jq_inTransaction:^(BOOL *rollback) {
        BOOL flag = YES;
        for (LogTable *log in logArr) {
            sendContxt  = [sendContxt stringByAppendingFormat:@"%@<yst>",log.logText];
            RelationTable *relation = [[RelationTable alloc]init];
            relation.seqid = send.seqid;
            relation.logId = log.logId;
            flag = [self.db jq_insertTable:@"RelationTable" dicOrModel:relation];
        }
        if (flag == NO) {
            *rollback = YES;
            NSLog(@"事务：发送表插入与关系表插入,失败");
            return;
        }
    }];
    send.contenttext = [sendContxt substringToIndex:[sendContxt length] - 5];
    [self.db jq_insertTable:@"SendTable" dicOrModel:send];
    NSLog(@"插入发送表:%@<===>日志数:%@",send.seqid,send.contentcount);
}

/**
 从日志表选出state为0的日志插入发送表ContentCount为分页条数
 */
- (void)insertSendTableAccordToLogState{
    NSArray *logArr = [self.db jq_lookupTable:@"LogTable" dicOrModel:[LogTable class] whereFormat:@"where state = 0 or state = 999 ORDER BY state DESC"];
    NSUInteger itemsRemaining = logArr.count;
    int j = 0;
    while(itemsRemaining) {
        NSRange range = NSMakeRange(j, MIN(ContentCount, itemsRemaining));
        NSArray *subLogArr = [logArr subarrayWithRange:range];
        [self insertDataToSendTableUseLogArr:subLogArr];
        itemsRemaining-=range.length;
        j+=range.length;
    }
}

/**
 搜索发送成功的sendState1数据,删除发送表，关系表，日志表中发送成功的
 */
- (void)searchSendTableAndClearSuccessData{
    __weak typeof(self) weakSelf = self;
  NSArray *arr =  [self.db jq_lookupTable:@"SendTable" dicOrModel:[SendTable class] whereFormat:@"where sendState = 1"];
    [self.db jq_inTransaction:^(BOOL *rollback) {
        for (SendTable *s in arr) {
            NSArray *arr = [weakSelf.db jq_lookupTable:@"RelationTable" dicOrModel:[RelationTable class] whereFormat:@"where seqid = '%@'",s.seqid];
            
            for (RelationTable *relat in arr) {
                [weakSelf.db jq_deleteTable:@"LogTable" whereFormat:@"where logId = '%@'",relat.logId];
            }
            [weakSelf.db jq_deleteTable:@"RelationTable" whereFormat:@"where seqid = '%@'",s.seqid];
            [weakSelf.db jq_deleteTable:@"SendTable" whereFormat:@"where seqid = '%@'",s.seqid];
        }
        NSLog(@"发送成功数据清理完毕");
    }];
}

/**
 发送表中发送状态0的改成2,同时更新发送表状态并更新retryseqid,同时日志表state+1;
 */
- (void)handleLogAccordToSendState{
    NSArray *arr = [self.db jq_lookupTable:@"SendTable" dicOrModel:[SendTable class] whereFormat:@"where sendState = 0"];
    for (SendTable *se in arr) {
        NSLog(@"需要更新的发送id:%@",se.seqid);
        [self failedUpdateSendTable:se.seqid];
    }
}

/**
 把发送表中数据都发送

 @return 要发送的
 */
- (NSArray *)getDataFromSendTableToSend{
    NSArray *arr = [self.db jq_lookupTable:@"SendTable" dicOrModel:[SendTable class] whereFormat:@""];
    return arr;
}

/**
 发送失败时,更新发送表状态并更新retryseqid,同时日志表state+1;
 */
- (void)failedUpdateSendTable:(NSString *)seqid{
    __weak typeof(self) weakSelf = self;
    NSString *newSeqid =  [NSString generateUUID];
    //更新发送表
    NSArray *arr = [self.db jq_lookupTable:@"SendTable" dicOrModel:[SendTable class] whereFormat:@"where seqid = '%@'",seqid];
    SendTable *se = (SendTable *)arr[0];
    if ([se.retryseqid isEqualToString:@"0"]) {
        [self.db jq_updateTable:@"SendTable" dicOrModel:@{@"seqid":newSeqid,@"sendState":@"2",@"retryseqid":seqid} whereFormat:@"WHERE seqid= '%@'",seqid];
    }else{
        [self.db jq_updateTable:@"SendTable" dicOrModel:@{@"seqid":newSeqid,@"sendState":@"2"} whereFormat:@"WHERE seqid= '%@'",seqid];
    }
    //反查关系表,更新关系表,更新日志表
    [self.db jq_inTransaction:^(BOOL *rollback) {
        NSArray *arr = [weakSelf.db jq_lookupTable:@"RelationTable" dicOrModel:[RelationTable class] whereFormat:@"where seqid = '%@'",seqid];
        for (RelationTable *relat in arr) {
            NSString *logId = relat.logId;
            [weakSelf.db jq_updateTable:@"RelationTable" dicOrModel:@{} whereFormat:@"seqid = '%@' where logId = '%@'",newSeqid,logId];
            BOOL f = [weakSelf.db jq_updateTable:@"LogTable" dicOrModel:@{} whereFormat:@"state = state + 1 where logId = '%@'",logId];
            if (f == NO) {
                *rollback = YES;
                NSLog(@"logId更新失败");
                return;
            }
        }
    }];
}

/**
 发送成功更新发送表中发送状态
 */
- (void)successUpdateSendTableState:(NSString *)seqid{
    NSLog(@"发送成功\n%@",seqid);
    [self.db jq_updateTable:@"SendTable" dicOrModel:@{@"sendState":@"1"} whereFormat:@"where seqid = '%@'",seqid];
}

#pragma mark-其他
- (JQFMDB *)db{
    if (_db == nil) {
        _db = [JQFMDB shareDatabase];
    }
    return _db;
}





@end
