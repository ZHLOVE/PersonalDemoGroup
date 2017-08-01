//
//  DataProvider.h
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 *  网络相关的基类
 */
@interface DataProvider : NSObject

/**
 *  xml 网络请求
 *
 *  @param param   url参数
 *  @param host    主机名
 *  @param success 成功回调
 *  @param failure 失败毁掉
 *
 *  @return 网络请求实例
 */
- (AFHTTPRequestOperation*)requestXMLWithParameter:(NSString*)param
                                           forHost:(NSString*)host
                                        completion:(void (^)(id responseObject))success
                                           failure:(void (^)(NSString *error))failure;

/**
 *  json 网络请求
 *
 *  @param param   url参数
 *  @param host    主机名
 *  @param success 成功回调
 *  @param failure 失败毁掉
 *
 *  @return 网络请求实例
 */
- (AFHTTPRequestOperation*)requestJsonWithParameter:(NSString*)param
                                            forHost:(NSString*)host
                                         completion:(void (^)(id responseObject))success
                                            failure:(void (^)(NSString *error))failure;

@end
