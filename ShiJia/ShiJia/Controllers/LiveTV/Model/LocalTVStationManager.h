//
//  LocalTVStationManager.h
//  HiTV
//
//  created by iSwift on 3/15/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVStation.h"

/**
 *  最近观看频道管理
 */
@interface LocalTVStationManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) NSMutableArray* visitedStations;
@property (nonatomic) BOOL changed;

- (void)addVisitedStation:(TVStation*)station;
- (void)removeVisitedStation:(TVStation*)station;
- (void)removeAllTVStations;

@end
