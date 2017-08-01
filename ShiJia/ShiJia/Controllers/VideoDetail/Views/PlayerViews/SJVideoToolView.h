//
//  SJVideoToolView.h
//  ShiJia
//
//  Created by yy on 16/6/15.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJVideoToolView;

@protocol SJVideoToolViewDelegate <NSObject>

/**
 *  开始投屏
 *
 *  @param toolview
 */
- (void)toolViewDidStartScreeningVideo:(SJVideoToolView *)toolview;

/**
 *  取消投屏
 *
 *  @param toolview
 */
- (void)toolViewDidCancelScreen:(SJVideoToolView *)toolview;

/**
 *  收藏影片
 *
 *  @param toolview
 */
- (void)toolViewDidStartCollectingVideo:(SJVideoToolView *)toolview;

/**
 *  取消收藏
 *
 *  @param toolview
 */
- (void)toolViewDidCancelCollectVideo:(SJVideoToolView *)toolview;

/**
 *  分享影片
 *
 *  @param toolview 
 */
- (void)toolViewDidStartShareVideo:(SJVideoToolView *)toolview;

@end


@interface SJVideoToolView : UIView

/**
 *  已收藏标志位
 */
@property (nonatomic, assign) BOOL collected;

/**
 *  已投屏标志位
 */
@property (nonatomic, assign) BOOL screened;

/**
 *  是否只支持电视播放
 */
@property (nonatomic, assign) BOOL isTVPlay;
@property (nonatomic, weak) id<SJVideoToolViewDelegate>delegate;

- (void)screenButtonClicked:(id)sender;

@end
