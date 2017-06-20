//
//  WelcomeViewController.m
//  Weibo
//
//  Created by qiang on 5/4/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "WelcomeViewController.h"

#import "UserAccount.h"

#import "UIImageView+WebCache.h"

// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

@interface WelcomeViewController()

// 背景图片
@property (nonatomic,strong) UIImageView *bgImageView;
// icon图片
@property (nonatomic,strong) UIImageView *iconImageView;
// 欢迎文字
@property (nonatomic,strong) UILabel *welcomeLabel;

@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    // 1. 添加子控件
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.welcomeLabel];
    
    // 2. 添加布局约束
    [self.bgImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(self.view);
    }];
    
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.view.top).offset(150);
        make.width.height.equalTo(100);
    }];
    
    [self.welcomeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.iconImageView.bottom).offset(30);
    }];
    
    // 3. 设置用户的头像
    UserAccount *account = [UserAccount sharedUserAccount];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:account.avatar_large]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 动画
    [UIView animateWithDuration:2 delay:1 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        // 修改约束
        [self.iconImageView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(-100);
        }];
        // 重新布局
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
       // 进入首页
        NSLog(@"进入首页");
        // 发通知，让AppDelegate切换rootViewController到MainViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiactionRootSwitchViewController object:nil userInfo:@{@"VC":@"Main"}];
    }];
}

#pragma mark - 懒加载子控件
- (UIImageView *)bgImageView
{
    if(_bgImageView == nil)
    {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_background"]];
    }
    return _bgImageView;
}

- (UIImageView *)iconImageView
{
    if(_iconImageView == nil)
    {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default_big"]];
        _iconImageView.layer.cornerRadius = 50;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)welcomeLabel
{
    if(_welcomeLabel == nil)
    {
        _welcomeLabel = [[UILabel alloc] init];
        _welcomeLabel.text = @"欢迎回来";
        [_welcomeLabel sizeToFit];
    }
    return _welcomeLabel;
}

@end
