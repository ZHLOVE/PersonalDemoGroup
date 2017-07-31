//
//  EventModel.h
//  playFun
//
//  Created by MccRee on 2017/7/26.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 事件属性
 */
@interface EventModel : NSObject

@property(nonatomic,copy) NSString *from;       //	跳转起始控件
@property(nonatomic,copy) NSString *to;         //	跳转目标控件
@property(nonatomic,copy) NSString *widget_id;  //	当前页面的控件ID
@property(nonatomic,copy) NSString *ctype;      //	内容类型
@property(nonatomic,copy) NSString *uuid;       //	频道ID
@property(nonatomic,copy) NSString *cid;        //	节目集ID
@property(nonatomic,copy) NSString *pid;        //	节目ID
@property(nonatomic,copy) NSString *topic_id;   //	专题ID
@property(nonatomic,copy) NSString *catg_id;    //	栏目ID
@property(nonatomic,copy) NSString *ad_id;      //	广告ID
@property(nonatomic,copy) NSString *key;        //	搜索关键词
@property(nonatomic,copy) NSString *sid;        //	搜索的唯一标识
@property(nonatomic,copy) NSString *recid;      //	看单推荐结果唯一标识

@end
