//
//  BorrowTableViewCell.m
//  WingsBurning
//
//  Created by MBP on 16/9/17.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BorrowTableViewCell.h"

@interface BorrowTableViewCell()

@property(nonatomic,strong) UIImageView *porImgView;
@property(nonatomic,strong) UILabel *nameLabel;

@end

@implementation BorrowTableViewCell
- (void)setEmployee:(EmployeeM *)employee{
    _employee = employee;
    _nameLabel.text = employee.name;
     [_porImgView sd_setImageWithURL:[NSURL URLWithString:employee.avatar_url] placeholderImage:[UIImage imageNamed:@"default_touxiang"] options:SDWebImageRefreshCached];
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
    [self.contentView addSubview:self.porImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(weakSelf.porImgView.mas_right).offset(10 * ratio);
        make.height.mas_equalTo(16 * ratio);
        make.width.mas_equalTo(260 * ratio);
    }];
}
#pragma mark-懒加载
- (UIImageView *)porImgView{
    if (_porImgView == nil) {
        _porImgView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 11, 30, 30)];
        _porImgView.layer.masksToBounds = NO;
        _porImgView.aliCornerRadius = 15.0f;
        _porImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _porImgView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nameLabel.font = [UIFont systemFontOfSize:14 * ratio];
    }
    return _nameLabel;
}
@end
