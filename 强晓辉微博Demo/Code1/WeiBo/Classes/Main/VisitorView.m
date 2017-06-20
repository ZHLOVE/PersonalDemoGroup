//
//  VisitorView.m
//  WeiBo
//
//  Created by student on 16/4/22.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "VisitorView.h"

// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface VisitorView()



@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UIImageView *homeIcon;
@property (nonatomic,strong) UIImageView *maskBGView;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UIButton *registerButton;

@end


@implementation VisitorView

- (void)setupVisitorInfo:(BOOL)isHome imageName:(NSString *)imageName message:(NSString *)message{
    self.iconView.hidden = !isHome;
    self.homeIcon.image = [UIImage imageNamed:imageName];
    self.messageLabel.text = message;
    
    if(isHome)
    {
        [self startAnimation];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加子控件
        
        //1
        [self addSubview:self.homeIcon];
        //2
        [self addSubview:self.iconView];
        //3
        [self addSubview:self.messageLabel];
        //4
        [self addSubview:self.registerButton];
        //5
        [self addSubview:self.loginButton];
        //居中
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.center);
        }];
        //居中
        [self.homeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.center);
        }];
        //顶部靠着iconView
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.bottom);
            make.centerX.equalTo(self.centerX);
            make.width.equalTo(self.width).multipliedBy(0.8);
        }];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.messageLabel.bottom);
            make.right.equalTo(self.centerX).offset(-20);
            make.width.equalTo(100);
        }];
        [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.messageLabel.bottom);
            make.left.equalTo(self.centerX).offset(20);
            make.width.equalTo(100);
        }];
        
    }
    return self;
}

- (void)startAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.toValue = @(2 * M_PI);
    animation.duration = 20;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    [self.iconView.layer addAnimation:animation forKey:@""];
}

#pragma mark - 控件懒加载
- (UIImageView *)iconView{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_smallicon"]];
    }
    return _iconView;
}

- (UIImageView *)homeIcon{
    if (_homeIcon == nil) {
        _homeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_house"]];
    }
    return _homeIcon;
}

- (UILabel *)messageLabel{
    if (_messageLabel == nil) {
        
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.numberOfLines = 0;//不限行数
        _messageLabel.text = @"测试一下多行内容测试一下多行内容测试一下多行内容测试一下多行内容测试一下多行内容";
    }
    return _messageLabel;
}

- (UIButton *)registerButton{
    if (_registerButton == nil) {
        _registerButton = [[UIButton alloc] init];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_registerButton setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"common_button_white_disable"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIImageView *)maskBGView
{
    if(_maskBGView == nil)
    {
        _maskBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_mask_smallicon"]];
    }
    return _maskBGView;
}

#pragma mark - 控件事件处理
- (void)loginBtnWillPressed{
    [self.delegate loginBtnWillPressed];
}
- (void)registerBtnWillPressed{
    [self.delegate registerBtnWillPressed];
}


@end
