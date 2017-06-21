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
 *  保存手机型号
 */
+(void)savePhoneType:(NSString *)phoneType;
/**
 *  获取沙盒中手机型号
 */
+(NSString *)getPhoneType;


/**
 *  从沙盒获取token
 */
+ (TokensM *)getTokenFromSanBox;

/**
 *  清除token
 */
+ (void)removeToken;

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
 *  存合约ID到沙盒
 */
+ (void)saveContractIDToSandBox:(NSString *)contractID;

/**
 *  存合约状态
 */
+ (void)saveContractStateToSandBox:(NSString *)state;

/**
 *  取合约状态
 */
+ (NSString *)getContractStateToSandBox;


/**
 *  从沙盒中拿ContractID
 */
+ (NSString *)getContractIDFromSandBox;

/**
 *  存雇员信息
 */
+ (void)saveEmployee:(EmployeeM *)employee;
/**
 *  取雇员信息
 */
+ (EmployeeM *)getEmployeeFromSandBox;
/**
 *  存雇主信息
 */
+  (void)saveEmployerToSH:(EmployerM *)employer;
/**
 *  取雇主信息
 */
+  (EmployerM *)getEmployerFromSH;
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

/**
 *  是否能打卡
 *  @param enable YES则进入打卡，NO就显示未签约
 */
+ (void)setPunchEnable:(BOOL)enable;

+ (BOOL)getPunchEnable;

/**
 *  首次拍照
 *
 *  @param first YES则跳转注册NO就上传打卡
 */
+ (void)setFirstCapture:(BOOL)first;
/**
 *  设置拍照跳转注册页面还是上传打卡记录
 */
+ (BOOL)getFirstCapture;

/**
 *  设置经度
 */
+ (void)setLongitude:(NSNumber *)lo;

/**
 *  设置纬度
 */
+ (void)setLatitude:(NSNumber *)la;

/**
 *  获得经度
 */
+ (NSNumber *)getLongitude;
/**
 *  获得纬度
 */
+ (NSNumber *)getLatitude;

/**
 *  保存头像
 */
+ (void)saveEmployeeImage:(NSData *)imgData;
/**
 *  获得头像
 */
+ (NSData *)getImage;
@end













