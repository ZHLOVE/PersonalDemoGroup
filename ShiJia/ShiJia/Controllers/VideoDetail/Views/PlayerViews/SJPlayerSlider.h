//
//  SJPlayerProgressView.h
//  ShiJia
//
//  Created by yy on 16/3/25.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "AsyncDisplayKit.h"

@interface SJPlayerSlider : ASControlNode

@property (nonatomic, assign) CGFloat value;

@property (nonatomic) float minimumValue;

@property (nonatomic) float maximumValue;// 视频时长

@property (nonatomic, assign) CGFloat cacheValue;

@property (nonatomic, assign) BOOL isFirstResponder;

@property (nonatomic, copy, readonly) NSString *playedTime;
@property (nonatomic, copy, readonly) NSString *totalTime;

@end
