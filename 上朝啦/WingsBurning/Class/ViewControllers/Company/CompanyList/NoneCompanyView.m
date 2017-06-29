//
//  NoneCompanyView.m
//  WingsBurning
//
//  Created by MBP on 2016/12/8.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "NoneCompanyView.h"

@interface NoneCompanyView()

@property(nonatomic,strong) UIImageView *noneCompanyImgView;
@property(nonatomic,strong) UILabel *noneLabel;

@end

@implementation NoneCompanyView

- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.noneCompanyImgView];
    [self.noneCompanyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(60 * ratio);
        make.width.mas_equalTo(weakSelf);
        make.height.mas_equalTo(98 * ratio);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [self addSubview:self.noneLabel];
    [self.noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.noneCompanyImgView.mas_bottom).offset(20 * ratio);
        make.height.mas_equalTo(14 * ratio);
        make.width.mas_equalTo(200 * ratio);
        make.centerX.mas_equalTo(weakSelf);
    }];
    [self addSubview:self.createCompanyBtn];
    [self.createCompanyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.noneLabel.mas_bottom).offset(35 * ratio);
        make.height.mas_equalTo(44 * ratio);
        make.width.mas_equalTo(230 * ratio);
        make.centerX.mas_equalTo(weakSelf);
    }];
}

- (UIImageView *)noneCompanyImgView{
    if (_noneCompanyImgView == nil) {
        _noneCompanyImgView = [[UIImageView alloc]init];
        _noneCompanyImgView.image = [UIImage imageNamed:@"img_null"];
        _noneCompanyImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noneCompanyImgView;
}

- (UILabel *)noneLabel{
    if (_noneLabel == nil) {
        _noneLabel = [[UILabel alloc]init];
        _noneLabel.text = @"该公司未创建";
        _noneLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _noneLabel.textAlignment = NSTextAlignmentCenter;
        _noneLabel.font = [UIFont systemFontOfSize:13];
    }
    return _noneLabel;
}

- (UIButton *)createCompanyBtn{
    if (_createCompanyBtn == nil) {
        _createCompanyBtn = [[UIButton alloc]init];
        [_createCompanyBtn setBackgroundImage:[UIImage imageNamed:@"button_createCom"] forState:UIControlStateNormal];
        [_createCompanyBtn setTitle:@"创建公司" forState:UIControlStateNormal];
        _createCompanyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_createCompanyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _createCompanyBtn;
}
@end
