//
//  SJProgramModel.h
//  ShiJia
//
//  Created by yy on 16/4/13.
//  Copyright © 2016年 yy. All rights reserved.
//
/*
 {
 "endTime" = 1434944970;
 "programId" = 87063;
 "programName" = "名侦探柯南（精选）(8)";
 "programUrl" = "http://looktvmedia.jx.ysten.com/lookback/media/87063/87063.m3u8";
 "seriesNum" = 8;
 "startTime" = 1434943503;
 "urlType" = "replay";
 }
 */

#import <Foundation/Foundation.h>

@interface KanDianVideoItemModel : NSObject

@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger programId;
@property (nonatomic,   copy) NSString  *programName;
@property (nonatomic,   copy) NSString  *programUrl;
@property (nonatomic, assign) NSInteger seriesNum;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic,   copy) NSString  *urlType;

@end
