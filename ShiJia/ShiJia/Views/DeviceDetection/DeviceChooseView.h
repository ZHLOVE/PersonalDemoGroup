//
//  DeviceChooseView.h
//  HiTV
//
//  Created by 蒋海量 on 15/8/4.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenDeviceInfo.h"
#import "HiTVDeviceInfo.h"

@protocol DeviceChooseViewDelegate <NSObject>
@optional
- (void)connectDevice:(HiTVDeviceInfo *)device;
- (void)connectScreenDevice:(ScreenDeviceInfo *)device;

@end
@interface DeviceChooseView : UIView
@property (nonatomic,strong) id <DeviceChooseViewDelegate> m_delegate;
@property(nonatomic,strong) NSArray *deviceList;

-(void)refreshData;
@end
