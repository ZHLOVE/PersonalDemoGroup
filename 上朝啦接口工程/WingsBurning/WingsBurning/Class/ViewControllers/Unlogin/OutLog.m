//
//  OutLog.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "OutLog.h"
#import "Login.h"
#import "RegisterVC.h"
#import "CameraVC.h"
@interface OutLog()

@property(nonatomic,strong) UILabel *mainTitle;
@property(nonatomic,strong) UIButton *loginBtn;
@property(nonatomic,strong) UIButton *registerBtn;
@property(nonatomic,strong) UIView *leftView;
@property(nonatomic,strong) UIView *rightView;

@end

@implementation OutLog

- (void)viewDidLoad{
    [super viewDidLoad];
    NSDate *nowDate = [NSDate date];



    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:true];
}

- (void)setUpUI{
    __weak typeof (self) weakSelf = self;
    [self.view addSubview:self.mainTitle];
    [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200 * ratio);
        make.width.mas_equalTo(200 * ratio);
        make.center.mas_equalTo(weakSelf.view);
    }];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60 * ratio);
        make.width.mas_equalTo(130 * ratio);
        make.left.mas_equalTo(weakSelf.view).offset(20 * ratio);
        make.bottom.mas_equalTo(weakSelf.view).offset(-20 * ratio);
    }];
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(weakSelf.loginBtn);
        make.right.mas_equalTo(weakSelf.view).offset(-20 * ratio);
        make.bottom.mas_equalTo(weakSelf.view).offset(-20 * ratio);
    }];


}

#pragma mark -事件
//登录
- (void)loginBtnPressed{

    Login *vc = [[Login alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}

//注册
- (void)registerBtnPressed{
//    RegisterVC *re = [[RegisterVC alloc]init];
    CameraVC *cam = [[CameraVC alloc]init];
    [self.navigationController pushViewController:cam animated:true];

}


#pragma mark - 懒加载界面控件
- (UILabel *)mainTitle{
    if (_mainTitle == nil) {
        _mainTitle = [UILabel createLabelWithColor:[UIColor colorWithHexString:@"#02D176"] fontSize:50];
        _mainTitle.text = @"上朝啦";
        _mainTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _mainTitle;
}

- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]init];
        [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#02d176"] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.layer.borderWidth = 1.0;
        _loginBtn.layer.cornerRadius = 4.0;
        _loginBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_loginBtn addTarget:self action:@selector(loginBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [[UIButton alloc]init];
        [_registerBtn setTitleColor:[UIColor colorWithHexString:@"#02d176"] forState:UIControlStateNormal];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registerBtn.layer.borderWidth = 1.0;
        _registerBtn.layer.cornerRadius = 4.0;
        _registerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_registerBtn addTarget:self action:@selector(registerBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
@end
