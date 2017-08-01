//
//  homeTableViewCell.h
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homeModel.h"
#import "HomeCallBackDelegate.h"
#import "HomePageViewController.h"

@interface homeTableViewCell : UITableViewCell<CallBackDelegate>
@property (nonatomic, strong) homeModel *cellModel;
@property (nonatomic, weak)   id<HomeDelegate>delegate;

+(CGFloat )figureUpCellHighWithData:(homeModel *)model;


@end
