//
//  SJProgramModel.m
//  ShiJia
//
//  Created by yy on 16/4/13.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "KanDianVideoItemModel.h"

@implementation KanDianVideoItemModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
                 @"endTime" : @"endTime",
                 @"programId" : @"programId",
                 @"programName" : @"programName",
                 @"programUrl" : @"programUrl",
                 @"seriesNum" : @"seriesNum",
                 @"startTime" : @"startTime",
                 @"urlType" : @"urlType"
             };
}

@end
