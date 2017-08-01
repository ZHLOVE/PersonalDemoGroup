//
//  RecentVideoManager.m
//  HiTV
//
//  created by iSwift on 3/11/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "LocalVideoManager.h"

@interface LocalVideoManager()

@end


@implementation LocalVideoManager

+ (instancetype)sharedInstance{
    static LocalVideoManager *sharedObject = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init{
    self = [super init];
    self.favoritedVideos = [[NSMutableArray alloc] init];
    self.playedVideos = [[NSMutableArray alloc] init];
    [self p_load];
    return self;
}

- (void)addPlayedVideo:(HiTVVideo*)video{
   // video.lastPlayTime = [NSDate date];
    //check duplicate
    HiTVVideo* existingVideo = nil;
    BOOL found = NO;
    for (existingVideo in self.playedVideos) {
        if ([video.videoID isEqualToString:existingVideo.videoID]) {
            found = YES;
            break;
        }
    }
    if (found) {
        [self.playedVideos removeObject:existingVideo];
    }
    [self.playedVideos insertObject:video atIndex:0];
    [self p_save];
}

- (void)removePlayedVideo:(HiTVVideo*)video{
    HiTVVideo* existingVideo = nil;
    BOOL found = NO;
    for (existingVideo in self.playedVideos) {
        if ([video.videoID isEqualToString:existingVideo.videoID]) {
            found = YES;
            break;
        }
    }
    if (found) {
        [self.playedVideos removeObject:existingVideo];
    }
    [self p_save];
}

- (void)removeAllPlayedVideos{
    [self.playedVideos removeAllObjects];
    [self p_save];
}

- (void)addFavoritedVideo:(HiTVVideo*)video{
    [self removeFavoritedVideo:video];
    //video.lastPlayTime = [NSDate date];
    [self.favoritedVideos insertObject:video atIndex:0];
    [self p_save];
}

- (void)removeFavoritedVideo:(HiTVVideo*)video{
    HiTVVideo* existingVideo = nil;
    BOOL found = NO;
    for (existingVideo in self.favoritedVideos) {
        if ([video.videoID isEqualToString:existingVideo.videoID]) {
            found = YES;
            break;
        }
    }
    if (found) {
        [self.favoritedVideos removeObject:existingVideo];
        [self p_save];
    }
}

- (void)removeAllFavoritedVideos{
    [self.favoritedVideos removeAllObjects];
    [self p_save];
}

- (BOOL)isVideoFavorited:(HiTVVideo*)video{
    BOOL found = NO;
    for (HiTVVideo* existingVideo in self.favoritedVideos) {
        if ([video.videoID isEqualToString:existingVideo.videoID]) {
            found = YES;
            break;
        }
    }
    return found;
}


- (void)p_load{
    NSString* folder = [HiTVConstants cacheFolder];
    NSString* favoritedPath = [folder stringByAppendingPathComponent:@"favorited"];
    NSArray* favoritedVideo = [NSKeyedUnarchiver unarchiveObjectWithFile:favoritedPath];
    if (favoritedVideo.count > 0) {
        [self.favoritedVideos addObjectsFromArray:favoritedVideo];
    }
    
    NSString* playedPath = [folder stringByAppendingPathComponent:@"played"];
    NSArray* playedVideo = [NSKeyedUnarchiver unarchiveObjectWithFile:playedPath];
    if (playedVideo.count > 0) {
        [self.playedVideos addObjectsFromArray:playedVideo];
    }
}

- (void)p_save{
    NSString* folder = [HiTVConstants cacheFolder];
    NSString* favoritedPath = [folder stringByAppendingPathComponent:@"favorited"];
    [NSKeyedArchiver archiveRootObject:self.favoritedVideos toFile:favoritedPath];
    
    NSString* playedPath = [folder stringByAppendingPathComponent:@"played"];
    [NSKeyedArchiver archiveRootObject:self.playedVideos toFile:playedPath];
}
@end
