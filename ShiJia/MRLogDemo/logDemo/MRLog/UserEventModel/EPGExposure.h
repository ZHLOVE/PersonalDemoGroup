//
//  EPGExposure.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 EPG曝光
 */
@interface EPGExposure : EventModel

@property(nonatomic,copy) NSString *from;
@property(nonatomic,copy) NSString *widget_id;
@property(nonatomic,copy) NSString *catg_id;
@property(nonatomic,copy) NSString *child_catg_id;


@end
