//
//  HeadView.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "HeadView.h"


@interface HeadView()
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIImageView *topImageView;
@property(nonatomic,strong) UIView *portraitImageRim;
@property(nonatomic,strong) UIImageView *portraitImage;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *compLabel;


@end

@implementation HeadView



- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    [self addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(162 * ratio);
        make.top.left.right.mas_equalTo(weakSelf);
    }];
    [self addSubview:self.portraitImageRim];
    [self.portraitImageRim mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(18 * ratio);
        make.top.mas_equalTo(weakSelf).offset(40 * ratio);
        make.height.mas_equalTo(92 * ratio);
        make.width.mas_equalTo(74 * ratio);
    }];
    [self addSubview:self.portraitImage];
    [self.portraitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(88 *ratio);
        make.width.mas_equalTo(70 * ratio);
        make.centerX.mas_equalTo(weakSelf.portraitImageRim.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.portraitImageRim.mas_centerY);
    }];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.portraitImageRim).offset(22 * ratio);
        make.left.mas_equalTo(weakSelf.portraitImageRim.mas_right).offset(20 * ratio);
        make.height.mas_equalTo(15 * ratio);
    }];
    [self addSubview:self.compLabel];
    [self.compLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(64 * ratio);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(15 * ratio);
        make.left.mas_equalTo(weakSelf.portraitImageRim.mas_right).offset(20 * ratio);
        make.width.mas_equalTo(140 * ratio);
    }];
}


#pragma mark-控件设置
- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.frame = self.bounds;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIImageView *)topImageView{
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_bg"]];
    }
    return _topImageView;
}

- (UIView *)portraitImageRim{
    if (_portraitImageRim == nil) {
        _portraitImageRim = [[UIView alloc]init];
        _portraitImageRim.layer.borderWidth = 1.0;
        _portraitImageRim.layer.borderColor = [UIColor whiteColor].CGColor;
        _portraitImageRim.layer.cornerRadius = 4.0;
    }
    return _portraitImageRim;
}

- (UIImageView *)portraitImage{
    if (_portraitImage == nil) {
        _portraitImage = [[UIImageView alloc]init];
        _portraitImage.layer.cornerRadius = 4.0;
        _portraitImage.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImage.image = [UIImage imageNamed:@"default_touxiang"];
        _portraitImage.layer.masksToBounds = YES;
        _portraitImage.userInteractionEnabled = YES;
    }
    return _portraitImage;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"童梓潼";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UILabel *)compLabel{
    if (_compLabel == nil) {
        _compLabel = [[UILabel alloc]init];
        _compLabel.text = @"未加入公司";
        _compLabel.textColor = [UIColor whiteColor];
        _compLabel.textAlignment = NSTextAlignmentLeft;
        _compLabel.font = [UIFont systemFontOfSize:12];
        _compLabel.numberOfLines = 2;
    }
    return _compLabel;
}
@end


