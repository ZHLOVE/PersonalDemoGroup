//
//  DetailDataPovider.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/17.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//
#import "HotsVideoModel.h"
#import <Foundation/Foundation.h>
/**
 *  DMS系统网络服务
 */

@interface DmsDataPovider : NSObject
/**
 *  获取首页导航
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+(void)getNavigationsRequestCompletion:(void (^)(NSArray *navigationArray))success
                          failure:(void (^)(NSString *message))failure;

/**
 *  首页导航下详情页数据
 *
 *  @param navigateId   导航Id
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+(void)getNavigationDetailRequest:(NSString *)navigateId
                 completion:(void (^)(NSArray *detailDatasArray))success
                    failure:(void (^)(NSString *message))failure;


/**
 *  开机广告
 *
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+(void)getBootAdRequestCompletion:(void (^)(id responseObject))success
                          failure:(void (^)(NSString *message))failure;

/**
 *  @brief 热点视频生产系统获取热点视频详情
 *
 *  @param success
 *  @param failure 
 */
+ (void)getHotVideoDetailWithVideoID:(NSString *)videoid
                     CompletionBlock:(void (^)(id responseObject))success
                             failure:(void (^)(NSString *message))failure;


/**
 *  @brief 热点生成web页面
 *
 *  @param params
 *  @param success
 *  @param failure 
 */
+ (void)hotSpotVideoGenerateWebLinkWith:(requestWebLink *)params
                        CompletionBlock:(void (^)(id responseObject))success
                                failure:(void (^)(NSString *message))failure;


@end
