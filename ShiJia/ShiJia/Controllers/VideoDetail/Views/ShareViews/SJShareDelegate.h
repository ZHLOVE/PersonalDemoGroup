//
//  SJShareDelegate.h
//  ShiJia
//
//  Created by 峰 on 16/7/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SJ30SVedioRequestModel.h"

@protocol SJShareDelegate;

@protocol SJShareDelegate <NSObject>

@optional

- (void)SJShareContentWithPlatform:(Platform)type andModel:(SJ30SVedioModel *)model isDo:(BOOL) flag;

@end

