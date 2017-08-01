//
//  TVStationDetail.h
//
//  created by iSwift on 3/8/14
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVProgram.h"

/**
 *  单个频道某天信息
 */
@interface TVStationDetail : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *programs;
@property (nonatomic, strong) NSString *playDate;

@property (nonatomic, readonly) TVProgram* onlineProgram;

- (NSString*)displayedDate;
- (NSString*)displayedWeekDay;
- (NSTimeInterval)playDateDouble;


+ (TVStationDetail *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
