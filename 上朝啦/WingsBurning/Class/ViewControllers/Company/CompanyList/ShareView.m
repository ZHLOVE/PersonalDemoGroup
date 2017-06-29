//
//  ShareView.m
//  WingsBurning
//
//  Created by MBP on 2016/12/13.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ShareView.h"
#import "OpenShareHeader.h"


@interface ShareView()

@property(nonatomic,strong) UILabel *weixinLabel;
@property(nonatomic,strong) UILabel *QQLabel;
@property(nonatomic,strong) UILabel *emailLabel;
@property(nonatomic,strong) UIView *upLine;
@property(nonatomic,strong) UIView *downLine;
@property(nonatomic,strong) UILabel *shareToLabel;


@end

int shareNumber = 0;

@implementation ShareView

- (void)loadUI{
    shareNumber = 0;
    [self addSubview:self.shareToLabel];
    [self addSubview:self.cancelBtn];
    if ([OpenShare isWeixinInstalled]) {
        [self addSubview:self.weiXinHaoYouBtn];
        [self addSubview:self.weixinLabel];
        [self.weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.weiXinHaoYouBtn.mas_centerX);
            make.top.mas_equalTo(self.weiXinHaoYouBtn.mas_bottom).offset(9 * ratio);
        }];
        shareNumber += 1;
    }

    if ([OpenShare isQQInstalled]) {
        [self addSubview:self.QQHaoYouBtn];
        [self addSubview:self.QQLabel];
        [self.QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.QQHaoYouBtn.mas_centerX);
            make.top.mas_equalTo(self.QQHaoYouBtn.mas_bottom).offset(9 * ratio);

        }];
        shareNumber += 1;
    }
    [self addSubview:self.emailBtn];
    [self addSubview:self.emailLabel];
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.emailBtn.mas_centerX);
        make.top.mas_equalTo(self.emailBtn.mas_bottom).offset(9 * ratio);

    }];
    [self addSubview:self.upLine];
    [self addSubview:self.downLine];
}

- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 187, screenWidth, 55)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#f94f37"] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

- (UIButton *)weiXinHaoYouBtn{
    if (_weiXinHaoYouBtn == nil) {
        _weiXinHaoYouBtn = [[UIButton alloc]initWithFrame:CGRectMake(18, 75, 63, 63)];
        [_weiXinHaoYouBtn setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    }
    return _weiXinHaoYouBtn;
}

- (UILabel *)weixinLabel{
    if (_weixinLabel == nil) {
        _weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 147, 50, 15)];
        _weixinLabel.text = @"微信";
        _weixinLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _weixinLabel.textAlignment = NSTextAlignmentCenter;
        _weixinLabel.font = [UIFont systemFontOfSize:14];
    }
    return _weixinLabel;
}

- (UIButton *)QQHaoYouBtn{
    if (_QQHaoYouBtn == nil) {
        _QQHaoYouBtn = [[UIButton alloc]initWithFrame:CGRectMake(18 + shareNumber * 91, 75, 63, 63)];
        [_QQHaoYouBtn setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    }
    return _QQHaoYouBtn;
}
- (UILabel *)QQLabel{
    if (_QQLabel == nil) {
        _QQLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 147, 50, 15)];
        _QQLabel.text = @"QQ";
        _QQLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _QQLabel.textAlignment = NSTextAlignmentCenter;
        _QQLabel.font = [UIFont systemFontOfSize:14];;
    }
    return _QQLabel;
}

- (UIButton *)emailBtn{
    if (_emailBtn == nil) {
        _emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(18 + shareNumber * 91, 75, 63, 63)];
        [_emailBtn setBackgroundImage:[UIImage imageNamed:@"Mail"] forState:UIControlStateNormal];
    }
    return _emailBtn;
}
- (UILabel *)emailLabel{
    if (_emailLabel == nil) {
        _emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 147, 50, 15)];
        _emailLabel.text = @"邮件";
        _emailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _emailLabel.textAlignment = NSTextAlignmentCenter;
        _emailLabel.font = [UIFont systemFontOfSize:14];

    }
    return _emailLabel;
}
- (UILabel *)shareToLabel{
    if (_shareToLabel == nil) {
        _shareToLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, screenWidth, 55)];
        _shareToLabel.text = @"分享到";
        _shareToLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _shareToLabel.font = [UIFont systemFontOfSize:14];
    }
    return _shareToLabel;
}

- (UIView *)upLine{
    if (_upLine == nil) {
        _upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 55, screenWidth, 1)];
        _upLine.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    }
    return _upLine;
}

- (UIView *)downLine{
    if (_downLine == nil) {
        _downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 187, screenWidth, 1)];
        _downLine.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    }
    return _downLine;
}

@end
