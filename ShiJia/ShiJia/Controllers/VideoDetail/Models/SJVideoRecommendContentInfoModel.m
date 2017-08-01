//
//  SJVideoRecommendContentInfoModel.m
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
#import "SJVideoRecommendContentInfoModel.h"

@implementation SJVideoRecommendContentInfoModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"channelLogo" : @"channelLogo",
             @"channelName" : @"channelName",
             @"channelUuid" : @"channelUuid",
             @"endTime" : @"endTime",
             @"playPercent" : @"playPercent",
             @"verticalPosterAddr" : @"verticalPosterAddr"
             
             };
}

@end
