//
//  SJVideoRecommendModel.m
//  ShiJia
//
//  Created by yy on 16/6/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
/*
 {
 content = ();
 posterAddr = "http://images.is.ysten.com:8080/images/ysten/images/lanmudianbo/DSJ/REBO/HXS.jpg";
 reason = "\U6700\U8fd1\U6b63\U5728\U70ed\U64ad";
 resultId = 0;
 resultType = 0;
 verticalPosterAddr = "http://images.is.ysten.com:8080/images/ysten/images/lanmudianbo/DSJ/REBO/HXS.jpg";
 }
 */
#import "SJVideoRecommendModel.h"
#import "SJVideoRecommendItemModel.h"

@implementation SJVideoRecommendModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"content" : @"content",
             @"posterAddr" : @"posterAddr",
             @"reason" : @"reason",
             @"resultId" : @"resultId",
             @"resultType" : @"resultType",
             @"verticalPosterAddr" : @"verticalPosterAddr"
             
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" : [SJVideoRecommendItemModel class]};
}

@end
