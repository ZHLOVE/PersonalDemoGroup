//
//  FirstCapture.m
//  WingsBurning
//
//  Created by MBP on 16/9/7.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "FirstCapture.h"
#import "PunchCameraVC.h"
#import "MainVC.h"
@interface FirstCapture()

@property(nonatomic,strong) UIImageView *tipImgView;
@property(nonatomic,strong) UILabel *tipLabel1;
@property(nonatomic,strong) UILabel *tipLabel2;
@property(nonatomic,strong) UIButton *punchBtn;

@end

@implementation FirstCapture

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [Verify setFirstCapture:NO];
}



- (void)setUpUI{
    __weak typeof(self) weakSelf = self;
    self.navigationItem.title = @"打卡";
    [self.view addSubview:self.tipLabel1];
    [self.tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(34);
        make.height.mas_equalTo(13 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    [self.view addSubview:self.tipLabel2];
    [self.tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tipLabel1.mas_bottom).offset(8.5 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(13 * ratio);
    }];
    [self.view addSubview:self.tipImgView];
    [self.tipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tipLabel2.mas_bottom).offset(24 * ratio);
        make.height.mas_equalTo(286 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    [self.view addSubview:self.punchBtn];
    [self.punchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tipImgView.mas_bottom).offset(87 * ratio);
        make.left.mas_equalTo(weakSelf.view).offset(18 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-18 * ratio);
        make.height.mas_equalTo(44 * ratio);
    }];
}


- (void)goPunch{
    MainVC *mainVC = self.navigationController.viewControllers[0];
    [mainVC goToPunch];
}


- (UIImageView *)tipImgView{
    if (_tipImgView == nil) {
        _tipImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tips"]];
        _tipImgView.contentMode = UIViewContentModeTop;
    }
    return _tipImgView;
}

- (UILabel *)tipLabel1{
    if (_tipLabel1 == nil) {
        _tipLabel1 = [[UILabel alloc]init];
        _tipLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
        _tipLabel1.font = [UIFont systemFontOfSize:13];
        _tipLabel1.textAlignment = NSTextAlignmentCenter;
        _tipLabel1.text = @"请在光线充足环境下";
    }
    return _tipLabel1;
}

- (UILabel *)tipLabel2{
    if (_tipLabel2 == nil) {
        _tipLabel2 = [[UILabel alloc]init];
        _tipLabel2.textColor = [UIColor colorWithHexString:@"#666666"];
        _tipLabel2.font = [UIFont systemFontOfSize:13];
        _tipLabel2.textAlignment = NSTextAlignmentCenter;
        _tipLabel2.text = @"保持合适的距离，将脸对准框内";
    }
    return _tipLabel2;
}

- (UIButton *)punchBtn{
    if (_punchBtn == nil) {
        _punchBtn = [[UIButton alloc]init];
        [_punchBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_punchBtn setTitle:@"去打卡" forState:UIControlStateNormal];
        _punchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_punchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_punchBtn addTarget:self action:@selector(goPunch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _punchBtn;
}





@end



































































