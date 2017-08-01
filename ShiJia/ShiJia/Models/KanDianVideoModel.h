//
//  SJVideoModel.h
//  ShiJia
//
//  Created by yy on 16/4/7.
//  Copyright © 2016年 yy. All rights reserved.
//
/*
 {
    "actionUrl" : "",
    "catgId" : 2426,
    "catgName" : "百变小樱魔术卡",
    "clickRate" : "69.6万",
    "desc" : "木之本樱是一个友枝小学的四年级学生。有一天在家不小心开启了放置在爸爸书房中的一本古书。于是，小樱把放在书中最上面的一张牌拿出来观摩了一下，突然掀起一阵大风把书中的其他所有牌吹散到各地。这时一只看上去四不像的可爱生物“封印之兽”可鲁贝洛斯从书中钻了出来，它告诉小樱书中的牌叫“库洛牌”，现在散落各地已实......",
    "director" : "",
    "img" : "http://images.is.ysten.com:8080/images/ysten/images/lanmudianbo/SE/DHP/BBXYMSK.jpg",
    "lastUpdate" : 1423152000,
    "leading" : "",
    "newImg" : "",
    "orderType" : "series",
    "programOrder" : 0,
    "programSeriesType" : "动画|2004|日本|科幻|益智|搞笑",
    "programes" :     [],
    "tag" : "动画|2004|日本|科幻|益智|搞笑",
    "year" : 2004,
    "zone" : null,
 }
 */

#import <Foundation/Foundation.h>

@class KanDianVideoItemModel;

@interface KanDianVideoModel : NSObject

@property (nonatomic, assign) CGFloat        duration;

@property (nonatomic,   copy) NSString       *actionUrl;

@property (nonatomic, assign) NSInteger      catgId;

@property (nonatomic,   copy) NSString       *catgName;

@property (nonatomic,   copy) NSString       *clickRate;

@property (nonatomic,   copy) NSString       *desc;

@property (nonatomic,   copy) NSString       *director;

@property (nonatomic,   copy) NSString       *img;

@property (nonatomic, assign) NSInteger      *lastUpdate;

@property (nonatomic,   copy) NSString       *leading;

@property (nonatomic,   copy) NSString       *anotherImg;

@property (nonatomic,   copy) NSString       *orderType;

@property (nonatomic, assign) NSInteger      *programOrder;

@property (nonatomic,   copy) NSString       *programSeriesType;

@property (nonatomic, strong) NSArray<KanDianVideoItemModel *> *programes;

@property (nonatomic,   copy) NSString       *tag;

@property (nonatomic, assign) NSInteger      *year;

@property (nonatomic,   copy) NSString       *zone;


@property (nonatomic, assign) NSInteger       currentProgramIndex;

@end
