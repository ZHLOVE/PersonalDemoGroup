//
//  VideoSource.h
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  可播放的视频信息
 
 */
@interface VideoSource : NSObject

@property (nonatomic, strong) NSString* sourceID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* fileSize;
@property (nonatomic, strong) NSString* action;
@property (nonatomic, strong) NSString* actionURL;
@property (nonatomic, strong) NSString* info;
@property (nonatomic, strong) NSString* detailsid;
@property (nonatomic, strong) NSString* playerType;
@property (nonatomic, strong) NSString* contentType;
@property (nonatomic, strong) NSString* setNumber;
@property (nonatomic, strong) NSString* trialDura;
@property (nonatomic, strong) NSString* mediaType;
@property (nonatomic, strong) NSString* channelUuid;


// only 看点 远程投屏需要
@property (nonatomic, strong) NSString* catgId;
@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSString* assortId;
@property (nonatomic) BOOL isLive;

//only 观看纪录
@property (nonatomic, strong) NSString* templateId;
@property (nonatomic, strong) NSString* img;
@property (nonatomic, strong) NSString* catgName;
@property (nonatomic, strong) NSString* times;
@property (nonatomic, strong) NSString* lastProgramId;
@property (nonatomic, strong) NSString* endWatchTime;
@property (nonatomic, strong) NSString* watchTime;
@property (nonatomic, strong) NSMutableArray* programes;
@property (nonatomic, strong) NSArray* ppvList;

@property (nonatomic, assign) BOOL isEnable;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

//角标数组
@property (nonatomic, strong) NSArray* cornerArray;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
