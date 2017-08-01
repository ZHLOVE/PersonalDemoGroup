//
//  PlayQuality.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 播放质量
 */
@interface PlayQuality : EventModel

@property(nonatomic,copy) NSString *ID; //文档中是id,插数据库时做小写处理
@property(nonatomic,copy) NSString *ctype;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *pid;
@property(nonatomic,copy) NSString *playbill_id;
@property(nonatomic,copy) NSString *playbill_start_time;
@property(nonatomic,copy) NSString *playbill_end_time;
@property(nonatomic,copy) NSString *set_no;
@property(nonatomic,assign) int total_number;
@property(nonatomic,copy) NSString *catg_id;
@property(nonatomic,copy) NSString *child_catg_id;
@property(nonatomic,copy) NSString *topic_id;
@property(nonatomic,copy) NSString *start_time;
@property(nonatomic,copy) NSString *end_time;
@property(nonatomic,assign) int start_point;
@property(nonatomic,assign) int end_point;
@property(nonatomic,assign) int seek_count;
@property(nonatomic,assign) int seek_total_time_cost;
@property(nonatomic,assign) int pause_count;
@property(nonatomic,assign) int pause_total_time_cost;
@property(nonatomic,assign) int buffer_count;
@property(nonatomic,assign) int buffer_total_time_cost;
@property(nonatomic,assign) int play_total_time_cost;
@property(nonatomic,assign) int total_time_cost;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,assign) int source;
@property(nonatomic,copy) NSString *share_id;
@property(nonatomic,assign) int error_type;
@property(nonatomic,copy) NSString *error_info;




@end
