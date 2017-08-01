//
//  WatchFocusVideoEntity.h
//  HiTV
//
//  Created by lanbo zhang on 8/1/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "WatchFocusVideoProgramEntity.h"

/*
 "catgId": 4536,
 "catgName": "绝爱之城之华胥引",
 "orderType": "series",
 "programOrder": "1",
 "img": "http://images.is.ysten.com:8080/images/ysten/images/lanmudianbo/DSJ/REMEN/JAZCZHXY2.jpg",
 "newImg": "",
 "lastUpdate": "1438566043",
 "actionUrl": "",
 "clickRate": "210.2万",
 "programes":[]
 */
@interface WatchFocusVideoEntity : JSONModel

//Common
@property (nonatomic, copy) NSString* catgId;
@property (nonatomic, copy) NSString* catgName;
@property (nonatomic, copy) NSString* img;
@property (nonatomic) double lastUpdate;
@property (nonatomic, copy) NSString* orderType;
@property (nonatomic, strong) NSArray* programes;
@property (nonatomic) int updateTime;

@property (nonatomic, copy) NSString* director;
@property (nonatomic, copy) NSString* leading;
@property (nonatomic, copy) NSString* year;
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, copy) NSString* tag;

//OpenNew
@property (nonatomic, copy) NSString<Optional>* channelName;
@property (nonatomic, strong) NSNumber<Optional>* isShowSmallLogo;
@property (nonatomic, copy) NSString<Optional>* smallLogo;

//Normal
@property (nonatomic, copy) NSString<Optional>* clickRate;
//@property (nonatomic, copy) NSString<Optional>* newImg;
@property (nonatomic, copy) NSString<Optional>* programOrder;

@property (nonatomic, readonly) NSString<Ignore>* lastUpdatedString;

@property (nonatomic, copy) NSString* actionUrl;

@property (nonatomic, copy) NSString* ppvId;
@end
