//
//  FilterReport.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 筛选上报
 */
@interface FilterReport : EventModel

@property(nonatomic,copy) NSString *classify;
@property(nonatomic,copy) NSString *period;
@property(nonatomic,copy) NSString *region;
@property(nonatomic,copy) NSString *category;
@property(nonatomic,copy) NSString *sort;
@property(nonatomic,copy) NSString *sid;

@end
