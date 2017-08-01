//
//  SJVideoDetailViewController.h
//  ShiJia
//
//  Created by yy on 16/2/2.
//  Copyright © 2016年 yy. All rights reserved.
//  点播详情页

#import <UIKit/UIKit.h>

@class SJVideoDetailViewController;
//@class SJVideoRecommendModel;
@class WatchListEntity;

@protocol SJVideoDetailViewControllerDelegate <NSObject>

- (void)vodDetail:(SJVideoDetailViewController *)controller didSelectRecommendItem:(WatchListEntity *)recommendModel;

@end

@interface SJVideoDetailViewController : BaseViewController

@property (nonatomic, weak) id<SJVideoDetailViewControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger currentVideoIndex;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, assign) CGFloat videoDatePoint;
@property (nonatomic, strong) WatchListEntity *watchEntity;
@property (nonatomic, strong) NSString* ppvId;
@property (nonatomic, assign) BOOL neededScreen;
//分享影片节目集id
@property (nonatomic, strong) NSString *programId;
@property (nonatomic, strong) NSString* epgName; //二级栏目

- (void)clearData;
- (void)refreshData;

@end
