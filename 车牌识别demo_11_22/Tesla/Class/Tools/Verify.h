//
//  Verify.h
//  Tesla
//
//  Created by MBP on 16/7/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Verify : NSObject

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
