//
//  WatchNodeDelete.h
//  logDemo
//
//  Created by MccRee on 2017/7/21.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 看单删除
 */
@interface WatchNodeDelete : EventModel

@property(nonatomic,copy) NSString *widget_id;
@property(nonatomic,copy) NSString *recid;
@property(nonatomic,copy) NSString *cid;

@end
