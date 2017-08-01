//
//  SJSlider.h
//  ShiJia
//
//  Created by yy on 16/3/28.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJVideoPlayerSlider : UIControl

@property (nonatomic, assign) CGFloat value;

@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;

@property (nonatomic, assign) CGFloat cacheValue;

//@property (nonatomic, assign,readonly) BOOL isFirstResponder;

@property (nonatomic, copy, readonly) NSString *playedTime;

@property (nonatomic, copy, readonly) NSString *totalTime;

@end
