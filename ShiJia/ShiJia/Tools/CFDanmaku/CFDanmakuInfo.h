//
//  CFDanmakuInfo.h
//  HJDanmakuDemo
//
//  Created by 于 传峰 on 15/7/10.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CFDanmaku;
@class MLPlayVoiceButton;

extern CGFloat const kCFDanmakuInfoRecordButtonWidth;
extern CGFloat const kCFDanmakuInfoRecordButtonHeight;

@interface CFDanmakuInfo : NSObject

// 弹幕内容label
@property (nonatomic, weak) UILabel  *playLabel;

@property (nonatomic, weak) MLPlayVoiceButton *recordButton;

// 弹幕label frame
//@property(nonatomic, assign) CGRect labelFrame;
//
@property (nonatomic, assign) NSTimeInterval leftTime;
@property (nonatomic, strong) CFDanmaku* danmaku;
@property (nonatomic, assign) NSInteger lineCount;
@property (nonatomic, assign) CGFloat pausedOriginX;
@property (nonatomic, assign) CGFloat pausedOriginY;

@end
