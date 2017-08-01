//
//  TPRequestManager.h
//  HiTV
//
//  Created by yy on 15/7/28.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPIMMessageModel;

@interface TPMessageRequest : NSObject

#pragma mark - message
/**
 *  通过HTTP发送消息
 *
 *  @param message 消息类型
 *  @param handler 处理回调
 */
+ (void)sendMessage:(TPIMMessageModel *)message completion:(void(^)(id responseObject,NSError *error))handler;

/**
 *  发送语音文件
 *
 *  @param data    语音data
 *  @param handler 处理回调
 */
+ (void)uploadRecordFile:(NSData *)data completion:(void(^)(NSString *responseObject,NSError *error))handler;

/**
 *  发送视频文件
 *
 *  @param data    视频data
 *  @param handler 处理回调
 */
+ (void)uploadVideoFile:(NSData *)data completion:(void (^)(NSString *, NSError *))handler;

/**
 *  上传设备token号
 *
 *  @param handler 处理回调
 */
+ (void)uploadDeviceTokenWithCompletion:(void (^)(NSString *, NSError *))handler;


/**
 *  上传设备token号
 *
 *  @param handler 处理回调
 */
+ (void)removeDeviceTokenWithCompletion:(void (^)(NSString *, NSError *))handler;

/**
 *  统计消息打开数量
 *
 *  @param msgId 到达消息的id
 *  @param handler 处理回调
 */
+ (void)reportMessageArrivalCountWithMsgId:(NSString *)msgId handler:(void (^)(NSString *, NSError *))handler;

@end
