//
//  ChannelViewController.h
//  HiTV
//
//  Created by 蒋海量 on 15/1/20.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//
//modify by jianghailiang 20150212 (.h.m)

#import <UIKit/UIKit.h>
#import "TVDataProvider.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ChannelCell.h"
#import "LocalTVStationManager.h"
#import "ProgramViewController.h"

@interface ChannelViewController : BaseViewController
{
    BOOL recently_open;
    BOOL channel_open;

}
@property(nonatomic,strong)  ProgramViewController *programViewController;

@property(nonatomic,strong) IBOutlet UITableView *channelTabView;
@property(nonatomic,strong) IBOutlet UIView *contentView;

@property (nonatomic, strong) NSArray* tvsArray;
@property (nonatomic, strong) NSArray* recentTvsArray;

@end
