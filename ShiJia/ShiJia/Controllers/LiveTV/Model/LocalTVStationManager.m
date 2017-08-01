//
//  LocalTVStationManager.m
//  HiTV
//
//  created by iSwift on 3/15/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "LocalTVStationManager.h"

@interface LocalTVStationManager()

@property (nonatomic, strong) NSMutableArray* visitedStations;

@end
@implementation LocalTVStationManager

+ (instancetype)sharedInstance{
    static LocalTVStationManager *sharedObject = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init{
    if (self = [super init]) {
        self.visitedStations = [[NSMutableArray alloc] init];
        [self p_load];
    }
    return self;
}

- (void)addVisitedStation:(TVStation*)station{
    [self removeVisitedStation:station];
    [self.visitedStations insertObject:station atIndex:0];
    [self p_save];
}
- (void)removeVisitedStation:(TVStation*)station{
    TVStation* existingStation = nil;
    BOOL found = NO;
    for (existingStation in self.visitedStations) {
        if ([station.uuid isEqualToString:existingStation.uuid]) {
            found = YES;
            break;
        }
    }
    if (found) {
        [self.visitedStations removeObject:existingStation];
        [self p_save];
    }}
- (void)removeAllTVStations{
    [self.visitedStations removeAllObjects];
    [self p_save];
}

- (void)p_load{
    NSString* folder = [HiTVConstants cacheFolder];
    NSString* playedStationPath = [folder stringByAppendingPathComponent:@"playedstation"];
    NSArray* playedStations = [NSKeyedUnarchiver unarchiveObjectWithFile:playedStationPath];
    if (playedStations.count > 0) {
        [self.visitedStations addObjectsFromArray:playedStations];
    }
}

- (void)p_save{
    NSString* folder = [HiTVConstants cacheFolder];
    NSString* playedStationPath = [folder stringByAppendingPathComponent:@"playedstation"];
    [NSKeyedArchiver archiveRootObject:self.visitedStations toFile:playedStationPath];
    
    self.changed = YES;
}

@end
