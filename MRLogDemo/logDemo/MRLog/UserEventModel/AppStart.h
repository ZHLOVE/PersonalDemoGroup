//
//  AppStart.h
//  logDemo
//  
//  Created by MccRee on 2017/7/21.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 app启动	
 */
@interface AppStart : EventModel

/**
 启动时间点
 */
@property(nonatomic,strong) NSString *time;

/**
 启动时长(ms)
 
 */
@property(nonatomic,assign) int duration;
@end
