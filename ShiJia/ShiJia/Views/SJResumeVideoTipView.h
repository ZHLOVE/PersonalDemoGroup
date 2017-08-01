//
//  SJResumeVideoTipView.h
//  ShiJia
//
//  Created by yy on 2017/5/19.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SJResumeVideoMode){
    
    SJResumeVideoModeTogether,//手机电视在一起模式,即回家模式
    SJResumeVideoModeUntogether//手机电视不在一起，即离家模式
};

@interface SJResumeVideoTipView : UIView

@property (nonatomic, copy) void(^leftButtonClickBlock)();
@property (nonatomic, copy) void(^rightButtonClickBlock)();

- (instancetype)initWithMode:(SJResumeVideoMode)mode recentVideo:(RecentVideo *)video;
- (void)show;
- (void)hide;

@end
