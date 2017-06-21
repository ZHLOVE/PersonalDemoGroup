//
//  NormalHeadView.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "NormalHeadView.h"

@interface NormalHeadView()
@property(nonatomic,strong) UILabel *titleLabel;

@end

@implementation NormalHeadView



- (void)loadUI{
    __weak typeof (self) weakSelf = self;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(18 * ratio);
        make.top.mas_equalTo(weakSelf).offset(16 * ratio);
        make.height.mas_equalTo(14);
    }];
    
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"本月汇总";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _titleLabel;
}
@end




