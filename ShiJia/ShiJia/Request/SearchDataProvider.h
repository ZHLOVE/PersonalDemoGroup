//
//  SearchDataProvider.h
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataProvider.h"

/**
 *  搜索网络服务
 */
@interface SearchDataProvider : DataProvider

/**
 *  单例方法
 *
 *  @return 搜索实例
 */
+ (instancetype)sharedInstance;

/**
 *  搜索请求
 *
 *  @param key     关键字
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)search:(NSString*)key
   keywordType:(NSString*)type
   start:(int)start
withCompletion:(void (^)(id responseObject))success
       failure:(void (^)(NSString *error))failure;

/**
 *  搜索请求
 *
] *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)getTipsWithCompletion:(void (^)(id responseObject))success
       failure:(void (^)(NSString *error))failure;
@end
