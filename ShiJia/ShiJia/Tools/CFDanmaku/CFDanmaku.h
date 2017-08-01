//
//  CFDanmaku.h
//  31- CFDanmakuDemo
//
//  Created by 于 传峰 on 15/7/9.
//  Copyright (c) 2015年 于 传峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    CFDanmakuPositionNone = 0,
    CFDanmakuPositionCenterTop,
    CFDanmakuPositionCenterBottom
} CFDanmakuPosition;//弹幕位置

typedef NS_ENUM(NSInteger, CFDanmakuType) {
    CFDanmakuTypeText,  //文字弹幕
    CFDanmakuTypeRecord //语音弹幕
};//弹幕类型

@interface CFDanmaku : NSObject

//对应视频的时间戳
@property (nonatomic, assign) NSTimeInterval timePoint;

//文字弹幕内容
@property (nonatomic, copy) NSAttributedString* contentStr;

//语音弹幕url
@property (nonatomic, copy) NSString *recordUrlStr;

//语音duration
@property (nonatomic, copy) NSString *recordDuration;

//弹幕位置(如果不设置 默认情况下只是从右到左滚动)
@property(nonatomic, assign) CFDanmakuPosition position;

//弹幕类型（如果不设置，默认情况下只是文字弹幕）
@property (nonatomic, assign) CFDanmakuType type;

@end
