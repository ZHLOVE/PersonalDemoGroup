//
//  NormalTableViewCell.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "NormalTableViewCell.h"



@interface NormalTableViewCell()

@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UIView *hLine;
@property(nonatomic,strong) UIView *loLineLeft;
@property(nonatomic,strong) UIView *loLineMid;
@property(nonatomic,strong) UIView *loLineRight;
@property(nonatomic,strong) UILabel *normalDayLabel;
@property(nonatomic,strong) UILabel *kgMinuteLabel;
@property(nonatomic,strong) UILabel *cdMinLabel;
@property(nonatomic,strong) UILabel *ztMinLabel;
@property(nonatomic,strong) UIView *topLine;
@property(nonatomic,strong) UIView *bottomLine;

@property(nonatomic,strong) UILabel *norTimeLabel;
@property(nonatomic,strong) UILabel *kgTimeLabel;
@property(nonatomic,strong) UILabel *cdTimeLabel;
@property(nonatomic,strong) UILabel *ztTimeLabel;

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

- (void)setPunchGather:(PunchesGather *)punchGather{
    if (punchGather) {
        NSMutableAttributedString *norAttStr = [[NSMutableAttributedString alloc] initWithString:punchGather.normal_days];
        NSMutableAttributedString *absentAttStr = [[NSMutableAttributedString alloc] initWithString:punchGather.absent_days];
        NSMutableAttributedString *lateAttStr = [[NSMutableAttributedString alloc] initWithString:punchGather.late_minutes];
        NSMutableAttributedString *earAttStr = [[NSMutableAttributedString alloc] initWithString:punchGather.early_minutes];
        NSRange norRange = [punchGather.normal_days rangeOfString:@"0-9" options:NSRegularExpressionSearch];
        NSRange absRange = [punchGather.absent_days rangeOfString:@"0-9" options:NSRegularExpressionSearch];
        NSRange lateRange = [punchGather.late_minutes rangeOfString:@"0-9" options:NSRegularExpressionSearch];
        NSRange earRange = [punchGather.early_minutes rangeOfString:@"0-9" options:NSRegularExpressionSearch];

        [norAttStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:15.0f]
                        range:norRange];
        [absentAttStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15.0f]
                          range:absRange];
        [lateAttStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15.0f]
                          range:lateRange];
        [earAttStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15.0f]
                          range:earRange];
        _norTimeLabel.attributedText = norAttStr;
        _kgTimeLabel.attributedText = absentAttStr;
        _cdTimeLabel.attributedText = lateAttStr;
        _ztTimeLabel.attributedText = earAttStr;
    }else{
        NSMutableAttributedString *norAttStr = [[NSMutableAttributedString alloc] initWithString:@"天"];
        NSMutableAttributedString *absentAttStr = [[NSMutableAttributedString alloc] initWithString:@"分钟"];
        NSMutableAttributedString *lateAttStr = [[NSMutableAttributedString alloc] initWithString:@"分钟"];
        NSMutableAttributedString *earAttStr = [[NSMutableAttributedString alloc] initWithString:@"天"];
        NSRange norRange = [punchGather.normal_days rangeOfString:@"0-9" options:NSRegularExpressionSearch];
        NSRange absRange = [punchGather.absent_days rangeOfString:@"0-9" options:NSRegularExpressionSearch];
        NSRange lateRange = [punchGather.late_minutes rangeOfString:@"0-9" options:NSRegularExpressionSearch];
        NSRange earRange = [punchGather.early_minutes rangeOfString:@"0-9" options:NSRegularExpressionSearch];

        [norAttStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15.0f]
                          range:norRange];
        [absentAttStr addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:15.0f]
                             range:absRange];
        [lateAttStr addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:15.0f]
                           range:lateRange];
        [earAttStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15.0f]
                          range:earRange];
        _norTimeLabel.attributedText = norAttStr;
        _kgTimeLabel.attributedText = absentAttStr;
        _cdTimeLabel.attributedText = lateAttStr;
        _ztTimeLabel.attributedText = earAttStr;
    }
}




- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView).offset(18 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(16 * ratio);
        make.height.mas_equalTo(14);
    }];
    [self.contentView addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(weakSelf.mas_top).offset(46 * ratio);
    }];
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
        make.top.mas_equalTo(weakSelf.contentView).offset(69 * ratio);
    }];
    [self.contentView addSubview:self.norTimeLabel];
    [self.norTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90 * ratio);
        make.height.mas_equalTo(20 * ratio);
        make.centerX.mas_equalTo(weakSelf.normalDayLabel.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.loLineLeft.mas_centerY);
    }];
    [self.contentView addSubview:self.cdMinLabel];
    [self.cdMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.normalDayLabel.mas_centerX).offset(94 * ratio);
        make.height.mas_equalTo(11 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(69 * ratio);
    }];
    [self.contentView addSubview:self.cdTimeLabel];
    [self.cdTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90 * ratio);
        make.height.mas_equalTo(20 * ratio);
        make.centerX.mas_equalTo(weakSelf.cdMinLabel.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.loLineLeft.mas_centerY);
    }];
    [self.contentView addSubview:self.ztMinLabel];
    [self.ztMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.cdMinLabel.mas_centerX).offset(94 * ratio);
        make.height.mas_equalTo(11 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(69 * ratio);
    }];
    [self.contentView addSubview:self.ztTimeLabel];
    [self.ztTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90 * ratio);
        make.height.mas_equalTo(20 * ratio);
        make.centerX.mas_equalTo(weakSelf.ztMinLabel.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.loLineLeft.mas_centerY);
    }];
    [self.contentView addSubview:self.kgMinuteLabel];
    [self.kgMinuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.ztMinLabel.mas_centerX).offset(94 * ratio);
        make.height.mas_equalTo(11 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(69 * ratio);
    }];
    [self.contentView addSubview:self.kgTimeLabel];
    [self.kgTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90 * ratio);
        make.height.mas_equalTo(20 * ratio);
        make.centerX.mas_equalTo(weakSelf.kgMinuteLabel.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.loLineLeft.mas_centerY);
    }];
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(10 * ratio);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(1);
    }];
}

#pragma mark-控件设置

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"本月汇总";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _titleLabel;
}

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


- (UILabel *)cdMinLabel{
    if (_cdMinLabel == nil) {
        _cdMinLabel = [[UILabel alloc]init];
        _cdMinLabel.text = @"迟到";
        _cdMinLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _cdMinLabel.font = [UIFont systemFontOfSize:11];
        _cdMinLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cdMinLabel;
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


- (UIView *)topLine{
    if (_topLine == nil) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    }
    return _topLine;
}

- (UIView *)bottomLine{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    }
    return _bottomLine;
}

- (UILabel *)norTimeLabel{
    if (_norTimeLabel == nil) {
        _norTimeLabel = [[UILabel alloc]init];
        _norTimeLabel.textAlignment = NSTextAlignmentCenter;
        _norTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _norTimeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _norTimeLabel;
}

- (UILabel *)kgTimeLabel{
    if (_kgTimeLabel == nil) {
        _kgTimeLabel = [[UILabel alloc]init];
        _kgTimeLabel.textAlignment = NSTextAlignmentCenter;
        _kgTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _kgTimeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _kgTimeLabel;
}

- (UILabel *)cdTimeLabel{
    if (_cdTimeLabel == nil) {
        _cdTimeLabel = [[UILabel alloc]init];
        _cdTimeLabel.textAlignment = NSTextAlignmentCenter;
        _cdTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _cdTimeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _cdTimeLabel;
}

- (UILabel *)ztTimeLabel{
    if (_ztTimeLabel == nil) {
        _ztTimeLabel = [[UILabel alloc]init];
        _ztTimeLabel.textAlignment = NSTextAlignmentCenter;
        _ztTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _ztTimeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _ztTimeLabel;
}


@end



