//
//  TRTopNavgationView.h
//  DiTravel
//
//  Created by 李 贤辉 on 14-5-15.
//  Copyright (c) 2014年 didi inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ETitleAnimationType) {
    ETitleAnimationType_None = 0,   // 无动作
    ETitleAnimationType_Push = 1,   // Push动作
    ETitleAnimationType_Pop = 2     // Pop动作
};

@interface TRTopNavgationView : UIView

+ (instancetype)navgationView;

// 设置左侧按钮，右侧按钮，标题
// aView的起点和宽度由调用者决定，左侧按钮的起点为0，右侧按钮的右侧为320，标题的中间位160
- (void)setLeftView:(UIView *)aView;
- (void)setRightView:(UIView *)aView;
- (void)showRightView:(BOOL)isShow;

// 设置关闭按钮
- (void)setCloseViewAsHidden:(UIView *)aView;
// 展示关闭按钮，是为了配合实现类似于微信的WebView的效果
- (void)showCloseView;
- (void)hideCloseView;
- (BOOL)isCloseViewHidden;

- (void)setTitleView:(UIView *)aView;
- (void)setTitleView:(UIView *)aView animateType:(ETitleAnimationType)aTitleAnimationType;

// 设置导航栏下面那根线的位置
- (void)setHorizLIneFrame:(CGRect)frame;

//游戏中重新设置导航栏frame 并且更新title的frame
- (void)setTopNavgationFrame:(CGRect)frame;

@end
