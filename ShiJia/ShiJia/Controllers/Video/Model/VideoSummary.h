//
//  VideoSummary.h
//  HiTV
//
//  created by iSwift on 3/10/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseVideo.h"

/**
 *  视频信息
 */
@interface VideoSummary : BaseVideo

@property (nonatomic, strong) NSString* bitrate;
@property (nonatomic, strong) NSString* catgItemId;
@property (nonatomic, strong) NSString* cumulAttentions;
@property (nonatomic, strong) NSString* descript;
@property (nonatomic, strong) NSString* enName;
@property (nonatomic, strong) NSString* fans;
@property (nonatomic, strong) NSString* grade;
@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) NSString* imgUrl_m;
@property (nonatomic, strong) NSString* imgUrl_s;
//@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* nowCount;
@property (nonatomic, strong) NSString* playCounts;
@property (nonatomic, strong) NSString* ppvId;
@property (nonatomic, strong) NSString* rcmLevel;
@property (nonatomic, strong) NSString* subCaption;
@property (nonatomic, strong) NSString* totalCount;
@property (nonatomic, strong) NSString* updateComment;
@property (nonatomic, strong) NSString* updateDate;
@property (nonatomic, strong) NSString* contentType;
@property (nonatomic, strong) NSString* channelLogo;

//角标数组
@property (nonatomic, strong) NSArray* cornerArray;

//轮播添加
//@property (nonatomic, strong) NSString* imageUrl;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
