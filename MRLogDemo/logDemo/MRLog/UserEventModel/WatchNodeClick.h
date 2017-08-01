//
//  JMClick.h
//  logDemo
//
//  Created by MccRee on 2017/7/21.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 节目集点击	
 */
@interface WatchNodeClick : EventModel

@property(nonatomic,copy) NSString *widget_id;
@property(nonatomic,copy) NSString *recid;
@property(nonatomic,copy) NSString *ctype;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *pid;

@end
