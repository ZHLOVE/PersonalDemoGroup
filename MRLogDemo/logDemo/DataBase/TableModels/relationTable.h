//
//  relationTable.h
//  logDemo
//
//  Created by MccRee on 2017/7/19.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationTable : NSObject


/**
 跟logTable表中logId字段对应
 */
@property(nonatomic,strong) NSString *logId;

/**
 跟sendTable表中seqid对应
 */
@property(nonatomic,strong) NSString *seqid;

@end
