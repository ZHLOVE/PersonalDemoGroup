//
//  DianBoVideoModel.m
//  ShiJia
//
//  Created by yy on 16/5/6.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "DianBoVideoModel.h"
#import "DianBoVideoItemModel.h"

@implementation DianBoVideoModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
                 @"actor" : @"actor",
                 @"alias" : @"alias",
                 @"audiences" : @"audiences",
                 @"catgId" : @"catgId",
                 @"character" : @"character",
                 @"competition" : @"competition",
                 @"content" : @"content",
                 @"contentDate" : @"contentDate",
                 @"cpcode" : @"cpcode",
                 @"defaultdefinition" : @"defaultdefinition",
                 @"definition" : @"definition",
                 @"director" : @"director",
                 @"extInfo" : @"extInfo",
                 @"grade" : @"grade",
                 @"guests" : @"guests",
                 @"hours" : @"hours",
                 @"videoId" : @"id",
                 @"information" : @"information",
                 @"isNew" : @"isNew",
                 @"language" : @"language",
                 @"length" : @"length",
                 @"maskDescription" : @"maskDescription",
                 @"name" : @"name",
                 @"picurl" : @"picurl",
                 @"playCounts" : @"playCounts",
                 @"playSort" : @"playSort",
                 @"ppvId" : @"ppvId",
                 @"presenter" : @"presenter",
                 @"producer" : @"producer",
                 @"programClass" : @"programClass",
                 @"programCount" : @"programCount",
                 @"programNo" : @"programNo",
                 @"publisher" : @"publisher",
                 @"rcmLevel" : @"rcmLevel",
                 @"relationlist" : @"relationlist",
                 @"releaseDate" : @"releaseDate",
                 @"sources" : @"sources",
                 @"specialInfo" : @"specialInfo",
                 @"specialLssueid" : @"specialLssueid",
                 @"style" : @"style",
                 @"subCaption" : @"subCaption",
                 @"subject" : @"subject",
                 @"tag" : @"tag",
                 @"type" : @"type",
                 @"typeCode" : @"typeCode",
                 @"zone" : @"zone"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"sources" : [DianBoVideoItemModel class]};
}






@end
