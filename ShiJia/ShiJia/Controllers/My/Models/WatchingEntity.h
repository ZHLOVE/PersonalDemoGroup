//
//  WatchingEntity.h
//  HiTV
//
//  Created by 蒋海量 on 15/7/29.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchingEntity : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *programSeriesId;
@property (nonatomic, strong) NSString *programId;
@property (nonatomic, strong) NSString *programName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *second;
@property (nonatomic, strong) NSString *channelUuid;
@property (nonatomic, strong) NSString *catg;
@property (nonatomic, strong) NSString *deviceType;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
