//
//  TVPrograms.h
//
//  created by iSwift on 3/8/14
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  单个节目单
 */
@interface TVProgram : NSObject <NSCoding>

@property (nonatomic, strong) NSString *desImg;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *programUrl;
@property (nonatomic, strong) NSString *urlType;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *programName;
@property (nonatomic, assign) double programId;
@property (nonatomic, strong) NSString *startTime;
//modify by jianghailiang 20150130
@property (nonatomic, strong) NSString *boxProgramUrl;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *mediaType;

@property (nonatomic, strong) NSString *hPosterAddr;
@property (nonatomic, strong) NSString *vPosterAddr;

@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *channelUuid;
@property (nonatomic, strong) NSString *cur;
@property (nonatomic, strong) NSString *programMobileUrl;
@property (nonatomic, strong) NSString *seriesNum;
@property (nonatomic, strong) NSString *directors;
@property (nonatomic, strong) NSString *actors;
@property (nonatomic, strong) NSString *ppvId;

@property (nonatomic, strong) NSArray* ppvList;

//角标数组
@property (nonatomic, strong) NSArray* cornerArray;

//modifyend
+ (TVProgram *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

- (NSString*)displayedStartTime;
- (NSString*)displayedEndTime;
- (NSString*)displayedFullStartTime;

- (NSTimeInterval)startTimeDouble;

- (BOOL)canReplay;
- (BOOL)canPlay;

@end
