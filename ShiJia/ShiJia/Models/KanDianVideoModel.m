//
//  SJVideoModel.m
//  ShiJia
//
//  Created by yy on 16/4/7.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "KanDianVideoModel.h"
#import "KanDianVideoItemModel.h"

@implementation KanDianVideoModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
                @"actionUrl" : @"actionUrl",
                @"catgId" : @"catgId",
                @"catgName" : @"catgName",
                @"clickRate" : @"clickRate",
                @"desc" : @"desc",
                @"director" : @"director",
                @"img" : @"img",
                @"lastUpdate" : @"lastUpdate",
                @"leading" : @"leading",
                @"anotherImg" : @"newImg",
                @"orderType" : @"orderType",
                @"programOrder" : @"programOrder",
                @"programSeriesType" : @"programSeriesType",
                @"programes" : @"programes",
                @"tag" : @"tag",
                @"year" : @"year",
                @"zone" : @"zone"
            };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"programes" : [KanDianVideoItemModel class]};
}

@end
