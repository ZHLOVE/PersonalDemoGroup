//
//  SJMultiVideoDetailViewController.h
//  ShiJia
//
//  Created by yy on 16/7/22.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WatchListEntity;
@class TVProgram;
@class TVStation;

typedef NS_ENUM(NSInteger, SJVideoType) {
    
    SJVideoTypeVOD,    //点播
    SJVideoTypeWatchTV,//看点
    SJVideoTypeLive,   //直播
    SJVideoTypeReplay  //回看
    
};//视频类型

@interface SJMultiVideoDetailViewController : UIViewController

@property (nonatomic, assign) BOOL neededScreen;
@property (nonatomic, assign) CGFloat videoDatePoint;
@property (nonatomic, assign) int seriesNumber;

@property (nonatomic, assign) SJVideoType videoType;

@property (nonatomic, assign) NSInteger currentVideoIndex;

@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) NSString *categoryID;

@property (nonatomic, strong) TVProgram *tvProgram;
@property (nonatomic, strong) TVStation *tvStation;

//分享影片节目集id
@property (nonatomic, strong) NSString *programId;
@property (nonatomic, strong) NSString* epgName; //二级栏目单
@property (nonatomic, strong) NSString* shortVideo;
@property (nonatomic, strong) WatchListEntity *watchEntity;

- (instancetype)initWithVideoType:(SJVideoType)type;

- (void)setupChildController;

@end
