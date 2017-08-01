//
//  SJVideoPlayerTitleNode.h
//  ShiJia
//
//  Created by yy on 16/4/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class SJVideoPlayerTitleNode;
@class SJVideoPlayerView;

extern CGFloat const kSJVideoPlayerTitleViewHeight;

@protocol SJVideoPlayerTitleViewDelegate <NSObject>

@optional
- (void)titleViewDidClickBack:(SJVideoPlayerTitleNode *)titleview;
//- (void)titleViewDidClickDanmu:(SJVideoPlayerTitleView *)titleview;
- (void)titleViewDidClickSeries:(SJVideoPlayerTitleNode *)titlenode;
- (void)titleViewDidClickMore:(SJVideoPlayerTitleNode *)titlenode;

@end

@interface SJVideoPlayerTitleNode : ASDisplayNode

@property (nonatomic, strong, readonly) ASImageNode  *backgroudImgNode;// 背景
@property (nonatomic, strong, readonly) ASTextNode   *textNode; // 标题
@property (nonatomic, strong, readonly) ASButtonNode *backNode;  // 返回按钮
@property (nonatomic, strong, readonly) ASButtonNode *danmuNode; // 弹幕按钮
@property (nonatomic, strong, readonly) ASButtonNode *seriesNode;// 选集按钮
@property (nonatomic, strong, readonly) ASButtonNode *moreNode;  // 更多按钮
@property (nonatomic, strong, readonly) ASImageNode  *liveLogo;// 直播标志

@property (nonatomic, assign, readonly) BOOL showBarrage;

@property (nonatomic, weak) id<SJVideoPlayerTitleViewDelegate>delegate;
@property (nonatomic, strong) SJVideoPlayerView *playerView;
@property (nonatomic, assign) BOOL              isFullScreen;


- (void)showButtons;
- (void)hideButtons;

- (void)handle_dealloc;
@end

