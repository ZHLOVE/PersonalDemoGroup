//
//  SJShareVideoViewModel.h
//  ShiJia
//
//  Created by yy on 16/5/13.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJ30SVedioRequestModel.h"
@class HiTVVideo;
@class VideoSource;
@class WatchFocusVideoEntity;
@class WatchFocusVideoProgramEntity;
@class TVProgram;
@class TVStation;

typedef NS_ENUM(NSInteger, TPShareVideoType){
    
    TPShareVideoTypeVOD,//点播
    TPShareVideoTypeWatchTV,//看点
    TPShareVideoTypeLive,//直播
    TPShareVideoTypeReplay//回看
    
};

@interface SJShareVideoViewModel : NSObject

@property (nonatomic, assign) TPShareVideoType videoType;

@property (nonatomic, strong) HiTVVideo *video;
@property (nonatomic, strong) VideoSource *videoSource;
@property (nonatomic, strong) WatchFocusVideoEntity *watchEntity;
@property (nonatomic, strong) WatchFocusVideoProgramEntity *watchProgramEntity;
@property (nonatomic, strong) TVProgram *tvProgram;
@property (nonatomic, strong) TVStation *tvStation;
@property (nonatomic, assign) CGFloat currentPlayedSeconds;

- (instancetype)initWithController:(UIViewController *)controller;

- (void)shareVideoToUsers:(NSArray <UserEntity *> *)list;

//10 秒短视频分享
@property (nonatomic, strong) NSString *shortVideoUrl;

//短视频缩略图
@property (nonatomic, strong) NSString *videoThumImgUrl;

//图片分享url
@property (nonatomic, strong) NSString *imageUrl;

//TODO:有料分享消息体组成
//TODO:短视频链接和短视频ID 用于被分享的好友用ID 查询视频详情
@property (nonatomic, strong) NSString *hotspotVideoUrl;//视频链接
@property (nonatomic, strong) NSString *hotspotVideoID;//视频ID
@property (nonatomic, strong) NSString *hotspotVideoImage;//视频缩略图
@property (nonatomic, strong) NSString *hotspotVideoTitle;//视频标题
@end
