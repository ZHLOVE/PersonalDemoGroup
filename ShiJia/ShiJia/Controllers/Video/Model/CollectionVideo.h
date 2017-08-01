//
//  CollectionVideo.h
//  HiTV
//
//  Created by 蒋海量 on 15/5/13.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecentVideo.h"
/**
 *  收藏视频实体
 */
@interface CollectionVideo : NSObject<NSCoding>

@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) RecentVideo* videoEntity;

@property (nonatomic, strong) NSString* videoID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* action;
@property (nonatomic, strong) NSString* director;
@property (nonatomic, strong) NSString* actor;
@property (nonatomic, strong) NSString* actionUrl;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* length;
@property (nonatomic, strong) NSString* objecttype;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (instancetype)initWatchtvWithDict:(NSDictionary*)dict;

@end
