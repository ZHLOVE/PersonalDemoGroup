//
//  AppQR.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"
/**
 app扫码
 */
@interface AppQR : EventModel

@property(nonatomic,assign) int result;
@property(nonatomic,assign) int type;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,assign) int way;
@property(nonatomic,copy) NSString *rel_device_id;
@property(nonatomic,copy) NSString *friend_phone;

@end
