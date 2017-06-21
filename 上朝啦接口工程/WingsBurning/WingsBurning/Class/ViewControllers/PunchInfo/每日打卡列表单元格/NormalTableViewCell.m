//
//  NormalTableViewCell.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "NormalTableViewCell.h"



@interface NormalTableViewCell()

@property(nonatomic,strong) UIView *hLine;
@property(nonatomic,strong) UIView *loLineLeft;
@property(nonatomic,strong) UIView *loLineMid;
@property(nonatomic,strong) UIView *loLineRight;
@property(nonatomic,strong) UILabel *normalDayLabel;
@property(nonatomic,strong) UILabel *dayUnitLabel;
@property(nonatomic,strong) UILabel *dayLabel;
@property(nonatomic,strong) UILabel *kgMinuteLabel;
@property(nonatomic,strong) UILabel *kgUnitLabel;
@property(nonatomic,strong) UILabel *kgLabel;
@property(nonatomic,strong) UILabel *cdMinLabel;
@property(nonatomic,strong) UILabel *cdUnitLabel;
@property(nonatomic,strong) UILabel *cdLabel;
@property(nonatomic,strong) UILabel *ztMinLabel;
@property(nonatomic,strong) UILabel *ztUnitLabel;
@property(nonatomic,strong) UILabel *ztLabel;
@property(nonatomic,strong) UIView *topLine;

@end

@implementation NormalTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    [self.contentView addSubview:self.loLineLeft];
    [self.loLineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.left.mas_equalTo(weakSelf.contentView).offset(93 * ratio);
        make.height.mas_equalTo(40 * ratio);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-40 * ratio);
    }];
    [self.contentView addSubview:self.loLineMid];
    [self.loLineMid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.left.mas_equalTo(weakSelf.loLineLeft.mas_right).offset(93 * ratio);
        make.height.mas_equalTo(40 * ratio);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-40 * ratio);
    }];
    [self.contentView addSubview:self.loLineRight];
    [self.loLineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(40 * ratio);
        make.right.mas_equalTo(weakSelf.contentView).offset(-93 * ratio);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-40 * ratio);
    }];
    [self.contentView addSubview:self.normalDayLabel];
    [self.normalDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_left).offset(46 * ratio);
        make.height.mas_equalTo(11 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(23 * ratio);
    }];
    [self.contentView addSubview:self.dayUnitLabel];
    [self.dayUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-23 * ratio);
        make.height.mas_equalTo(10 * ratio);
        make.right.mas_equalTo(weakSelf.loLineLeft.mas_left).offset(-30 * ratio);
    }];
    [self.contentView addSubview:self.dayLabel];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15 * ratio);
        make.right.mas_equalTo(weakSelf.dayUnitLabel.mas_left).offset(-3 * ratio);
        make.bottom.mas_equalTo(weakSelf.dayUnitLabel.mas_bottom);
    }];
    [self.contentView addSubview:self.cdMinLabel];
    [self.cdMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.normalDayLabel.mas_centerX).offset(93 * ratio);
        make.height.mas_equalTo(11 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(23 * ratio);
    }];
    [self.contentView addSubview:self.cdUnitLabel];
    [self.cdUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10 * ratio);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-23 * ratio);
        make.right.mas_equalTo(weakSelf.loLineMid.mas_left).offset(-30 * ratio);
    }];
    [self.contentView addSubview:self.cdLabel];
    [self.cdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15 * ratio);
        make.right.mas_equalTo(weakSelf.cdUnitLabel.mas_left).offset(-3 * ratio);
        make.bottom.mas_equalTo(weakSelf.cdUnitLabel.mas_bottom);
    }];
    [self.contentView addSubview:self.ztMinLabel];
    [self.ztMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.cdMinLabel.mas_centerX).offset(93 * ratio);
        make.height.mas_equalTo(11 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(23 * ratio);
    }];
    [self.contentView addSubview:self.ztUnitLabel];
    [self.ztUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10 * ratio);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-23 * ratio);
        make.right.mas_equalTo(weakSelf.loLineRight).offset(-30 * ratio);
    }];
    [self.contentView addSubview:self.ztLabel];
    [self.ztLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15 * ratio);
        make.right.mas_equalTo(weakSelf.ztUnitLabel.mas_left).offset(-3 * ratio);
        make.bottom.mas_equalTo(weakSelf.ztUnitLabel.mas_bottom);
    }];
    [self.contentView addSubview:self.kgMinuteLabel];
    [self.kgMinuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.ztMinLabel.mas_centerX).offset(93 * ratio);
        make.height.mas_equalTo(11 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(23 * ratio);
    }];
    [self.contentView addSubview:self.kgUnitLabel];
    [self.kgUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10 * ratio);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-23 * ratio);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-30 * ratio);
    }];
    [self.contentView addSubview:self.kgLabel];
    [self.kgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15 * ratio);
        make.right.mas_equalTo(weakSelf.kgUnitLabel.mas_left).offset(-3 * ratio);
        make.bottom.mas_equalTo(weakSelf.kgUnitLabel.mas_bottom);
    }];
    [self.contentView addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(weakSelf.contentView);
    }];
}

