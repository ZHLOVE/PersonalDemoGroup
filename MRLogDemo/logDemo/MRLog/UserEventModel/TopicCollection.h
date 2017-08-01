//
//  TopicCollection.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 专题收藏	
 */
@interface TopicCollection : EventModel

@property(nonatomic,assign) int result;
@property(nonatomic,assign) int type;
@property(nonatomic,copy) NSString *topic_id;
@property(nonatomic,copy) NSString *source;

@end
