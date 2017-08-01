//
//  MRLog.h
//  logDemo
//
//  Created by MccRee on 2017/7/19.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerEventModels.h"
#import "UserEventModels.h"



@interface MRLog : NSObject
/**
 LogPublicInfo公共信息
 */
@property(nonatomic,copy)NSString * uid;        //	用户ID	String	uid
@property(nonatomic,copy)NSString * phone_no;   //	手机号	String	phone_no
@property(nonatomic,copy)NSString * brand;      //	手机品牌	String	brand
@property(nonatomic,copy)NSString * y_cookie;   //	cookie标识	String	y_cookie H5页面使用
@property(nonatomic,copy)NSString * versionid; 	//app版本	String	versionid
@property(nonatomic,copy)NSString * nettype;	//wifi eth 2g 3g 4g 5g
@property(nonatomic,copy)NSString * wifiid;     //无线网络的ssid	String	wifiid
@property(nonatomic,copy)NSString * innerip;    //	内网ip地址	String	innerip
@property(nonatomic,copy)NSString * gatwaymac;  //	网关mac地址	String	gatwaymac


/**
 SendTable公共信息
 */
@property(nonatomic,strong) NSString *deviceid; //设备型号
@property(nonatomic,strong) NSString *platformid; //手机型号
@property(nonatomic,strong) NSString *mac; //mac地址


+ (instancetype)sharedMRLog;

#pragma mark - app启动

/**
 app启动Log处理
 */
- (void)appStartHandleLog;

#pragma mark - 事件点击

/**
 事件记录
 @param model 事件模型
 */
- (void)logEventWithEventModel:(EventModel *)model;

#pragma mark -日志上传
/**
 立即发送日志
 */
- (void)reportLogRightNow;

/**
 上报日志发送失败
 */
- (void)reportLogFail:(NSString *)seqid;

/**
 上报日志发送成功
 */
- (void)reportLogSuccess:(NSString *)seqid;

#pragma -mark 调试使用

























@end
