//
//  CompanyCell.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CompanyCell.h"

@interface CompanyCell()

@property(nonatomic,strong) UILabel *comNameLabel;
@property(nonatomic,strong) UILabel *comStateLabel;
@property(nonatomic,strong) UIImageView *comStateIcon;
@property(nonatomic,strong) UIImageView *comLogoImgView;

@end

@implementation CompanyCell

- (void)setEmployer:(EmployerM *)employer{
    _comNameLabel.text = employer.name;
    if ([employer.is_verified isEqualToString:@"1"] ) {
        _comStateLabel.text = @"已验证";
        [_comStateIcon setImage:[UIImage imageNamed:@"icon_authen"]];
    }else{
        _comStateLabel.text = @"未验证";
        [_comStateIcon setImage:[UIImage imageNamed:@"icon_unauthen"]];
    }
    if (employer.image_url != nil) {
         [_comLogoImgView sd_setImageWithURL:[NSURL URLWithString:employer.image_url]];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

#pragma mark-布局
- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    [self.contentView addSubview:self.comLogoImgView];
    [self.comLogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView).offset(25 * ratio);
        make.left.mas_equalTo(weakSelf.contentView).offset(18 * ratio);
        make.height.width.mas_equalTo(40 * ratio);
    }];
    [self.contentView addSubview:self.comNameLabel];
    [self.comNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView).offset(25 * ratio);
        make.left.mas_equalTo(weakSelf.comLogoImgView.mas_right).offset(12 * ratio);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-95 * ratio);
    }];
    [self.contentView addSubview:self.comStateIcon];
    [self.comStateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(11 * ratio);
        make.height.mas_equalTo(12 * ratio);
        make.top.mas_equalTo(weakSelf.comNameLabel.mas_bottom).offset(14 * ratio);
        make.left.mas_equalTo(weakSelf.comLogoImgView.mas_right).offset(12 * ratio);
    }];
    [self.contentView addSubview:self.comStateLabel];
    [self.comStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50 * ratio);
        make.height.mas_equalTo(12 * ratio);
        make.top.mas_equalTo(weakSelf.comNameLabel.mas_bottom).offset(14 * ratio);
        make.left.mas_equalTo(weakSelf.comStateIcon.mas_right).offset(10 * ratio);
    }];
    [self.contentView addSubview:self.joinComBtn];
    [self.joinComBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(75 * ratio);
        make.height.mas_equalTo(39 * ratio);
        make.right.mas_equalTo(weakSelf.contentView).offset(-18 * ratio);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
}

#pragma mark-控件设置
- (UILabel *)comNameLabel{
    if (_comNameLabel == nil) {
        _comNameLabel = [[UILabel alloc]init];
        _comNameLabel.textAlignment = NSTextAlignmentLeft;
        _comNameLabel.font = [UIFont systemFontOfSize:15];
        _comNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _comNameLabel.numberOfLines = 2;
        _comNameLabel.text = @"江南大学对面的公司";
    }
    return _comNameLabel;
}

- (UIImageView *)comLogoImgView{
    if (_comLogoImgView == nil) {
        _comLogoImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_logo"]];
        _comLogoImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return  _comLogoImgView;
}

- (UIImageView *)comStateIcon{
    if (_comStateIcon == nil) {
        _comStateIcon = [[UIImageView alloc]init];
    }
    return _comStateIcon;
}

- (UILabel *)comStateLabel{
    if (_comStateLabel == nil) {
        _comStateLabel = [[UILabel alloc]init];
        _comStateLabel.textAlignment = NSTextAlignmentLeft;
        _comStateLabel.font = [UIFont systemFontOfSize:12];
        _comStateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _comStateLabel.text = @"未验证";
    }
    return _comStateLabel;
}

- (UIButton *)joinComBtn{
    if (_joinComBtn == nil) {
        _joinComBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _joinComBtn.layer.borderWidth = 1.0;
        _joinComBtn.layer.borderColor = [UIColor colorWithHexString:@"#01c872"].CGColor;
        _joinComBtn.layer.cornerRadius = 20.0 * ratio;
        _joinComBtn.layer.masksToBounds = YES;
        [_joinComBtn setTitle:@"加入" forState:UIControlStateNormal];
        [_joinComBtn setTitleColor:[UIColor colorWithHexString:@"#01c872"] forState:UIControlStateNormal];
    }
    return _joinComBtn;
}


@end














