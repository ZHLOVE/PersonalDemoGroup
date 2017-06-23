//
//  SoapHelper.h
//  WebServiceDemo
//
//  Created by niit on 16/3/31.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoapHelper : NSObject

/**
 *  1. 封装soap
 *
 *  @param mobileId 电话号码
 *
 *  @return 要发送的soap字符串
 */
+ (NSString *)makeSoapInfo:(NSString *)mobileId;

/**
 *  2. 解析soap
 *
 *  @param data 网络获取的二进制数据
 *
 *  @return 结果字典
 */
+ (NSDictionary *)parseSoapInfo:(NSData *)data;

@end
