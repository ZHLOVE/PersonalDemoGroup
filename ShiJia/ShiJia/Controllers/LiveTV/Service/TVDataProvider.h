//
//  TVDataProvider.h
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "DataProvider.h"

/**
 *  直播相关的服务
 */
@interface TVDataProvider : DataProvider

+ (instancetype)sharedInstance;

@property (nonatomic) NSTimeInterval serverTimeOffset;

/**
 *  获取直播频道列表
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)getTVListWithCompletion:(void (^)(id responseObject))success
                        failure:(void (^)(NSString *error))failure;

/**
 *  获取某一频道的所有节目
 *
 *  @param tvUUID  频道ID
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)getProgramListForUUID:(NSString*)tvUUID
                   completion:(void (^)(id responseObject))success
                      failure:(void (^)(NSString *error))failure;
//modify by jianghailiang 20150130
- (void)getProgramListForUUIDFromBox:(NSString*)tvUUID
                          completion:(void (^)(id responseObject))success
                             failure:(void (^)(NSString *error))failure;
//modify end
- (void)getServerTimeWithCompletion:(void (^)(id responseObject))success
                            failure:(void (^)(NSString *error))failure;

/**
 *  获得当前播放节目
 *
 *  @param tvUUID  频道ID
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 具体网络实例，可以用来取消调用
 */
- (AFHTTPRequestOperation*)getCurrentProgram:(NSString*)uuid
                                  completion:(void (^)(id responseObject))success
                                     failure:(void (^)(NSString *error))failure;

/**
 *  获得下一个播放节目
 *
 *  @param tvUUID  频道ID
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 具体网络实例，可以用来取消调用
 */
- (AFHTTPRequestOperation*)getNextProgram:(NSString*)uuid
                                programID:(NSString*)programID
                               completion:(void (^)(id responseObject))success
                                  failure:(void (^)(NSString *error))failure;

@end
