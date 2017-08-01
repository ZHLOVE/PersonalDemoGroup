//
//  BaseAFHTTPManager.h
//  HiTV
//
//  Created by 蒋海量 on 15/3/3.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface BaseAFHTTPManager : NSObject
/**
 *  POST网络请求
 *
 *  @param host       主机名
 *  @param param      url参数
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return 网络请求实例
 */
+(void)postRequestOperationForHost:(NSString *)host
                   forParam:(NSString *)param
              forParameters:(id)parameters
                 completion:(void (^)(id responseObject))success
                    failure:(void (^)(NSString *error))failure;


+(void)postRequestOperationForHost:(NSString *)host
                          forParam:(NSString *)param
                     forParameters:(id)parameters
                              data:(NSData *)imageData
                        completion:(void (^)(id responseObject))success
                           failure:(void (^)(NSString *error))failure;


+(void)postRequestOperationForHost:(NSString *)host
                          forParam:(NSString *)param
                     forParameters:(id)parameters
                              data:(NSData *)data
                          filename:(NSString *)filename
                          mimetype:(NSString *)minetype
                        completion:(void (^)(id responseObject))success
                           failure:(void (^)(NSString *error))failure;
/**
 *  POST-json数据网络请求
 *
 *  @param host       主机名
 *  @param param      url参数
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return 网络请求实例
 */
+(void)postJsonRequestOperationForHost:(NSString *)host
                          forParam:(NSString *)param
                     forParameters:(id)parameters
                        completion:(void (^)(id responseObject))success
                           failure:(void (^)(NSString *error))failure;


/**
 *  GET网络请求
 *
 *  @param host       主机名
 *  @param param      url参数
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return 网络请求实例
 */
+(void)getRequestOperationForHost:(NSString *)host
                   forParam:(NSString *)param
              forParameters:(id)parameters
                 completion:(void (^)(id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation,NSString *error))failure;

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
+(AFHTTPRequestOperation*)requestJsonWithParameter:(NSString*)param
                                            forHost:(NSString*)host
                                         completion:(void (^)(id responseObject))success
                                            failure:(void (^)(NSString *error))failure;

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
+ (AFHTTPRequestOperation*)requestXMLWithParameter:(NSString*)param
                                           forHost:(NSString*)host
                                        completion:(void (^)(id responseObject))success
                                           failure:(void (^)(NSString *error))failure;
@end
