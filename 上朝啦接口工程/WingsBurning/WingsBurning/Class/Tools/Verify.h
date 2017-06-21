//
//  Verify.h
//  Tesla
//
//  Created by MBP on 16/7/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetModel.h"

@interface Verify : NSObject

/**
 *  保存token到沙盒
 */
+ (void)saveToken:(TokensM *)tokens;

/**
 *  检查accessToken
 */
+ (BOOL)checkAccessToken;

/**
 *  从沙盒中拿accessToken
 */
+ (NSString *)getAccessTokenFromSandBox;


/**
 *  从沙盒中拿refreshToken
 */
+ (NSString *)getRefreshTokenFromSandBox;

/**
 *  获取星期几
 *
 *  @param inputDateStr yyyy-MM-dd
 */
+ (NSString*)weekdayStringFromDate:(NSDate *)inputDate;
/**
 *  获取时间戳
 *
 *  @return 时间戳
 */
+ (NSString *)getTimestamp;

/**
 *  获取校验信息MD5(API账号+API密码+uuid+time)
 *
 *  @return 校验信息
 */
+ (NSString *)getVerifyWithApiAccount:(NSString *)apiAccount
                            apiPasswd:(NSString *)apiPasswd
                                uuid:(NSString *)uuuid
                                 time:(NSString *)time;

@end
