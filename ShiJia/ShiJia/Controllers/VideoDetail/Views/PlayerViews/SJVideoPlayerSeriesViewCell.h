//
//  SJVideoPlayerSeriesViewCell.h
//  ShiJia
//
//  Created by yy on 16/6/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kSJVideoPlayerSeriesViewCellIdentifier;

typedef NS_ENUM(NSInteger, SJVideoPlayerSeriesViewCellStyle){
    
    SJVideoPlayerSeriesViewCellStyleNormal, // 普通状态
    SJVideoPlayerSeriesViewCellStylePlaying, // 正在播放
    SJVideoPlayerSeriesViewCellStyleError   //不能播放
};

@interface SJVideoPlayerSeriesViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) SJVideoPlayerSeriesViewCellStyle style;
@property (nonatomic, strong) id model;

@end
