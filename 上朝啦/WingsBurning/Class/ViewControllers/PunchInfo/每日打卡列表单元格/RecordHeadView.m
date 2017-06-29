//
//  RecordHeadView.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "RecordHeadView.h"

@interface RecordHeadView()

@property(nonatomic,strong) UILabel *workTimeLabel;

@end

@implementation RecordHeadView

- (void)setPeriod:(PeriodM *)period{
    if (period.duration) {
        int dura = [period.duration intValue];
        int hour = dura/60;
        int minutes = dura%60;
        _workTimeLabel.text = [NSString stringWithFormat:@"%@ %d小时%d分钟",period.rule.name,hour,minutes];
    }else{
        NSString *start = [period.begin_at substringToIndex:5];
        NSString *end = [period.end_at substringToIndex:5];
        _workTimeLabel.text = [NSString stringWithFormat:@"%@ %@-%@",period.rule.name,start,end];
    }
}

- (void)loadUI{
    self.backgroundColor = [UIColor whiteColor];
    __weak typeof (self) weakSelf = self;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(18 * ratio);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(14);
    }];
    [self addSubview:self.workTimeLabel];
    [self.workTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(weakSelf.titleLabel.mas_right).offset(40 * ratio);
    }];
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @" 月 日 星期  ";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _titleLabel;
}

- (UILabel *)workTimeLabel{
    if (_workTimeLabel == nil) {
        _workTimeLabel = [[UILabel alloc]init];
        _workTimeLabel.text = @"上班时间";
        _workTimeLabel.font = [UIFont systemFontOfSize:11];
        _workTimeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _workTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _workTimeLabel;
}
@end

