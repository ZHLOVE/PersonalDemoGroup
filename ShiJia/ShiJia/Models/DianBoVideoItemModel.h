//
//  DianBoVideoItemModel.h
//  ShiJia
//
//  Created by yy on 16/5/6.
//  Copyright © 2016年 Ysten. All rights reserved.
//
/*
 {
     "action" : "OpenMedia",
     "actionURL" : "yst://BE6BB43747C4FF5564DD94183F4FC79853C028CC307527C1B01DE01B70B8FD3928A2CE07582CF9CF17A8CD607EF3A5CFAA1C946A80FC51D216A9E073D51115AB1855B2C9E49082A72D50ADC8A7E1204E",
     "cId" : "",
     "definition"  : "SD",
     "drmFlag"  : false,
     "drmType"  : "",
     "fileSize"  : 38837416,
     "id" : 1625952,
     "is3D" : false,
     "mediaId" : 1625952,
     "name" : "[SD]101_猫和老鼠",
     "poster" : "",
     "programId" : 1625952,
     "setNumber" : 101,
     "specialInfo" : "",
     "trialDura" : "",
     "type3D" : 0,
 }
 */
#import <Foundation/Foundation.h>

@interface DianBoVideoItemModel : NSObject

@property (nonatomic,   copy) NSString *action;
@property (nonatomic,   copy) NSString *actionURL;
@property (nonatomic,   copy) NSString *cId;
@property (nonatomic,   copy) NSString *definition;
@property (nonatomic, assign) BOOL      drmFlag;
@property (nonatomic,   copy) NSString *drmType;
@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, assign) BOOL      is3D;
@property (nonatomic, assign) NSInteger mediaId;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) NSString *poster;
@property (nonatomic, assign) NSInteger programId;
@property (nonatomic, assign) NSInteger setNumber;
@property (nonatomic,   copy) NSString *specialInfo;
@property (nonatomic,   copy) NSString *trialDura;
@property (nonatomic, assign) NSInteger type3D;

@end
