//
//  ChooseCategoryModel.h
//  ShiJia
//
//  Created by 峰 on 2016/12/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Condition,Sort;
@interface ChooseCategoryModel : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSArray<Condition *> *condition;
@property (nonatomic, strong) NSArray<Sort *> *sort;
@property (nonatomic) BOOL doselected;

@end
@interface Condition : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
//@property (nonatomic) BOOL doselected;

@end

@interface Sort : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *value;

@property (nonatomic) BOOL doselected;

@end

//@interface requsetModel : NSObject
//
//@property (nonatomic, strong) NSString *unionType;//1
//@property (nonatomic, strong) NSString *keyword;
//@property (nonatomic, strong) NSString *start;
//@property (nonatomic, strong) NSString *limt;
//@property (nonatomic, strong) NSString *searchType;
//@property (nonatomic, strong) NSString *templateId;
//@property (nonatomic, strong) NSString *key1;
//@property (nonatomic, strong) NSString *value1;
//@property (nonatomic, strong) NSString *key2;
//@property (nonatomic, strong) NSString *value2;
//@property (nonatomic, strong) NSString *key3;
//@property (nonatomic, strong) NSString *value3;
//@property (nonatomic, strong) NSString *key4;
//@property (nonatomic, strong) NSString *value4;
//@property (nonatomic, strong) NSString *key5;
//@property (nonatomic, strong) NSString *value5;
//@property (nonatomic, strong) NSString *key6;
//@property (nonatomic, strong) NSString *value6;
//@property (nonatomic, strong) NSString *STBext;
//@property (nonatomic, strong) NSString *psType;
//
//@end

@class programSeries;
@interface searchDataModel : NSObject
@property (nonatomic, strong) NSString *start;//表示当前请求文档的起始位置
@property (nonatomic, strong) NSString *count;//节目集总个数
@property (nonatomic, strong) NSArray<programSeries*> *programSeries;
@property (nonatomic, strong) NSString *limit;//表示请求文档的数量
@end


//@interface corner : NSObject
//@property (nonatomic, strong) NSString *cornerImg;
//@property (nonatomic, strong) NSString *position;
//@end


@class CornerEntity;
@interface programSeries : NSObject


@property (nonatomic, strong) NSString   *id;//节目集id
@property (nonatomic, strong) NSString   *grade;//评分
@property (nonatomic, strong) NSString   *name;//节目集名称
@property (nonatomic, assign) NSInteger   isTidbits;
@property (nonatomic, assign) NSInteger   playCounts;//累计播放次数
@property (nonatomic, strong) NSString   *imgUrl;//节目集海报地址（合适）
@property (nonatomic, strong) NSString   *searchType;//搜索类型,取值：“video”点播 “live”回看 “music”音乐 “app”应用
@property (nonatomic, strong) NSString   *desc;//描述(35个字)
@property (nonatomic, strong) NSString   *bitrate;//码率
@property (nonatomic, strong) NSString   *cpCode;
@property (nonatomic, assign) NSInteger   titleLength;
@property (nonatomic, strong) NSString   *ppvId;//价格
@property (nonatomic, strong) NSString   *verticalPosterAddr;//看点的竖版海报地址，没值时是：""
@property (nonatomic, strong) NSArray   <CornerEntity *>*corner;
//@property (nonatomic, strong) NSArray    <cornerModel *>*cornerArray;

@end


