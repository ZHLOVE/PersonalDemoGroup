//
//  SJLiveTVDetailViewController.h
//  ShiJia
//
//  Created by yy on 16/6/17.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//  直播详情页

#import <UIKit/UIKit.h>
#import "WatchListEntity.h"

@class TVProgram;
@class TVStation;

@class SJLiveTVDetailViewController;

@protocol SJLiveTVDetailViewControllerDelegate <NSObject>

- (void)liveTVDetail:(SJLiveTVDetailViewController *)controller didSelectRecommendItem:(WatchListEntity *)recommendModel;

@end

typedef NS_ENUM(NSInteger, kLiveTVDetailType){
    
    kLiveTVDetailTypeLive,//直播
    kLiveTVDetailTypeReplay//回看
};

@interface SJLiveTVDetailViewController : UIViewController


@property (nonatomic, weak)   id<SJLiveTVDetailViewControllerDelegate>delegate;
@property (nonatomic, strong) TVProgram *tvProgram;
@property (nonatomic, strong) NSString  *LivePlayType;
@property (nonatomic, strong) TVStation *tvStation;
@property (nonatomic, strong) WatchListEntity *watchEntity;
@property (nonatomic, assign) CGFloat videoDatePoint;
@property (nonatomic, assign) kLiveTVDetailType videoType;
@property (nonatomic, strong) NSString* ppvId;
@property (nonatomic, strong) NSString* epgName; //二级栏目
@property (nonatomic, assign) BOOL neededScreen;

- (void)clearData;
- (void)refreshData;
- (instancetype)initWithVideoType:(kLiveTVDetailType)videotype;

@end
