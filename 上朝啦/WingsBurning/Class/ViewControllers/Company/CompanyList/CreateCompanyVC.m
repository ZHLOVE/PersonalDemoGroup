//
//  CreateCompanyVC.m
//  WingsBurning
//
//  Created by MBP on 2016/12/12.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CreateCompanyVC.h"
#import "ShareVC.h"
@interface CreateCompanyVC ()

@property(nonatomic,strong) UIImageView *emailImgView;
@property(nonatomic,strong) UIButton *urlBtn;
@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UILabel *huoLabel;
@property(nonatomic,strong) UIButton *copyBtn;
@property(nonatomic,strong) UIButton *hrBtn;
@property(nonatomic,strong) UIView *leftLine;
@property(nonatomic,strong) UIView *rightLine;


@end

UIImage *shareImage,*shareThumbImage;


@implementation CreateCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setUpUI];
    shareImage = [UIImage imageNamed:@"icon_logo"];
    shareThumbImage = [UIImage imageNamed:@"icon_logo"];
}

/**
 * 复制剪贴板
 */
- (void)copylinkBtnClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.urlBtn.titleLabel.text;
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [hud setMode:MBProgressHUDModeText];
    NSString *str = [NSString stringWithFormat:@"网址已复制"];
    hud.label.text = str;
    [hud hideAnimated:YES afterDelay:1.5];
}



- (void)joinHrBtnPressed{
    ShareVC *sVC = [[ShareVC alloc]init];
    sVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:sVC animated:NO completion:nil];
}


- (void)setUpUI{
    __weak typeof(self) weakSelf = self;
    self.navigationItem.title = @"创建公司";
    [self.view addSubview:self.emailImgView];
    [self.view addSubview:self.urlBtn];
    [self.view addSubview:self.copyBtn];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.urlBtn.mas_centerY);
        make.right.mas_equalTo(weakSelf.urlBtn.mas_right).offset(-24 * ratio);
    }];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.urlBtn.mas_bottom).offset(14 * ratio);
        make.centerX.mas_equalTo(weakSelf.view);
    }];
//    NSString *shareEnable =  [Verify getShareEnable];
//    if ([shareEnable isEqualToString:@"开启"]) {
        [self.view addSubview:self.huoLabel];
        [self.huoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.tipLabel.mas_bottom).offset(36 * ratio);
            make.centerX.mas_equalTo(weakSelf.view);
        }];
        [self.view addSubview:self.leftLine];
        [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(152 * ratio);
            make.height.mas_equalTo(1);
            make.centerY.mas_equalTo(weakSelf.huoLabel.mas_centerY);
            make.left.mas_equalTo(weakSelf.view).offset(18 * ratio);
        }];
        [self.view addSubview:self.rightLine];
        [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(152 * ratio);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(weakSelf.view).offset(-18 * ratio);
            make.centerY.mas_equalTo(weakSelf.huoLabel.mas_centerY);
        }];
        [self.view addSubview:self.hrBtn];
        [self.hrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.huoLabel.mas_bottom).offset(30 * ratio);
            make.width.mas_equalTo(weakSelf.urlBtn);
            make.height.mas_equalTo(weakSelf.urlBtn);
            make.centerX.mas_equalTo(weakSelf.view);
        }];
//    }
}

- (UIImageView *)emailImgView{
    if (_emailImgView == nil) {
        _emailImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 56, screenWidth, 160)];
        _emailImgView.image = [UIImage imageNamed:@"email"];
        _emailImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _emailImgView;
}

- (UIButton *)urlBtn{
    if (_urlBtn == nil) {
        _urlBtn = [[UIButton alloc]initWithFrame:CGRectMake(18, 160+56+66, screenWidth-36, 44)];
        _urlBtn.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        _urlBtn.layer.borderWidth = 1;
        _urlBtn.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
        _urlBtn.layer.cornerRadius = 22;
        _urlBtn.layer.masksToBounds = YES;
        [_urlBtn setTitle:@"https://hr.shangchao.la" forState:UIControlStateNormal];
        [_urlBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _urlBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _urlBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_urlBtn addTarget:self action:@selector(copylinkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _urlBtn;
}

- (UIButton *)copyBtn{
    if (_copyBtn == nil) {
        _copyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
        [_copyBtn setImage:[UIImage imageNamed:@"img_copy"] forState:UIControlStateNormal];
        [_copyBtn addTarget:self action:@selector(copylinkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyBtn;
}

- (UILabel *)tipLabel{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 14)];
        _tipLabel.text = @"在电脑浏览器打开该网址，创建公司";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _tipLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tipLabel;
}

- (UILabel *)huoLabel{
    if (_huoLabel == nil) {
        _huoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        _huoLabel.text = @"或";
        _huoLabel.textAlignment = NSTextAlignmentCenter;
        _huoLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _huoLabel.font = [UIFont systemFontOfSize:14];
    }
    return _huoLabel;
}

- (UIView *)leftLine{
    if (_leftLine == nil) {
        _leftLine = [[UIView alloc]init];
        _leftLine.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    }
    return _leftLine;
}

- (UIView *)rightLine{
    if (_rightLine == nil) {
        _rightLine = [[UIView alloc]init];
        _rightLine.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9"];
    }
    return _rightLine;
}

- (UIButton *)hrBtn{
    if (_hrBtn == nil) {
        _hrBtn = [[UIButton alloc]init];
        _hrBtn.layer.borderWidth = 1;
        _hrBtn.layer.borderColor = [UIColor colorWithHexString:@"#01c36d"].CGColor;
        _hrBtn.layer.cornerRadius = 22;
        [_hrBtn setTitle:@"邀请HR创建公司" forState:UIControlStateNormal];
        _hrBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_hrBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_hrBtn addTarget:self action:@selector(joinHrBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hrBtn;
}


@end
