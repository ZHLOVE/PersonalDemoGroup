//
//  RemoteControl.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 遥控器
 */
@interface RemoteControl : EventModel

@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *rel_device_id;

@end
