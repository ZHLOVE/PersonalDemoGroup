//
//  SearchReport.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 搜索上报
 */
@interface SearchReport : EventModel

@property(nonatomic,copy) NSString *key;
@property(nonatomic,copy) NSString *sid;
@property(nonatomic,assign) int input_model;

@end
