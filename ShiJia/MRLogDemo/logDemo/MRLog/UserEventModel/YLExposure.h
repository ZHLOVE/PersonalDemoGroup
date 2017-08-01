//
//  YLExposure.h
//  logDemo
//
//  Created by MccRee on 2017/7/21.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 有料曝光
 */
@interface YLExposure : EventModel

@property(nonatomic,copy) NSString *from;
@property(nonatomic,copy) NSString *widget_id;

@end
