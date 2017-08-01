//
//  SJVideoPlayerBottomNode.h
//  ShiJia
//
//  Created by yy on 16/4/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class SJVideoPlayerBottomNode;
@class SJPlayerSlider;
@class SJVideoPlayerView;

extern CGFloat const kSJVideoPlayerBottomViewHeight;

@protocol SJVideoPlayerBottomViewDelegate <NSObject>

@optional

- (void)bottomViewDidClickPlay:(SJVideoPlayerBottomNode *)bottomnode;
- (void)bottomViewDidClickPause:(SJVideoPlayerBottomNode *)bottomnode;
- (void)bottomViewDidClickFullScreen:(SJVideoPlayerBottomNode *)bottomnode;
- (void)bottomViewDidClickMiniScreen:(SJVideoPlayerBottomNode *)bottomnode;
- (void)sliderDidBecomeFirstResponder:(SJVideoPlayerBottomNode *)bottomnode;
- (void)bottomView:(SJVideoPlayerBottomNode *)bottomnode didChangeSliderValue:(SJPlayerSlider *)slider;


@end


@interface SJVideoPlayerBottomNode : ASDisplayNode

@property (nonatomic,   weak) id<SJVideoPlayerBottomViewDelegate>delegate;

@property (nonatomic, strong, readonly) SJPlayerSlider *slider;

@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isPlaying;

- (void)updateCacheTime:(CGFloat)cacheTime;
- (void)updateTotalTime:(CGFloat)totalTime;
- (void)updatePlayedTime:(CGFloat)playerTime;
- (void)resizeNodeClicked:(id)sender;

- (CGFloat)sliderValue;
- (NSString *)playedTime;
- (NSString *)totalTime;

- (void)handle_dealloc;
@end
