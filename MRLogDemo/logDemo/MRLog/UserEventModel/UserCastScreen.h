//
//  UserCastScreen.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 用户投屏
 */
@interface UserCastScreen : EventModel

@property(nonatomic,assign) int result;
@property(nonatomic,copy) NSString *ctype;
@property(nonatomic,copy) NSString *rel_device_id;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *pid;

@end
