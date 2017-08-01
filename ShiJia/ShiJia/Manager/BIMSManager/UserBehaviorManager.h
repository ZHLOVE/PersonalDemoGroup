//
//  UserBehaviorManager.h
//  HiTV
//
//  Created by 蒋海量 on 16/1/8.
//  Copyright (c) 2016年 Lanbo Zhang. All rights reserved.
//
/**
 *  用户行为类
 */

#import <Foundation/Foundation.h>

@interface UserBehaviorManager : NSObject
+ (instancetype)sharedInstance;
/**
 *  上传观看状态
 */
-(void)uploadWatching:(NSDictionary *)dictionary;

/**
 *  查询观看纪录
 */
-(void)queryHistoryRecord:(NSDictionary *)dictionary;
/**
 *  添加观看纪录
 */
-(void)addHistoryRecord:(NSDictionary *)dictionary;
@end
