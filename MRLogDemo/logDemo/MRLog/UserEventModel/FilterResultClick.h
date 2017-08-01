//
//  FilterResultClick.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 筛选结果点击
 */
@interface FilterResultClick : EventModel

@property(nonatomic,copy) NSString *widget_id;
@property(nonatomic,copy) NSString *classify;
@property(nonatomic,copy) NSString *period;
@property(nonatomic,copy) NSString *region;
@property(nonatomic,copy) NSString *category;
@property(nonatomic,copy) NSString *sort;
@property(nonatomic,copy) NSString *ctype;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *pid;
@property(nonatomic,copy) NSString *sid;

@end
