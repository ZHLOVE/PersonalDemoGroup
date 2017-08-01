//
//  HomeVideoClick.h
//  logDemo
//
//  Created by MccRee on 2017/7/21.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "EventModel.h"

/**
 首页视频点击	
 */
@interface HomeVideoClick : EventModel


@property(nonatomic,copy) NSString *widget_id;
@property(nonatomic,copy) NSString *ctype;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,copy) NSString *cid;
@property(nonatomic,copy) NSString *pid;

@end
