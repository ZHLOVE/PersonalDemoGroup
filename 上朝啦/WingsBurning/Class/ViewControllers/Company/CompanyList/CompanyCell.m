//
//  CompanyCell.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CompanyCell.h"

@interface CompanyCell()

@property(nonatomic,strong) UITextView *cpName;
@property(nonatomic,strong) UILabel *cpState;
@property(nonatomic,strong) UIImageView *cpStateIcon;
@property(nonatomic,strong) UIImageView *cpLogoImgView;

@end

@implementation CompanyCell

- (void)setEmployer:(EmployerM *)employer{
    _cpName.text = employer.name;
    if ([employer.name isEqualToString:@"测试公司"]) {
        _cpName.font = [UIFont boldSystemFontOfSize:15 * ratio];
    }

    if ([employer.is_verified isEqualToString:@"1"] ) {
        _cpState.text = @"已验证";
        [_cpStateIcon setImage:[UIImage imageNamed:@"icon_authen"]];
    }else{
        _cpState.text = @"未验证";
        [_cpStateIcon setImage:[UIImage imageNamed:@"icon_unauthen"]];
    }
    if (employer.image_url != nil) {
        [_cpLogoImgView sd_setImageWithURL:[NSURL URLWithString:employer.image_url]];
    }
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
    [self.contentView addSubview:self.cpLogoImgView];
    [self.contentView addSubview:self.cpName];
    [self.contentView addSubview:self.cpStateIcon];
    [self.contentView addSubview:self.cpState];
    [self.contentView addSubview:self.joinComBtn];
}


#pragma mark-控件设置
#pragma mark - 重构该页面

- (UITextView *)cpName{
    if (_cpName == nil) {
        _cpName = [[UITextView alloc]init];
        _cpName.frame = CGRectMake(64 * ratio, 13 * ratio, screenWidth - self.joinComBtn.frame.size.width - 88 * ratio, 44 * ratio);
        _cpName.font = [UIFont systemFontOfSize:15 * ratio];
        _cpName.textColor = [UIColor colorWithHexString:@"#666666"];
        _cpName.userInteractionEnabled = NO;
        _cpName.text = @"无锡乐骐科技有限公司在恒华科技园二十号楼四零七办公室";
    }
    return _cpName;
}

- (UILabel *)cpState{
    if (_cpState == nil) {
        _cpState = [[UILabel alloc]init];
        _cpState.frame = CGRectMake(self.cpStateIcon.frame.size.width + 80 * ratio, 55 * ratio, 100, 12);
        _cpState.textAlignment = NSTextAlignmentLeft;
        _cpState.font = [UIFont systemFontOfSize:12 * ratio];
        _cpState.textColor = [UIColor colorWithHexString:@"#666666"];
        _cpState.text = @"未验证";    }
    return _cpState;
}

- (UIImageView *)cpStateIcon{
    if (_cpStateIcon == nil) {
        _cpStateIcon = [[UIImageView alloc]init];
        _cpStateIcon.frame = CGRectMake(70 * ratio, 55 * ratio, 11 * ratio, 12 * ratio);
    }
    return _cpStateIcon;
}

- (UIImageView *)cpLogoImgView{
    if (_cpLogoImgView == nil) {
        _cpLogoImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_logo"]];
        _cpLogoImgView.frame = CGRectMake(18 * ratio, 25 * ratio, 40 * ratio, 40 * ratio);
        _cpLogoImgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _cpLogoImgView;
}

- (UIButton *)joinComBtn{
    if (_joinComBtn == nil) {
        _joinComBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _joinComBtn.frame = CGRectMake(280 * ratio, 25 * ratio, 75 * ratio, 39 * ratio);
        _joinComBtn.layer.borderWidth = 1.0;
        _joinComBtn.layer.borderColor = [UIColor colorWithHexString:@"#01c872"].CGColor;
        _joinComBtn.layer.cornerRadius = 18 * ratio;
        _joinComBtn.layer.masksToBounds = YES;
        [_joinComBtn setTitle:@"加入" forState:UIControlStateNormal];
        [_joinComBtn setTitleColor:[UIColor colorWithHexString:@"#01c872"] forState:UIControlStateNormal];
    }
    return _joinComBtn;
}

@end














