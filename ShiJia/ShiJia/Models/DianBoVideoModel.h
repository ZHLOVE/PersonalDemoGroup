//
//  DianBoVideoModel.h
//  ShiJia
//
//  Created by yy on 16/5/6.
//    copyright © 2016年 Ysten. All rights reserved.
//
/*
 {
     "actor" : "汤姆|杰瑞",
     "alias" : "",
     "audiences" : "",
     "catgId" : "",
     "character" : "",
     "competition" : "",
     "content" : "",
     "contentDate" : "",
     "cpcode" : "CMS",
     "defaultdefinition" : "",
     "definition" : "SD",
     "director" : "威廉·汉纳|约瑟夫·巴伯拉",
     "extInfo" : "",
     "grade" : "7.6",
     "guests" : "",
     "hours" : "",
     "id" : 785037,
     "information" : "灰色的大猫，眼里总是闪着机会主义的光芒，弓着腰在一旁等待机会出击。 棕色的小老鼠，总是用挑逗的眼神看你，并且常常在不经意期间玩弄这只大灰猫。 他们的名字就叫做Tom和Jerry。",
     "isNew" : false,
     "language" : "其他",
     "length" : 0,
     "maskDescription" : "",
     "name" : "猫和老鼠合集三",
     "picurl" : "http://images.is.ysten.com:8080/poster/2014-04-24/52b44d1f5e854758939d4c7d0d59e075.jpg",
     "playCounts" : 87303169,
     "playSort" : "",
     "ppvId" : "",
     "presenter" : "",
     "producer" : "",
     "programClass" : "搞笑|经典",
     "programCount" : 40,
     "programNo" : "",
     "publisher" : "",
     "rcmLevel" : "",
     "relationlist" : "http://epg.is.ysten.com:8080/yst-epg/web/program!getRelationProgramseries.action?directors:%E5%A8%81%E5%BB%89%C2%B7%E6%B1%89%E7%BA%B3%7C%E7%BA%A6%E7%91%9F%E5%A4%AB%C2%B7%E5%B7%B4%E4%BC%AF%E6%8B%89&actors:%E6%B1%A4%E5%A7%86%7C%E6%9D%B0%E7%91%9E&programSeriesId:785037&templateId:4",
     "releaseDate" : 1964,
     "sources" :[]
     "specialInfo" : "",
     "specialLssueid" : "",
     "style" : "",
     "subCaption" : "",
     "subject" : "",
     "tag" : "少儿|欧美|动画",
     "type" : "动漫",
     "typeCode" : 14,
     "zone" : "美国",
 }
 */

#import <Foundation/Foundation.h>

@interface DianBoVideoModel : NSObject

@property (nonatomic,   copy) NSString *actor;
@property (nonatomic,   copy) NSString *alias;
@property (nonatomic,   copy) NSString *audiences;
@property (nonatomic,   copy) NSString *catgId;
@property (nonatomic,   copy) NSString *character;
@property (nonatomic,   copy) NSString *competition;;
@property (nonatomic,   copy) NSString *content;
@property (nonatomic,   copy) NSString *contentDate;
@property (nonatomic,   copy) NSString *cpcode;
@property (nonatomic,   copy) NSString *defaultdefinition;;
@property (nonatomic,   copy) NSString *definition;
@property (nonatomic,   copy) NSString *director;
@property (nonatomic,   copy) NSString *extInfo;
@property (nonatomic,   copy) NSString *grade;
@property (nonatomic,   copy) NSString *guests;
@property (nonatomic,   copy) NSString *hours;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic,   copy) NSString *information;
@property (nonatomic, assign) BOOL      isNew;
@property (nonatomic,   copy) NSString *language;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic,   copy) NSString *maskDescription;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) NSString *picurl;
@property (nonatomic, assign) NSInteger playCounts;
@property (nonatomic,   copy) NSString *playSort;
@property (nonatomic,   copy) NSString *ppvId;
@property (nonatomic,   copy) NSString *presenter;
@property (nonatomic,   copy) NSString *producer;
@property (nonatomic,   copy) NSString *programClass;
@property (nonatomic, assign) NSInteger programCount;
@property (nonatomic,   copy) NSString *programNo;
@property (nonatomic,   copy) NSString *publisher;
@property (nonatomic,   copy) NSString *rcmLevel;
@property (nonatomic,   copy) NSString *relationlist;
@property (nonatomic, assign) NSInteger releaseDate;
@property (nonatomic, strong) NSArray *sources;
@property (nonatomic,   copy) NSString *specialInfo;
@property (nonatomic,   copy) NSString *specialLssueid;
@property (nonatomic,   copy) NSString *style;
@property (nonatomic,   copy) NSString *subCaption;
@property (nonatomic,   copy) NSString *subject;
@property (nonatomic,   copy) NSString *tag;
@property (nonatomic,   copy) NSString *type;
@property (nonatomic, assign) NSInteger typeCode;
@property (nonatomic,   copy) NSString *zone;

@end
