//
//  logTable.h
//  logDemo
//
//  Created by MccRee on 2017/7/19.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogPublicInfo.h"
#import "NSString+Conversion.h"
#import "Utils.h"
#import "MJExtension.h"

@interface LogTable : NSObject


/**
 logId 唯一
 */
@property(nonatomic,strong) NSString *logId;

/**
 时间
 */
@property(nonatomic,strong) NSString *curtime;

/**
 日志内容
 */
@property(nonatomic,strong) NSString *logText;

/**
 日志状态,正常日志0立即上传日志999
 */
@property(nonatomic,assign)  int state;


/**
 公共信息模型
 */
@property(nonatomic,strong) NSObject *logPub;


















@end







