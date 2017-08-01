//
//  MsProtocol.h
//  HiTV
//
//  Created by 蒋海量 on 15/8/5.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScreenManager.h"
@interface MsProtocol : NSObject

/**
*  创建关联关系
*
*  @param parameters  入参
*  @param success 成功回调
*  @param failure 失败回调
*/
+(void)creatRelationRequest:(NSDictionary *)parameters
                            completion:(void (^)(id responseObject))success
                               failure:(void (^)(NSString *error))failure;


/**
 *  解除关联关系
 *
 *  @param parameters  入参
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)removeRelationRequest:(NSDictionary *)parameters
                            completion:(void (^)(id responseObject))success
                               failure:(void (^)(NSString *error))failure;

/**
 *  解除解除成员关系
 *
 *  @param parameters  入参
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)removeFamilyRelationRequest:(NSDictionary *)parameters
                  completion:(void (^)(id responseObject))success
                     failure:(void (^)(NSString *error))failure;

/**
 *  获取关联关系列表
 *
 *  @param parameters  入参
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)getTVListRequest:(NSDictionary *)parameters
                  completion:(void (^)(id responseObject))success
                     failure:(void (^)(NSString *error))failure;



/**
 *  获取投屏信息接口
 *
 *  @param parameters  入参
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)getScreenListRequest:(NSDictionary *)parameters
                 completion:(void (^)(id responseObject))success
                    failure:(void (^)(NSString *error))failure;

/**
 *  用户自定义文件上传接口
 *
 *  @param parameters  入参
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)uploadScreenFileRequest:(NSDictionary *)parameters
                          data:(NSData *)data
                    sourceType:(SouceType)type
                    completion:(void (^)(id responseObject))success
                       failure:(void (^)(NSString *error))failure;
/**
 *  手机获取疑似内网的电视列表
 *
 *  @param parameters  入参
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)getDistrustTvsRequest:(NSDictionary *)parameters
                  completion:(void (^)(id responseObject))success
                     failure:(void (^)(NSString *error))failure;

/**
 *  用户频道群聊房间在线人数
 *
 *  @param parameters  入参
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)getRoomNumsRequest:(NSDictionary *)parameters
                  completion:(void (^)(id responseObject))success
                     failure:(void (^)(NSString *error))failure;

/**
 *  手机确认内网电视上报多屏接口
 *
 *  @param parameters  入参
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)confirmTvNet:(NSDictionary *)parameters
               completion:(void (^)(id responseObject))success
                  failure:(void (^)(NSString *error))failure;
@end