#pragma mark-控件设置
- (UIView *)hLine{
    if (_hLine == nil) {
        _hLine = [[UIView alloc]init];
        _hLine.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    }
    return _hLine;
}

- (UIView *)loLineLeft{
    if (_loLineLeft == nil) {
        _loLineLeft = [[UIView alloc]init];
        _loLineLeft.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    }
    return _loLineLeft;
}
- (UIView *)loLineMid{
    if (_loLineMid == nil) {
        _loLineMid = [[UIView alloc]init];
        _loLineMid.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    }
    return _loLineMid;
}
- (UIView *)loLineRight{
    if (_loLineRight == nil) {
        _loLineRight = [[UIView alloc]init];
        _loLineRight.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    }
    return _loLineRight;
}

- (UILabel *)normalDayLabel{
    if (_normalDayLabel == nil) {
        _normalDayLabel = [[UILabel alloc]init];
        _normalDayLabel.text = @"正常打卡";
        _normalDayLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _normalDayLabel.font = [UIFont systemFontOfSize:11];
        _normalDayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _normalDayLabel;
}

- (UILabel *)dayUnitLabel{
    if (_dayUnitLabel == nil) {
        _dayUnitLabel = [[UILabel alloc]init];
        _dayUnitLabel.text = @"天";
        _dayUnitLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _dayUnitLabel.font = [UIFont systemFontOfSize:10];
        _dayUnitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayUnitLabel;
}

- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc]init];
        _dayLabel.text = @"25";
        _dayLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _dayLabel.font = [UIFont systemFontOfSize:15];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}

- (UILabel *)kgMinuteLabel{
    if (_kgMinuteLabel == nil) {
        _kgMinuteLabel = [[UILabel alloc]init];
        _kgMinuteLabel.text = @"旷工";
        _kgMinuteLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _kgMinuteLabel.font = [UIFont systemFontOfSize:11];
        _kgMinuteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _kgMinuteLabel;
}

- (UILabel *)kgUnitLabel{
    if (_kgUnitLabel == nil) {
        _kgUnitLabel = [[UILabel alloc]init];
        _kgUnitLabel.text = @"分钟";
        _kgUnitLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _kgUnitLabel.font = [UIFont systemFontOfSize:10];
        _kgUnitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _kgUnitLabel;
}

- (UILabel *)kgLabel{
    if (_kgLabel == nil) {
        _kgLabel = [[UILabel alloc]init];
        _kgLabel.text = @"1234";
        _kgLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _kgLabel.font = [UIFont systemFontOfSize:15];
        _kgLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _kgLabel;
}

- (UILabel *)cdMinLabel{
    if (_cdMinLabel == nil) {
        _cdMinLabel = [[UILabel alloc]init];
        _cdMinLabel.text = @"迟到";
        _cdMinLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _cdMinLabel.font = [UIFont systemFontOfSize:11];
        _cdMinLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _kgMinuteLabel;
}

- (UILabel *)cdUnitLabel{
    if (_cdUnitLabel == nil) {
        _cdUnitLabel = [[UILabel alloc]init];
        _cdUnitLabel.text = @"分钟";
        _cdUnitLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _cdUnitLabel.font = [UIFont systemFontOfSize:10];
        _cdUnitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cdUnitLabel;
}

- (UILabel *)cdLabel{
    if (_cdLabel == nil) {
        _cdLabel = [[UILabel alloc]init];
        _cdLabel.text = @"1234";
        _cdLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _cdLabel.font = [UIFont systemFontOfSize:15];
        _cdLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cdLabel;
}

- (UILabel *)ztMinLabel{
    if (_ztMinLabel == nil) {
        _ztMinLabel = [[UILabel alloc]init];
        _ztMinLabel.text = @"早退";
        _ztMinLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _ztMinLabel.font = [UIFont systemFontOfSize:11];
        _ztMinLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ztMinLabel;
}

- (UILabel *)ztUnitLabel{
    if (_ztUnitLabel == nil) {
        _ztUnitLabel = [[UILabel alloc]init];
        _ztUnitLabel.text = @"分钟";
        _ztUnitLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _ztUnitLabel.font = [UIFont systemFontOfSize:10];
        _ztUnitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ztUnitLabel;
}

- (UILabel *)ztLabel{
    if (_ztLabel == nil) {
        _ztLabel = [[UILabel alloc]init];
        _ztLabel.text = @"1234";
        _ztLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _ztLabel.font = [UIFont systemFontOfSize:15];
        _ztLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ztLabel;
}

- (UIView *)topLine{
    if (_topLine == nil) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    }
    return _topLine;
}

@end



