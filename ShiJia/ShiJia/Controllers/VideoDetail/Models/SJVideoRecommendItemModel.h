//
//  SJVideoRecommendItemModel.h
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
#import <Foundation/Foundation.h>

@class SJVideoRecommendContentInfoModel;

@interface SJVideoRecommendItemModel : NSObject

@property (nonatomic, assign) NSInteger contentId;
@property (nonatomic, strong) SJVideoRecommendContentInfoModel *contentInfo;
@property (nonatomic, copy)   NSString *contentType;
@property (nonatomic, assign) NSInteger isLive;

@end
