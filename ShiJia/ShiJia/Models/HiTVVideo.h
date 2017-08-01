//
//  HiTVVideo.h
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoSource.h"
#import "BaseVideo.h"
#import "WatchFocusEntity.h"
#import "WatchFocusVideoEntity.h"

/**
 *  视频详细信息
 */
@interface HiTVVideo : BaseVideo<NSCoding>

//@property (nonatomic, strong) NSString* actor;
@property (nonatomic, strong) NSString* alias;
@property (nonatomic, strong) NSString* audiences;
@property (nonatomic, strong) NSString* catgId;
@property (nonatomic, strong) NSString* character;
@property (nonatomic, strong) NSString* competition;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* contentDate;
@property (nonatomic, strong) NSString* cpcode;
@property (nonatomic, strong) NSString* defaultDefinition;
@property (nonatomic, strong) NSString* definition;
//@property (nonatomic, strong) NSString* director;
@property (nonatomic, strong) NSString* extInfo;
@property (nonatomic, strong) NSString* guests;
@property (nonatomic, strong) NSString* hours;
@property (nonatomic, strong) NSString* information;
@property (nonatomic, strong) NSString* isNew;
@property (nonatomic, strong) NSString* language;
//@property (nonatomic, strong) NSString* length;
@property (nonatomic, strong) NSString* maskDescription;
//@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* picurl;
@property (nonatomic, strong) NSString* playCounts;
@property (nonatomic, strong) NSString* playSort;
@property (nonatomic, strong) NSString* ppvId;
@property (nonatomic, strong) NSString* presenter;
@property (nonatomic, strong) NSString* producer;
@property (nonatomic, strong) NSString* programClass;
@property (nonatomic, strong) NSString* programCount;
@property (nonatomic, strong) NSString* programNo;
@property (nonatomic, strong) NSString* publisher;
@property (nonatomic, strong) NSString* rcmLevel;
@property (nonatomic, strong) NSString* relationlist;
@property (nonatomic, strong) NSString* releaseDate;
@property (nonatomic, strong) NSString* specialInfo;
@property (nonatomic, strong) NSString* specialLssueId;
@property (nonatomic, strong) NSString* style;
@property (nonatomic, strong) NSString* subCaption;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, strong) NSString* tag;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* typeCode;
@property (nonatomic, strong) NSString* zone;
@property (nonatomic, strong) NSString* contentType;
@property (nonatomic, strong) NSString* ppvList;

/*
 看点视频
 */
@property (nonatomic, strong) WatchFocusEntity* watchFocusEntity;
@property (nonatomic, strong) WatchFocusVideoEntity* watchFocusVideoEntity;


@property (nonatomic, strong) NSArray* relationVideolist;
@property (nonatomic, strong) __block NSArray* sources;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end
