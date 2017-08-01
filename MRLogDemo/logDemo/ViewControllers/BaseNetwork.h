//
//  BaseNetwork.h
//  logDemo
//
//  Created by MccRee on 2017/7/24.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetwork : NSObject

/**
 *  创建单例
 */
+ (instancetype)sharedNetwork;


+ (void)postRequestHTTPSerializerForHost:(NSString *)host
                                forParam:(NSString *)param
                           forParameters:(id)parameters
                              completion:(void (^)(id responseObject))success
                                 failure:(void (^)(NSString *error))failure;
@end


