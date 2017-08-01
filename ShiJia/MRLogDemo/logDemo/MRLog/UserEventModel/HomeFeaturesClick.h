//
//  HomeFeaturesClick.h
//  logDemo
//
//  Created by MccRee on 2017/7/21.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"


/**
 首页功能点击
 */
@interface HomeFeaturesClick : EventModel

@property(nonatomic,copy) NSString *widget_id;
@property(nonatomic,copy) NSString *url;

@end
