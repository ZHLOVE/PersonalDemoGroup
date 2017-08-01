//
//  TPVideoDetailMainView.h
//  ShiJia
//
//  Created by yy on 16/6/24.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJVideoSeriesTableView.h"

@class SJVideoInfoView;
@class SJVideoRecommendView;

@interface TPVideoDetailMainView : UIView

@property (nonatomic, strong, readonly) SJVideoInfoView *infoView;
@property (nonatomic, strong, readonly) SJVideoRecommendView *recommendView;

@property (nonatomic, strong) NSString *programSetId;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) NSInteger currentVideoIndex;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) SJVideoSeriesTableView *seriesTableView;
@property (nonatomic) BOOL zongyi;

@property (nonatomic, copy) void (^didSelectItemAtIndex)(NSInteger index);
@property (nonatomic, copy) void(^vipLanesImgTapped)();


@end
