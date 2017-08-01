//
//  DianBoVideoItemModel.m
//  ShiJia
//
//  Created by yy on 16/5/6.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "DianBoVideoItemModel.h"

@implementation DianBoVideoItemModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
                 @"action" : @"action",
                 @"actionURL" : @"actionURL",
                 @"cId" : @"cId",
                 @"definition" : @"definition",
                 @"drmFlag" : @"drmFlag",
                 @"drmType" : @"drmType",
                 @"fileSize" : @"fileSize",
                 @"videoId" : @"id",
                 @"is3D" : @"is3D",
                 @"mediaId" : @"mediaId",
                 @"name" : @"name",
                 @"poster" : @"poster",
                 @"programId" : @"programId",
                 @"setNumber" : @"setNumber",
                 @"specialInfo" : @"specialInfo",
                 @"trialDura" : @"trialDura",
                 @"type3D" : @"type3D"
            };
}

@end
