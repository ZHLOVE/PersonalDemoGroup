//
//  VideoDataProvider.h
//  HiTV
//
//  created by iSwift on 3/7/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataProvider.h"

/**
 *  点播相关的网络封装
 */
@interface VideoDataProvider : DataProvider

+ (instancetype)sharedInstance;

/**
 *  获得首页点播分类列表
 *
 *  @param catgId  分类id
 *  @param page    分页编号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)getCategories:(int)catgId
           pageNumber:(int)page
           completion:(void (^)(id responseObject))success
              failure:(void (^)(NSString *error))failure;

/**
 *  获得首页轮播列表
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)getTopRecommendlistWithCompletion:(void (^)(id responseObject))success
                                  failure:(void (^)(NSString *error))failure;

/**
 *  获得某一分类的前三个视频信息
 *
 *  @param categoryID 分类编号
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 网络操作实例，可以去掉网络调用
 */
- (AFHTTPRequestOperation*)getRecommendlistWithCategoryID:(NSString *)categoryID
                                               completion:(void (^)(id responseObject))success
                                                  failure:(void (^)(NSString *error))failure;

/**
 *  获得子分类列表
 *
 *  @param actionURL 链接
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)getSubCategoriesWithCatgItemId:(NSString *)catgItemId
                           completion:(void (^)(id responseObject))success
                              failure:(void (^)(NSString *error))failure;

/**
 *  获得视频列表信息
 *
 *  @param actionURL 链接
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)getVideosWithActionURL:(NSString*)actionURL
                    completion:(void (^)(id responseObject, int currentPageNumber, BOOL hasMore))success
                       failure:(void (^)(NSString *error))failure;

/**
 *  获得视频详情信息
 *
 *  @param actionURL 链接
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return 网络操作实例，可以去掉网络调用
 */
- (AFHTTPRequestOperation*)getVideo:(NSString*)programSeriesId
      completion:(void (^)(id responseObject))success
         failure:(void (^)(NSString *error))failure;

/**
 *  获得视频相关的视频
 *
 *  @param actionURL 链接
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)getRelation:(NSString*)actionURL
         completion:(void (^)(id responseObject))success
            failure:(void (^)(NSString *error))failure;

@end
