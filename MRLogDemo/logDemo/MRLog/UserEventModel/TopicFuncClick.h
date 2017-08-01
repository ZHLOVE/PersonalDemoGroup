//
//  TopicFuncClick.h
//  logDemo
//
//  Created by MccRee on 2017/7/22.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 功能点击
 */
@interface TopicFuncClick : EventModel

@property(nonatomic,copy) NSString *widget_id;
@property(nonatomic,copy) NSString *topic_id;
@property(nonatomic,copy) NSString *url;


@end
