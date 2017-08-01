//
//  IPDetector.h
//  WhatIsMyIP
//
//  Created by ly on 14-2-24.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPDetector : NSObject
/**
 *  内网ip
 */
+ (NSString *)getIPAddress;
/**
 *  内网ip（异步）
 */
+ (void)getLANIPAddressWithCompletion:(void (^)(NSString *IPAddress))completion;

/**
 *  网关
 */
+(NSString *)getGatewayIPAddress;
/**
 *  网关（异步）
 */
+ (void)getGatewayAddressWithCompletion:(void(^)(NSString *IPAddress))completion;

/**
 *  外网（异步）
 */
+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion;

/**
 *  wifi名称
 */
+ (NSString *)currentWifiSSID;
/**
 *  wifi名称（异步）
 */
+ (void)getWifiSSIDWithCompletion:(void(^)(NSString *IPAddress))completion;

+ (NSString *)currentWifiMacIp;

/**
 *  路由器mac
 */
+(NSString*) gateWayMac;

/**
 *  本机mac
 */
+(NSString*) getMacAddress;
@end
