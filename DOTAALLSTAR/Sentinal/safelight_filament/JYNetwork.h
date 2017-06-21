//
//  JYNetwork.h
//  SafeDark
//
//  Created by MBP on 16/6/18.
//  Copyright © 2016年 leqi. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface JYNetwork : NSObject

/**
 *  创建单例
 */
+ (instancetype)sharedNetwork;

/**
 *  初始设置
 *
 *  @param ak appKey
 *  @param sk specKey
 */
- (void)setAppKey:(NSString *)ak
        appSecret:(NSString *)as;

/**
 *  创建证件照任务
 *
 *  @param img          照片
 *  @param bc           背景颜色
 *  @param ec           背景颜色
 *  @param sk           照片规格
 *  @param successBlock 请求成功,带有任务ID
 *  @param failBlock    失败信息
 */
+ (void)createTask:(UIImage *)img
        BeginColor:(int)bc
          endColor:(int)ec
           SpecKey:(NSString *)sk
      successBlock:(void (^)(NSDictionary *dict))successBlock
         failBlock:(void (^)(NSString *errorMessage))failBlock;



/**
 *  获取任务信息
 *
 *  @param taskId       任务ID从创建证件照任务中获得
 *  @param successBlock 请求成功
 *  @param failBlock    失败信息
 */
+ (void)getTaskState:(NSString *)taskId
        successBlock:(void (^)(NSDictionary *dict))successBlock
           failBlock:(void (^)(NSString *errorMessage))failBlock;


/**
 *  创建订单
 *
 *  @param taskId       任务ID从创建证件照任务中获得
 *  @param successBlock 请求成功中有订单ID
 *  @param failBlock    失败信息
 */
+ (void)createOrder:(NSString *)taskId
       successBlock:(void (^)(NSDictionary *dict))successBlock
          failBlock:(void (^)(NSString *errorMessage))failBlock;

/**
 *  获取订单对应的证件照
 *
 *  @param orderNo      订单ID从创建订单中获得
 *  @param successBlock 请求成功
 *  @param failBlock    请求失败
 */
+ (void)getURLofOrder:(NSString *)orderNo
         successBlock:(void (^)(NSDictionary *dict))successBlock
            failBlock:(void (^)(NSString *errorMessage))failBlock;
@end
