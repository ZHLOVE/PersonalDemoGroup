//
//  TRTopNavgationView.m
//  DiTravel
//
//  Created by 李 贤辉 on 14-5-15.
//  Copyright (c) 2014年 didi inc. All rights reserved.
//

#import "TRTopNavgationView.h"
#import "UIColor-Expanded.h"

typedef enum _TitleViewPos {
    TitleViewPosLeft,   // 左侧
    TitleViewPosMiddle, // 中间
    TitleViewPosRight   // 右侧
}TitleViewPos;


@interface TRTopNavgationView ()

@property (nonatomic, strong) UIView * innerLeftView;
@property (nonatomic, strong) UIView * innerRightView;
@property (nonatomic, strong) UIView * innerCloseView;
@property (nonatomic, strong) UIView * innerTitleView;
@property (nonatomic, strong) UIView * innerLastTitleView;

@property (nonatomic, strong) CALayer * horizLineLayer;

@end



@implementation TRTopNavgationView

#pragma mark - Lifecycle
- (void)dealloc {
    _horizLineLayer = nil;
    DDLogInfo(@"TRTopNavgationView dealloc");
}

+ (instancetype) navgationView {
    TRTopNavgationView* view = [[TRTopNavgationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    return view;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = kColorNavgationView;
        
        _horizLineLayer = [CALayer layer];
        _horizLineLayer.frame = CGRectMake(0, CGRectGetHeight(frame) - 0.5, CGRectGetWidth(frame), 0.5);
        _horizLineLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
        [self.layer addSublayer:_horizLineLayer];
    }
    return self;
}

#pragma mark - Subviews
// 设置导航栏下面那根线的位置
- (void)setHorizLIneFrame:(CGRect)frame {
    [_horizLineLayer setFrame:frame];
}

- (CGFloat)subViewTop:(CGFloat)aHeight{
    if (IS_IOS7_OR_HIGHER) {
        return 16 + (44 + 4 - aHeight) / 2;
    } else {
        return (44 - aHeight) / 2;
    }
}

// 设置左侧按钮，右侧按钮，标题
- (void)setLeftView:(UIView *)aView {
    [self.innerLeftView removeFromSuperview];
    
    if (aView != nil) {
        aView.left = 0;
        aView.top = [self subViewTop:aView.height];
        if (IS_IOS7_OR_HIGHER) {
            aView.top += 1;
        }
        [self addSubview:aView];
    }
    
    self.innerLeftView = aView;
}

- (void)setRightView:(UIView *)aView {
    [self.innerRightView removeFromSuperview];
    
    if (aView != nil) {
        if(aView.width < 44.0f) {
            aView.right = self.width - 10;
        } else {
            aView.right = self.width;
        }
        aView.top = [self subViewTop:aView.height];
        if (IS_IOS7_OR_HIGHER) {
            aView.top += 1;
        }
        [self addSubview:aView];
    }
    
    self.innerRightView = aView;
}

- (void)showRightView:(BOOL)isShow {
    [self.innerRightView setHidden:!isShow];
}

// 设置关闭按钮
- (void)setCloseViewAsHidden:(UIView *)aView {
    [self.innerCloseView removeFromSuperview];
    
    if (aView != nil) {
        aView.top = [self subViewTop:aView.height];
        if (IS_IOS7_OR_HIGHER) {
            aView.top += 1;
        }
        
        if (_innerLeftView != nil) {
            aView.left = _innerLeftView.right;
        } else {
            aView.left = 0;
        }
    
        [self addSubview:aView];
    }
    
    self.innerCloseView = aView;
    _innerCloseView.hidden = YES;
}

- (void)showCloseView {
    _innerCloseView.hidden = NO;
}

- (void)hideCloseView {
    _innerCloseView.hidden = YES;
}

- (BOOL)isCloseViewHidden {
    return _innerCloseView.hidden;
}

- (void)setTitleView:(UIView *)aView {
    [self setTitleView:aView animateType:ETitleAnimationType_None];
}

- (void)setTitleView:(UIView *)aView animateType:(ETitleAnimationType)aTitleAnimationType {
    if (aTitleAnimationType == ETitleAnimationType_None) {
        [self.innerTitleView removeFromSuperview];
        
        if (aView != nil) {
            aView.left = (self.frame.size.width - aView.width) / 2;
            aView.top = [self subViewTop:aView.height];
            [self addSubview:aView];
        }
        
        self.innerTitleView = aView;
    } else {
        self.innerLastTitleView = self.innerTitleView;
        self.innerTitleView = aView;
        self.innerTitleView.alpha = 0;
        
        __weak TRTopNavgationView * weakSelf = (id)self;
        
        if (aTitleAnimationType == ETitleAnimationType_Push) { // Push动作
            [self.innerTitleView setFrame:[self frameForTitleView:self.innerTitleView titleViewPos:TitleViewPosRight]];
            [self addSubview:self.innerTitleView];

            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.innerTitleView.alpha = 1;
                [weakSelf.innerTitleView setFrame:[self frameForTitleView:weakSelf.innerTitleView titleViewPos:TitleViewPosMiddle]];
                
                weakSelf.innerLastTitleView.alpha = 0;
                [weakSelf.innerLastTitleView setFrame:[self frameForTitleView:weakSelf.innerLastTitleView titleViewPos:TitleViewPosLeft]];
            } completion:^(BOOL finished) {
                [weakSelf.innerLastTitleView removeFromSuperview];
                weakSelf.innerLastTitleView = nil;
            }];
        } else if(aTitleAnimationType == ETitleAnimationType_Pop){ // Pop动作
            [self.innerTitleView setFrame:[self frameForTitleView:self.innerTitleView titleViewPos:TitleViewPosLeft]];
            [self addSubview:self.innerTitleView];

            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.innerTitleView.alpha = 1;
                [weakSelf.innerTitleView setFrame:[self frameForTitleView:weakSelf.innerTitleView titleViewPos:TitleViewPosMiddle]];
                
                weakSelf.innerLastTitleView.alpha = 0;
                [weakSelf.innerLastTitleView setFrame:[self frameForTitleView:weakSelf.innerLastTitleView titleViewPos:TitleViewPosRight]];
            } completion:^(BOOL finished) {
                [weakSelf.innerLastTitleView removeFromSuperview];
                weakSelf.innerLastTitleView = nil;
            }];
        }
    }
    
}

- (CGRect)frameForTitleView:(UIView *)aView titleViewPos:(TitleViewPos)aTitleViewPos {
    CGRect aFrame = CGRectZero;
    aFrame.origin.y = [self subViewTop:aView.height];
    aFrame.size = aView.size;

    if (aTitleViewPos == TitleViewPosLeft) {
        aFrame.origin.x = 40;
    } else if(aTitleViewPos == TitleViewPosRight){
        aFrame.origin.x = (self.frame.size.width - aView.width - 40);
    }else{
        aFrame.origin.x = (self.frame.size.width - aView.width) / 2;
    }
    
    return aFrame;
}


- (void)setTopNavgationFrame:(CGRect)frame {
    self.frame = frame;
    [self setTitleView:_innerTitleView];
}
@end
