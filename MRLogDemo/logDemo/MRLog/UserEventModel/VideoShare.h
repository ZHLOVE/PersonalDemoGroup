//
//  VideoShare.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 视频分享
 */
@interface VideoShare : EventModel

@property(nonatomic,copy) NSString *share_id;
@property(nonatomic,assign) int result;
@property(nonatomic,assign) int type;
@property(nonatomic,copy) NSString *ctype;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *pid;
@property(nonatomic,assign) int way;
@property(nonatomic,assign) int time;
@property(nonatomic,copy) NSString *point;
@property(nonatomic,assign) int source;

@end
