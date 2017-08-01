//
//  SJWatchTVDetailController.h
//  ShiJia
//
//  Created by yy on 16/7/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
// 看点
#import <UIKit/UIKit.h>
#import "WatchListEntity.h"

//@class WatchListEntity;

@class SJWatchTVDetailController;
//@class SJVideoRecommendModel;

@protocol SJWatchTVDetailControllerDelegate <NSObject>

- (void)watchTVDetail:(SJWatchTVDetailController *)controller didSelectRecommendItem:(WatchListEntity *)recommendModel;

@end

@interface SJWatchTVDetailController : UIViewController

@property (nonatomic, weak) id<SJWatchTVDetailControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger currentVideoIndex;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) WatchListEntity *watchEntity;
@property (nonatomic, assign) CGFloat videoDatePoint;
@property (nonatomic, strong) NSString* epgName; //二级栏目
@property (nonatomic, assign) BOOL neededScreen;

//分享影片节目集id
@property (nonatomic, strong) NSString *programId;
@property (nonatomic, strong) NSString* programname;
@property (nonatomic, strong) NSString* ppvId;

- (void)clearData;
- (void)refreshData;

@end
