//
//  SJAdAlertView.m
//  ShiJia
//
//  Created by yy on 2017/5/25.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJAdAlertView.h"
#import "UIImageView+WebCache.h"
#import "HomeJumpWebViewController.h"

static CGFloat kMainViewWidth = 240.0;
static CGFloat kMainViewHeight = 200.0;
//static CGFloat kMainViewLeftPadding = 10.0;
static CGFloat kTitleLabelTopPadding = 5.0;
static CGFloat kTitleLabelLeftPadding = 35.0;
static CGFloat kTitleLabelHeight = 20.0 * 2;
static CGFloat kCloseButtonWidth = 40.0;
static CGFloat kCloseButtonRightPadding = -5.0;
static CGFloat kCloseButtonTopPadding = -5.0;
static CGFloat kBuyButtonWidth = 113.0;
static CGFloat kBuyButtonHight = 29.0;
static CGFloat kBuyButtonBottomPadding = 5.0;
static CGFloat kImageViewLeftPadding = 5.0;

@interface SJAdAlertView ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrlString;
@property (nonatomic, strong) NSString *actionUrlString;

@end

@implementation SJAdAlertView

#pragma mark - Lifecycle
- (instancetype)initWithTitle:(NSString *)text imageUrl:(NSString *)imgString actionUrl:(NSString *)actionString
{
    self = [super init];
    if (self) {
        
        self.title = text;
        self.imageUrlString = imgString;
        self.actionUrlString = actionString;
        
//        [self setupSubviews];
//        self.titleLabel.text = text;
//        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"家庭电视@iphonex"]];
    }
    return self;

}

#pragma mark - Subviews
- (void)setupSubviews
{
    // back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor blackColor];
    backButton.alpha = 0.5;
    //[backButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    // main view
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.layer.cornerRadius = 5.0;
    self.mainView.layer.masksToBounds = YES;
    [self addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self).with.offset(0);
        make.width.mas_equalTo(kMainViewWidth);
        make.height.mas_equalTo(kMainViewHeight);
    }];
    
    // title label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView).with.offset(kTitleLabelLeftPadding);
        make.right.equalTo(self.mainView).with.offset(-kTitleLabelLeftPadding);
        make.top.equalTo(self.mainView).with.offset(kTitleLabelTopPadding);
        make.height.mas_equalTo(kTitleLabelHeight);
    }];
    
    // close button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton setImage:[UIImage imageNamed:@"ad_close_btn"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView).with.offset(kCloseButtonTopPadding);
        make.right.equalTo(self.mainView).with.offset(-kCloseButtonRightPadding);
        make.width.mas_equalTo(kCloseButtonWidth);
        make.height.mas_equalTo(kCloseButtonWidth);
    }];
    
    // buy button
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"add_buy_btn"] forState:UIControlStateNormal];
    [buyButton setTitle:@"前往购买 》" forState:UIControlStateNormal];
    [buyButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mainView).with.offset(0);
        make.bottom.equalTo(self.mainView).with.offset(-kBuyButtonBottomPadding);
        make.width.mas_equalTo(kBuyButtonWidth);
        make.height.mas_equalTo(kBuyButtonHight);
    }];
    
    //image view
    self.imgView = [[UIImageView alloc] init];
    self.imgView.backgroundColor = [UIColor clearColor];
    [self.mainView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mainView).with.offset(kImageViewLeftPadding);
        make.right.right.equalTo(self.mainView).with.offset(-kImageViewLeftPadding);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
        make.bottom.equalTo(buyButton.mas_top).with.offset(-kBuyButtonBottomPadding);
    }];
    
}

// main view 由小变大动画
- (void)startMainViewAnimation
{
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.08f animations:^{
        
        self.mainView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
        
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.mainView.transform = CGAffineTransformMakeScale(.5f, .05f);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.mainView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                [self layoutIfNeeded];//强制绘制
                
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

#pragma mark - Event
- (void)buyButtonClicked:(id)sender
{
    if (!self.activeController) {
        return;
    }
    
    HomeJumpWebViewController *webVC = [[HomeJumpWebViewController alloc] init];
    webVC.urlStr = self.actionUrlString;
    [self.activeController.navigationController pushViewController:webVC animated:YES];
    [self hide];
}

#pragma mark - Operations
- (void)show
{
    for (UIView *subview in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subview isKindOfClass:[SJAdAlertView class]]) {
            [subview removeFromSuperview];
        }
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self setupSubviews];
    
    self.titleLabel.text = self.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlString] placeholderImage:[UIImage imageNamed:@"家庭电视@iphonex"]];
    
    [self startMainViewAnimation];
    
}

- (void)hide
{
    self.hidden = YES;
    [self removeFromSuperview];
}

@end
