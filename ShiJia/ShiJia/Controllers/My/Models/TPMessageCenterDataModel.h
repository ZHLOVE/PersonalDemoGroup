//
//  TPMessageModel.h
//  HiTV
//
//  Created by yy on 15/7/28.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//
/// 消息中心数据类型

#import <Foundation/Foundation.h>
#import "TPIMNodeModel.h"

@class TPIMNodeModel;

@interface TPMessageCenterDataModel : NSObject

/**
 *  消息id
 */
@property (nonatomic, copy)   NSString       *msgId;

/**
 *  消息from节点
 */
@property (nonatomic, strong) TPIMNodeModel  *from;

/**
 *  存放消息to节点的数组
 */
@property (nonatomic, strong) NSArray        *to;

/**
 *  消息类型
 */
@property (nonatomic, copy)   NSString       *type;

/**
 *  消息标题
 */
@property (nonatomic, copy)   NSString       *title;

/**
 *  消息发送时间
 */
@property (nonatomic, copy)   NSString       *time;

/**
 *  消息已读标志
 */
@property (nonatomic, assign)   BOOL        read;

/**
 *  用户头像
 */
@property (nonatomic, strong) UIImage *faceImg;

/**
 *  用户头像url
 */
@property (nonatomic, strong) NSString *faceImgUrl;

/**
 *  初始化方法
 *
 *  @param dictionary
 *
 *  @return 返回 TPMessageCenterDataModel
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
