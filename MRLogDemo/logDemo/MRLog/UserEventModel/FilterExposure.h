//
//  FilterExposure.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 筛选曝光
 */
@interface FilterExposure : EventModel

@property(nonatomic,copy) NSString *from;
@property(nonatomic,copy) NSString *widget_id;


@end
