//
//  NetManageer.h
//  apiDemo3_block
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManageer : NSObject


+ (void)requestInfoByPhone:(NSString *)phone
              successBlock:(void(^)(NSString *result))successBlock
                 failBlock:(void(^)(NSError *error))failBlock;

+ (void)requestInfoByCNY:(NSString *)CNY
            successBlock:(void(^)(NSDictionary *result))successBlock
               failBlock:(void(^)(NSError *error))failBlock;

+ (void)requestWeatherInfoByCityName:(NSString *)cityName
                        successBlock:(void(^)(NSDictionary *result))successBlock
                           failBlock:(void(^)(NSError *error))failBlock;
@end
