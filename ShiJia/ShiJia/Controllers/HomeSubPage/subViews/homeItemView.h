//
//  homeItemView.h
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//
//!!!: 三方合作入口
#import <UIKit/UIKit.h>
#import "homeModel.h"
#import "HomeCallBackDelegate.h"
@interface homeItemView : UIView

@property (nonatomic, strong) homeModel *itemModel;
@property (nonatomic, weak) id<CallBackDelegate>delegate;
@property (nonatomic, strong) void (^clickActionCallBack)(homeModel *bannerModel);

@end
