//
//  TVExposure.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 电视曝光
 */
@interface TVExposure : EventModel

@property(nonatomic,copy) NSString *from;
@property(nonatomic,copy) NSString *widget_id;

@end
