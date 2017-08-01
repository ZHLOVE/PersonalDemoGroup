//
//  SJVideoSeriesTableView.h
//  ShiJia
//
//  Created by 蒋海量 on 16/7/19.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJVideoSeriesTableView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong, readwrite) UITableView *tabView;
@property (nonatomic) float playH;

@property (nonatomic, copy) void (^didSelectItemAtIndex)(NSInteger index);
//首次播放的index
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, assign) NSInteger currentVideoIndex;

-(void)hiddenFullView;
@end
