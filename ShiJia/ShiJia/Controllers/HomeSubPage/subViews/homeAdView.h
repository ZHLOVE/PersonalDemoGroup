//
//  homeAdView.h
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//
//!!!: 赞助商投放

#import <UIKit/UIKit.h>
#import "homeModel.h"
#import "HomeCallBackDelegate.h"


@interface homeAdView : UIView

@property (nonatomic, strong) homeModel *adModel;
@property (nonatomic, weak) id<CallBackDelegate>delegate;

@end
