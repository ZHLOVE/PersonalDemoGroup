//
//  TopicShare.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 专题分享
 */
@interface TopicShare : EventModel

@property(nonatomic,copy) NSString *share_id;
@property(nonatomic,assign) int result;
@property(nonatomic,assign) int type;
@property(nonatomic,copy) NSString *topic_id;
@property(nonatomic,assign) int way;
@property(nonatomic,assign) int source;


@end
