//
//  HomePageViewController.h
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homeModel.h"
#import "ChannelUnitModel.h"
#import "HomeCallBackDelegate.h"



@interface HomePageViewController : UIViewController

@property (nonatomic, strong) ChannelUnitModel *chanelModel;
@property (nonatomic, strong) id <MainDelegate>delegate;

@end

