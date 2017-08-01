//
//  Util.h
//  HiTV
//
//  Created by wesley on 15/8/4.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (BOOL)isMobileNumber:(NSString *)mobile;
+(NSString *)getNetWorkStates;
+(NSString *)nowTimeString;
/*
 * 解压文件
 */
+(BOOL)unArchiveFielFromPath:(NSString*)srcPath toPath:(NSString*)destPath;
/*
 * 检查是否包含特殊符合
 */
+(BOOL)isIncludeSpecialCharact: (NSString *)str;

/*
 * 获取手机型号
 */
+ (NSString *) platformString;

/*
 * 上传日志
 */
+ (void)BDLog:(int) level module:(NSString*) val_module action :(NSString*) val_action content:(NSString*) val_content;

/*
 * 延时上传日志
 */
+ (void)BDLog:(int) level module:(NSString*) val_module action :(NSString*) val_action content:(NSString*) val_content delay:(int)seconds;

/*
 * 获取当前时间
 */
+ (NSString*) getCurrentTime;

/**
 获取当前时间精确到毫秒
 */
+ (NSString *)getCurrentTimetamp;

/*
 * 获取CPU使用情况
 */
+ (float) cpu_usage;

/*
 * 获取Memory使用情况
 */
+(unsigned long) memory_usage;

/*
 * 秒 转换
 */
+(NSString *)secondsString:(NSInteger)seconds;

/*
 * NString 转换 NSDate
 */
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/*
 * 监听流量
 */
+(NSDictionary *) DataCounters;

/*
 * 网络状况
 */
+ (BOOL)isConnectedToInternet;

/**
 网络类型

 @return wifi,2G,3G,4G
 */
+(NSString *)getNetType;


@end
