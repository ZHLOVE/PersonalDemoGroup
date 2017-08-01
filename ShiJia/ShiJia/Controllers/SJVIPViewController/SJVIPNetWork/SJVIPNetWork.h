//
//  SJVIPNetWork.h
//  ShiJia
//
//  Created by 峰 on 16/9/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJVIPNetWork : NSObject
/**
 *  VIP 鉴权
 *
 *  @param params
 *  @param Handlerblock
 */
+(void)SJ_UserJudegVIPRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock;

/**
 * 获取观影券
 */

+(void)SJ_CouponTicketsRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock;

/**
 *  获取 VIP 套餐 
 */
+(void)SJ_VIPPackagesRequest:(id)params Block:(void(^)(id result ,NSString *error))Handlerblock;

/**
 *  验证 Apple Store
 */

+(void)SJ_ValiteAppleStore:(id)params Block:(void(^)(id result,NSString *error))Handleblock;

@end
