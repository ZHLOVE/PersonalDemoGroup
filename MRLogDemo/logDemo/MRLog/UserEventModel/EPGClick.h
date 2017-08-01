//
//  EPGClick.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 视频点击
 */
@interface EPGClick : EventModel

@property(nonatomic,copy) NSString *widget_id;
@property(nonatomic,copy) NSString *catg_id;
@property(nonatomic,copy) NSString *child_catg_id;
@property(nonatomic,copy) NSString *ctype;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *pid;


@end
