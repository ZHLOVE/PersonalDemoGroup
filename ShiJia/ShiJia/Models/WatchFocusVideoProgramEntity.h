//
//  WatchFocusVideoProgramEntity.h
//  HiTV
//
//  Created by lanbo zhang on 8/1/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "JSONModel.h"

@protocol WatchFocusVideoProgramEntity <NSObject>


@end

/*
 "programId": "2073815",
 "programName": "荟萃节目-丧钟为谁而鸣3",
 "programUrl": "http://tv01index01.jx.ysten.com:8080/ysten-businessmobile/live/cctv-2/2073815.m3u8",
 "startTime": "1441094280",
 "endTime": "1441097100",
 "urlType": "play",
 "seriesNum": "",
 "smallimg": "http://images.is.ysten.com:8080/images/ysten/images/ysten/TV/cctv-2/cctv2.jpg",
 "uuid": "cctv-2"
*/

@interface WatchFocusVideoProgramEntity : JSONModel

@property (nonatomic, copy) NSString* programId;
@property (nonatomic, copy) NSString* programName;
@property (nonatomic, copy) NSString* programUrl;
@property (nonatomic, copy) NSString* programMobileUrl;
@property (nonatomic) long long startTime;
@property (nonatomic) long long endTime;
@property (nonatomic, copy) NSString* urlType;
@property (nonatomic, copy) NSString* seriesNum;
@property (nonatomic, copy) NSString* smallimg;
@property (nonatomic, copy) NSString<Optional>* uuid;
@property (nonatomic, copy) NSString* contentType;

@property (nonatomic, copy) NSString* name;

// for 看点远程投屏
@property (nonatomic, copy) NSString* assortId;
@property (nonatomic, copy) NSString* catgId;
@property (nonatomic) BOOL isLive;

@property (nonatomic) long long datePoint; // 断点

@property (nonatomic, copy) NSArray<WatchFocusVideoProgramEntity>* programes;
@property (nonatomic) NSInteger currentIndex;

@end
