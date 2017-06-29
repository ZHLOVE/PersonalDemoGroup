//
//  CardView.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CardView.h"

@interface CardView()



@end


@implementation CardView

- (void)setContract:(ContractM *)contract{
    _stateLabel.text = contract.state;
     EmployerM *employer = contract.employer;
    _compLabel.text = employer.name;
    _addressLabel.text = employer.address;
}

- (void)setEmployee:(EmployeeM *)employee{
    _employee = employee;
    _nameLabel.text = employee.name;
    NSData *imgData = [Verify getImage];
    UIImage *img = [[UIImage alloc]initWithData:imgData];
    if (img) {
        [_portraitImage setImage:img];
    }else{
        [_portraitImage sd_setImageWithURL:[NSURL URLWithString:employee.avatar_url] placeholderImage:[UIImage imageNamed:@"default_touxiang"]];
    }
}

- (void)loadUI{
     __weak typeof (self) weakSelf = self;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10.0;
    [self addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(16 * ratio);
        make.right.mas_equalTo(weakSelf).offset(-24 * ratio);
        make.height.mas_equalTo(14 * ratio);
        make.width.mas_equalTo(120 * ratio);
    }];
    [self addSubview:self.cardLabel];
    [self.cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(16 * ratio);
        make.left.mas_equalTo(weakSelf).offset(24 * ratio);
        make.height.mas_equalTo(14 * ratio);
        make.width.mas_equalTo(120 * ratio);
    }];
    [self addSubview:self.portraitImageRim];
    [self.portraitImageRim mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(92 * ratio);
        make.width.mas_equalTo(74 * ratio);
        make.left.mas_equalTo(weakSelf).offset(24 * ratio);
        make.bottom.mas_equalTo(weakSelf).offset(-29 * ratio);
    }];
    [self addSubview:self.portraitImage];
    [self.portraitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(88 * ratio);
        make.width.mas_equalTo(70 * ratio);
        make.centerX.mas_equalTo(weakSelf.portraitImageRim);
        make.centerY.mas_equalTo(weakSelf.portraitImageRim);
    }];
    [self addSubview: self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(56 * ratio);
        make.height.mas_equalTo(18 * ratio);
        make.width.mas_equalTo(120 * ratio);
        make.left.mas_equalTo(weakSelf.portraitImageRim.mas_right).offset(14 * ratio);
    }];
    [self addSubview:self.compIcon];
    [self.compIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(12 * ratio);
        make.height.mas_equalTo(11 * ratio);
        make.left.mas_equalTo(weakSelf.nameLabel);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(23 * ratio);
    }];
    [self addSubview:self.compLabel];
    [self.compLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-24 * ratio);
        make.left.mas_equalTo(weakSelf.compIcon.mas_right);
        make.top.mas_equalTo(weakSelf.compIcon.mas_top).offset(-9);
        make.height.mas_equalTo(36 * ratio);
    }];
    [self addSubview:self.addressIcon];
    [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(12 * ratio);
        make.height.mas_equalTo(11 * ratio);
        make.left.mas_equalTo(weakSelf.compIcon);
        make.top.mas_equalTo(weakSelf.compIcon.mas_bottom).offset(20 * ratio);
    }];
    [self addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-24 * ratio);
        make.left.mas_equalTo(weakSelf.addressIcon.mas_right);
        make.top.mas_equalTo(weakSelf.addressIcon.mas_top).offset(-9);
        make.height.mas_equalTo(36 * ratio);
    }];
}

- (UIView *)portraitImageRim{
    if (_portraitImageRim == nil) {
        _portraitImageRim = [[UIView alloc]init];
        _portraitImageRim.layer.borderWidth = 1.0;
        _portraitImageRim.layer.borderColor = [UIColor colorWithHexString:@"#11ce79"].CGColor;
        _portraitImageRim.layer.cornerRadius = 4.0;
    }
    return _portraitImageRim;
}

- (UIImageView *)portraitImage{
    if (_portraitImage == nil) {
        _portraitImage = [[UIImageView alloc]init];
        _portraitImage.layer.cornerRadius = 4.0;
        _portraitImage.layer.masksToBounds = YES;
        _portraitImage.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImage.userInteractionEnabled = YES;
    }
    return _portraitImage;
}
- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"童子彤";
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15*ratio];
    }
    return  _nameLabel;
}

- (UIImageView *)compIcon{
    if (_compIcon == nil) {
        _compIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_home"]];
        _compIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _compIcon;
}

- (UITextView *)compLabel{
    if (_compLabel == nil) {
        _compLabel = [[UITextView alloc]init];
        _compLabel.font = [UIFont systemFontOfSize:12*ratio];
        _compLabel.backgroundColor = [UIColor clearColor];
        _compLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _compLabel.userInteractionEnabled = NO;
        _compLabel.text = @"无锡乐骐科技有限公司无锡乐骐科技有限公司无锡乐骐科技有限公司";
    }
    return _compLabel;
}

- (UIImageView *)addressIcon{
    if (_addressIcon == nil) {
        _addressIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_location"]];
        _addressIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _addressIcon;
}

- (UITextView *)addressLabel{
    if (_addressLabel == nil) {
        _addressLabel = [[UITextView alloc]init];
        _addressLabel.font = [UIFont systemFontOfSize:12*ratio];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.userInteractionEnabled = NO;
        _addressLabel.text = @"江苏省无锡市滨湖区江苏省无锡市滨湖区江苏省无锡市滨湖区";
    }
    return _addressLabel;
}

- (UILabel *)stateLabel{
    if (_stateLabel == nil) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textColor = [UIColor colorWithHexString:@"#ff810a"];
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.text = @"审核状态";
        _stateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stateLabel;
}

- (UILabel *)cardLabel{
    if (_cardLabel == nil) {
        _cardLabel = [[UILabel alloc]init];
        _cardLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _cardLabel.font = [UIFont systemFontOfSize:14];
        _cardLabel.text = @"您的电子考勤卡";
    }
    return _cardLabel;
}

@end

