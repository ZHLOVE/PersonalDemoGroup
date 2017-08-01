//
//  RecentVideo.h
//  HiTV
//
//  Created by 蒋海量 on 15/5/15.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  观看纪录视频实体
 */

@interface RecentVideo : NSObject//<NSCoding>

@property (nonatomic, strong) NSString* actors;
@property (nonatomic, strong) NSString* assortId;
@property (nonatomic, strong) NSString* bannerImg;
@property (nonatomic, strong) NSString* businessType;
@property (nonatomic, strong) NSString* dateline;
@property (nonatomic, strong) NSString* deviceGroupId;
@property (nonatomic, strong) NSString* deviceType;
@property (nonatomic, strong) NSString* directors;
@property (nonatomic, strong) NSString* endTime;
@property (nonatomic, strong) NSString* endWatchTime;
@property (nonatomic, strong) NSString* expired;
@property (nonatomic, strong) NSString* lastProgramId;
@property (nonatomic, strong) NSString* lastProgramName;
@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* objectName;
@property (nonatomic, strong) NSString* playType;
@property (nonatomic, strong) NSString* seconds;
@property (nonatomic, strong) NSString* seriesNumber;
@property (nonatomic, strong) NSString* startTime;
@property (nonatomic, strong) NSString* startWatchTime;
@property (nonatomic, strong) NSString* templateId;
@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* vendor;
@property (nonatomic, strong) NSString* verticalImg;
@property (nonatomic, strong) NSString* duration;


- (instancetype)initWithDict:(NSDictionary*)dict;

@end
