//
//  homeNavView.h
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//
//!!!: 导航分类面板
#import <UIKit/UIKit.h>
#import "homeModel.h"
#import "HomeCallBackDelegate.h"

@interface homeNavView : UIView

@property (nonatomic, strong) homeModel *navModel;
@property (nonatomic, weak) id<CallBackDelegate>delegate;
@end
