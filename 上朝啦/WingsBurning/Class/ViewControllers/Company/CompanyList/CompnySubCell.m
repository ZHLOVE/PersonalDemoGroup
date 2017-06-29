//
//  CompnySubCell.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CompnySubCell.h"

@interface CompnySubCell()

@property(nonatomic,strong) UIImageView *phoneIcon;
@property(nonatomic,strong) UIImageView *locationIcon;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) UILabel *addressLabel;

@end

@implementation CompnySubCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)setEmployer:(EmployerM *)employer{
    _phoneLabel.text = employer.phone_number;
    _addressLabel.text = employer.address;
}


#pragma mark-布局
- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    [self.contentView addSubview:self.phoneIcon];
    [self.phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView).offset(71 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(25 * ratio);
        make.width.mas_equalTo(10 * ratio);
        make.height.mas_equalTo(13 * ratio);
    }];
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView).offset(25 * ratio);
        make.left.mas_equalTo(weakSelf.phoneIcon.mas_right).offset(10 * ratio);
        make.width.mas_equalTo(150 * ratio);
        make.height.mas_equalTo(13 * ratio);
    }];
    [self.contentView addSubview:self.locationIcon];
    [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.phoneIcon);
        make.top.mas_equalTo(weakSelf.phoneIcon.mas_bottom).offset(16 * ratio);
        make.width.height.mas_equalTo(weakSelf.phoneIcon);
    }];
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.phoneLabel.mas_bottom).offset(13 * ratio);
        make.left.mas_equalTo(weakSelf.phoneLabel);
        make.right.mas_equalTo(weakSelf.contentView).offset(-30);
    }];

}

#pragma mark-控件设置
- (UIImageView *)phoneIcon{
    if (_phoneIcon == nil) {
        _phoneIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_telephone"]];
        _phoneIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _phoneIcon;
}

- (UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.font = [UIFont systemFontOfSize:13];
        _phoneLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.text = @"137090115678";
    }
    return _phoneLabel;
}

- (UIImageView *)locationIcon{
    if (_locationIcon == nil) {
        _locationIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_location"]];
        _locationIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _locationIcon;
}
- (UILabel *)addressLabel{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.numberOfLines = 0;
        [_addressLabel sizeToFit];
        _addressLabel.text = @"江苏省无锡市滨湖区震泽路100号恒华科技园二十号楼四零七室";
    }
    return _addressLabel;
}








@end
