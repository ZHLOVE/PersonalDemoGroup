//
//  SJLiveTVVideoDetailMainView.h
//  ShiJia
//
//  Created by yy on 16/6/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJVideoSeriesTableView.h"

@class SJLiveTVProgramView;
@class SJVideoRecommendView;

@interface SJLiveTVVideoDetailMainView : UIView

@property (nonatomic, strong, readonly) SJLiveTVProgramView *programView;
@property (nonatomic, strong, readonly) SJVideoRecommendView *recommendView;
@property (nonatomic, strong, readonly) SJVideoSeriesTableView *seriesTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) void (^didSelect)(NSInteger index);
@property (nonatomic, copy) void(^vipLanesImgTapped)();

@end
