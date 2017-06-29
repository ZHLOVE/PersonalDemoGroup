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

/**attence_state*/
@property(nonatomic,strong) UILabel *pcShift;
@property(nonatomic,strong) UILabel *shiftOneline;
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

- (void)setPunchInfo:(Punch *)punchInfo{

    NSString *timeStr = [punchInfo.created_at substringToIndex:16];
    _pcTime.text = [timeStr substringFromIndex:11];

    /**  打卡结果 "状态：`normal_accepted` 正常上班；
     `late_accepted`  迟到；
     `early_accepted`早退;
     `absent_accepted` 旷工"*/
    NSArray *statesArray = @[@"normal_accepted", @"late_accepted", @"early_accepted",@"absent_accepted"];
    NSUInteger index = [statesArray indexOfObject:punchInfo.attence_state];
    switch (index) {
        case 0:
            _stateView.backgroundColor = [UIColor colorWithHexString:@"#04cf71"];
            _shiftOneline.text = @"正常";
            _pcShift.text = @" ";
            _timeOffSet.text = nil;
            break;
        case 1:
            _stateView.backgroundColor = [UIColor colorWithHexString:@"#FBCE64"];
            _pcShift.text = @"迟到";
            _shiftOneline.text = @" ";
            _timeOffSet.text = [NSString stringWithFormat:@"迟到%@分钟",punchInfo.unnormal_minutes];
            break;
        case 2:
            _stateView.backgroundColor = [UIColor colorWithHexString:@"#FBCE64"];
            _pcShift.text = @"早退";
            _shiftOneline.text = @" ";
            _timeOffSet.text = [NSString stringWithFormat:@"早退%@分钟",punchInfo.unnormal_minutes];
            break;
        case 3:
            _stateView.backgroundColor = [UIColor colorWithHexString:@"#FD936F"];
            _shiftOneline.text = @"旷工";
            _pcShift.text = @" ";
//            _timeOffSet.text = punchInfo.note;  //旷工的备注信息，打开就能显示
            _timeOffSet.text = @" ";
            break;
        default:
            break;
    }
}

- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.stateView];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(10 * ratio);
        make.left.mas_equalTo(weakSelf.contentView).offset(18 * ratio);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.contentView addSubview:self.pcTime];
    [self.pcTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18 * ratio);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(weakSelf.stateView.mas_right).offset(14 * ratio);
    }];
    [self.contentView addSubview:self.shiftOneline];
    [self.shiftOneline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12 * ratio);
        make.centerY.mas_equalTo(weakSelf.pcTime.mas_centerY);
        make.left.mas_equalTo(weakSelf.contentView).offset(140 * ratio);
    }];
    [self.contentView addSubview:self.pcShift];
    [self.pcShift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12 * ratio);
        make.top.mas_equalTo(weakSelf.contentView).offset(30 * ratio);
        make.left.mas_equalTo(weakSelf.contentView).offset(140 * ratio);
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

#pragma MARK-控件设置
- (UIView *)stateView{
    if (_stateView == nil) {
        _stateView = [[UIView alloc]init];
        _stateView.backgroundColor = [UIColor colorWithHexString:@"#04cf71"];
    }
    return _stateView;
}

- (UILabel *)pcTime{
    if (_pcTime == nil) {
        _pcTime = [[UILabel alloc]init];
        _pcTime.text = @" "; //08:30
        _pcTime.textColor = [UIColor colorWithHexString:@"#666666"];
        _pcTime.font = [UIFont systemFontOfSize:18];
        _pcTime.textAlignment = NSTextAlignmentLeft;
    }
    return _pcTime;
}

- (UILabel *)pcShift{
    if (_pcShift == nil) {
        _pcShift = [[UILabel alloc]init];
        _pcShift.text = @" ";//迟到，早退
        _pcShift.textColor = [UIColor colorWithHexString:@"#999999"];
        _pcShift.font = [UIFont systemFontOfSize:12];
        _pcShift.textAlignment = NSTextAlignmentLeft;
    }
    return _pcShift;
}

- (UILabel *)shiftOneline{
    if (_shiftOneline == nil) {
        _shiftOneline = [[UILabel alloc]init];
        _shiftOneline.text = @" ";//正常，旷工
        _shiftOneline.textColor = [UIColor colorWithHexString:@"#999999"];
        _shiftOneline.font = [UIFont systemFontOfSize:12];
        _shiftOneline.textAlignment = NSTextAlignmentLeft;
    }
    return _shiftOneline;
}

- (UILabel *)timeOffSet{
    if (_timeOffSet == nil) {
        _timeOffSet = [[UILabel alloc]init];
        _timeOffSet.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeOffSet.text = @" ";//迟到8分钟
        _timeOffSet.font = [UIFont systemFontOfSize:10];
    }
    return _timeOffSet;
}

- (UIView *)topLine{
    if (_topLine == nil) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
    }
    return _topLine;
}


@end


