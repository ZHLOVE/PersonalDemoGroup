//
//  SJVideoRecommendItemModel.m
//  ShiJia
//
//  Created by yy on 16/6/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
/*
 {
 contentId = 0;
 contentInfo = {};
 contentType = live;
 isLive = 0;
 }
 */

#import "SJVideoRecommendItemModel.h"

@implementation SJVideoRecommendItemModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"contentId" : @"contentId",
             @"contentInfo" : @"contentInfo",
             @"contentType" : @"contentType",
             @"isLive" : @"isLive"
             
             };
}

@end
