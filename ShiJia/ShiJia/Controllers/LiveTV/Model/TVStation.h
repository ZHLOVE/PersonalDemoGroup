//
//  TVStation.h
//
//  created by iSwift on 3/8/14
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  单个频道信息
 */
@interface TVStation : NSObject <NSCoding>

@property (nonatomic, assign) double usable;
@property (nonatomic, strong) NSString *onplay;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *noProperty;
@property (nonatomic, strong) NSString *urlid;
@property (nonatomic, strong) NSString *logo;

@property (nonatomic, strong) NSDate* onPlayGotDate;

+ (TVStation *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
