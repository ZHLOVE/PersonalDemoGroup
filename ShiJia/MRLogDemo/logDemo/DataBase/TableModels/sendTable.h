//
//  sendTable.h
//  logDemo
//
//  Created by MccRee on 2017/7/19.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendTable : NSObject

/**
 发送id,要求唯一,每次发送都重新生成,发送失败也重新生成,把旧写入retryseqid,只写第一次
 */
@property(nonatomic,strong) NSString *seqid;

/**
 时间
 */
@property(nonatomic,strong) NSString *curtime;

/**
 设备型号
 */
@property(nonatomic,strong) NSString *deviceid;

/**
 系统版本
 */
@property(nonatomic,strong) NSString *versionid;

/**
 手机型号
 */
@property(nonatomic,strong) NSString *platformid;

/**
 mac地址
 */
@property(nonatomic,strong) NSString *mac;


/**
 重发id,初始为空,失败一次用第一次的覆盖,走失败流程
 */
@property(nonatomic,strong) NSString *retryseqid;

/**
 一条发送对应的日志条数
 */
@property(nonatomic,strong) NSString *contentcount;

/**
 发送内容
 */
@property(nonatomic,strong) NSString *contenttext;


/**
 发送状态
 0 默认
 1表示成功
 2 表示失败
 */
@property(nonatomic,strong) NSString *sendState;













@end
