//
//  SJVideoRecommendContentInfoModel.h
//  ShiJia
//
//  Created by yy on 16/6/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
/*
 {
 channelLogo = "http://images.is.ysten.com:8080/images/ysten/images/ysten/TV/zhejiangstv/zjwstb.png";
 channelName = "\U6d59\U6c5f\U536b\U89c6";
 channelUuid = zhejiangstv;
 endTime = 1466169000;
 playPercent = "";
 programSeriesName = "\U597d\U5148\U751f";
 programSeriesType = "\U7535\U89c6\U5267";
 startTime = 1466163240;
 }
 */
#import <Foundation/Foundation.h>

@interface SJVideoRecommendContentInfoModel : NSObject

@property (nonatomic, copy)   NSString *channelLogo;
@property (nonatomic, copy)   NSString *channelName;
@property (nonatomic, copy)   NSString *channelUuid;
@property (nonatomic, assign) double    endTime;
@property (nonatomic, copy)   NSString *playPercent;
@property (nonatomic, copy)   NSString *categoryId;
@property (nonatomic, copy)   NSString *programSeriesId;
@property (nonatomic, copy)   NSString *programSeriesName;
@property (nonatomic, copy)   NSString *programSeriesType;
@property (nonatomic, copy)   NSString *programSeriesDesc;
@property (nonatomic, assign) double    startTime;
@property (nonatomic, copy)   NSString *setNumber;
@property (nonatomic, copy)   NSString *url;

@end
