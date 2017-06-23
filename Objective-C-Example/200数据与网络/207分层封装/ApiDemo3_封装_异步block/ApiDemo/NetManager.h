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
 *  @param personId     要查询身份证编号
 *  @param successBlock 请求数据成功后执行的block回调
 *  @param failBlock    请求数据失败后执行的block
 */
+ (void)requestInfoByPersonId:(NSString *)personId
                 successBlock:(void (^)(NSString *))successBlock
                     faiBlock:(void (^)(NSError *))failBlock;

/**
 *  查询天气信息
 *
 *  @param cityName 城市名字
 *
 *  @return 这个城市的天气信息
 */
+ (void)requestWeatherByCityName:(NSString *)cityName
                    successBlock:(void (^)(NSDictionary *weatherInfoDict))successBlock
                       failBlock:(void (^)(NSError *error))successBlock;
@end
