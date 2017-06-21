//
//  RecordTableViewCell.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "RecordTableViewCell.h"


@interface RecordTableViewCell()

@property(nonatomic,strong) UIView *stateView;
@property(nonatomic,strong) UILabel *pcTime;
@property(nonatomic,strong) UILabel *pcShift;
@property(nonatomic,strong) UILabel *timeOffSet;
@property(nonatomic,strong) UIView  *topLine;




@end

@implementation RecordTableViewCell

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
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.stateView];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.with.mas_equalTo(10 * ratio);
        make.left.mas_equalTo(weakSelf.contentView).offset(18 * ratio);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.contentView addSubview:self.pcTime];
    [self.pcTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18 * ratio);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(weakSelf.stateView.mas_right).offset(140 * ratio);
    }];
    [self.contentView addSubview:self.timeOffSet];
    [self.timeOffSet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10 * ratio);
        make.left.mas_equalTo(weakSelf.pcShift.mas_left);
        make.top.mas_equalTo(weakSelf.pcShift.mas_bottom).offset(11 * ratio);
    }];
    [self.contentView addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(weakSelf.contentView);
    }];
}

@end


