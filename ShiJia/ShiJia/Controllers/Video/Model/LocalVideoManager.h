//
//  RecentVideoManager.h
//  HiTV
//
//  created by iSwift on 3/11/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HiTVVideo.h"

/**
 *  访问过或者收藏的信息管理类
 */
@interface LocalVideoManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  最近播放过的视频
 */
@property (nonatomic, strong) NSMutableArray* playedVideos;

/**
 *  收藏的视频
 */
@property (nonatomic, strong) NSMutableArray* favoritedVideos;

/**
 *  添加一个视频到历史视频
 *
 *  @param video 历史视频
 */
- (void)addPlayedVideo:(HiTVVideo*)video;

/**
 *  历史记录里面删除一个播放过的视频
 *
 *  @param video 历史视频
 */
- (void)removePlayedVideo:(HiTVVideo*)video;

/**
 *  删除所有点播历史记录
 */
- (void)removeAllPlayedVideos;


/**
 *  收藏视频
 *
 *  @param video 视频
 */
- (void)addFavoritedVideo:(HiTVVideo*)video;

/**
 *  从收藏里面删除一个视频
 *
 *  @param video 视频
 */
- (void)removeFavoritedVideo:(HiTVVideo*)video;

/**
 *  删除所有收藏的视频
 */
- (void)removeAllFavoritedVideos;

/**
 *  判断视频是否被收藏
 *
 *  @param video 视频
 *
 *  @return Yes，收藏的
 */
- (BOOL)isVideoFavorited:(HiTVVideo*)video;

@end
