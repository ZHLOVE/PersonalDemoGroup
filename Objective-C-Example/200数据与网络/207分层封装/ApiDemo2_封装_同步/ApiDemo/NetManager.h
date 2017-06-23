//
//  NetManager.h
//  ApiDemo
//
//  Created by niit on 16/3/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject

/**
 *  查询身份证
 *
 *  @param personId 身份证编号
 *
 *  @return 身份证信息
 */
+ (NSString *)requestInfoByPersonId:(NSString *)personId;

/**
 *  查询天气信息
 *
 *  @param cityName 城市名字
 *
 *  @return 这个城市的天气信息
 */
+ (NSDictionary *)requestWeatherByCityName:(NSString *)cityName;
@end
