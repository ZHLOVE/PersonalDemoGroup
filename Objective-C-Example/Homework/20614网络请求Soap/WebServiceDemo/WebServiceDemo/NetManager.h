//
//  NetManager.h
//  WebServiceDemo
//
//  Created by niit on 16/3/31.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject

/**
 *  查询手机号码归属地
 *
 *  @param personId     电话号码
 *  @param successBlock 查询成功block
 *  @param failBlock    失败的block
 */
+ (void)requestInfoByMobileId:(NSString *)mobileId
                 successBlock:(void (^)(NSDictionary *resultInfo))successBlock
                    failBlock:(void (^)(NSError *error))failBlock;

@end
