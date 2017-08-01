//
//  TPDanmakuData.h
//  HiTV
//
//  Created by yy on 15/8/26.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPDanmakuData : NSObject

/**
 *  文字弹幕内容
 */
@property (nonatomic, copy) NSString *message;

/**
 *  发送者名字
 */
@property (nonatomic, copy) NSString *senderName;

@property (nonatomic, assign) NSTimeInterval timePoint;

/**
 *  是否是当前登录用户发送的消息
 */
@property (nonatomic, assign) BOOL isSender;

/**
 *  是否为语音弹幕
 */
@property (nonatomic, assign) BOOL isVoiceMessage;

/**
 *  语音弹幕消息url
 */
@property (nonatomic, copy) NSString *recordUrlStr;

/**
 *  语音弹幕消息时长
 */
@property (nonatomic, copy) NSString *recordDuration;



@end
