//
//  RegisterVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "RegisterVC.h"
#import "LMJKeyboardShowHiddenNotificationCenter.h"
#import "JKCountDownButton.h"
#import "SCRegularExpressions.h"
@interface RegisterVC ()<UITextFieldDelegate, LMJKeyboardShowHiddenNotificationCenterDelegate>

@property(nonatomic,strong) UIView *backRimView;
@property(nonatomic,strong) UIImageView *portraitImage;
@property(nonatomic,strong) UITextField *userNameTF;
@property(nonatomic,strong) UIImageView *iconUserNameImageView;
@property(nonatomic,strong) UITextField *phoneNumberTF;
@property(nonatomic,strong) UIImageView *iconPhoneNumberImageView;
@property(nonatomic,strong) UITextField *captchaTF;
@property(nonatomic,strong) UIImageView *iconCaptchaImageView;
@property(nonatomic,strong) UIButton *checkboxButton;
@property(nonatomic,strong) UIView *lineViewUserName;
@property(nonatomic,strong) UIView *lineViewPhone;
@property(nonatomic,strong) UIView *lineViewCaptcha;
@property(nonatomic,strong) JKCountDownButton *captchaBtn;
@property(nonatomic,strong) UILabel *reTip;
@property(nonatomic,strong) UIButton *reOK;
@property(nonatomic,strong) UILabel *fuWuXieYi;
@property(nonatomic,strong) UIImage *userImage;
@end

@implementation RegisterVC

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _userImage = image;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // 设置代理
    [LMJKeyboardShowHiddenNotificationCenter defineCenter].delegate = self;
    [self setUpUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)checkBoxBtnPressed{
    self.checkboxButton.selected = !self.checkboxButton.selected;
}

#pragma mark-获取验证码
- (void)getMyCaptcha{
    BOOL isPhoneNumber = [SCRegularExpressions validateMobile:self.phoneNumberTF.text];
    if (isPhoneNumber) {
        [Networking huoQuYZM:self.phoneNumberTF.text successBlock:^{
            NSLog(@"验证码获取成功");
        } failBlock:^(NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
    }else{
        NSLog(@"手机号格式不对");
    }
}

#pragma MARK-注册
- (void)registerUser{
    Employees *emp = [[Employees alloc]init];
    emp.userName = self.userNameTF.text;
    emp.phone_number = self.phoneNumberTF.text;
    emp.captcha = self.captchaTF.text;
    [Networking zhuCe:emp successBlock:^(NSArray *arr) {
        EmployeeM *employee = arr[0];
        TokensM *tokens = arr[1];
        [Verify saveToken:tokens];
        NSLog(@"注册成功");
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];

}

#pragma mark-键盘遮挡
- (void)showOrHiddenKeyboardWithHeight:(CGFloat)height withDuration:(CGFloat)animationDuration isShow:(BOOL)isShow{
    //    [UIView animateWithDuration:animationDuration animations:^{
    //        [self.phoneNumberTF setFrame:CGRectMake(self.phoneNumberTF.frame.origin.x, [UIScreen mainScreen].bounds.size.height -30 -height, self.phoneNumberTF.frame.size.width, self.phoneNumberTF.frame.size.height)];
    //    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark-页面设置
- (void)setUpUI{
    self.navigationItem.title = @"注册";
    __weak typeof (self) weakSelf = self;
    [self.view addSubview:self.backRimView];
    [self.backRimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(124.5 * ratio);
        make.height.mas_equalTo(129 * ratio);
        make.width.mas_equalTo(104 * ratio);
        make.centerX.mas_equalTo(weakSelf.view);
    }];
    [self.view addSubview:self.portraitImage];
    [self.portraitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100 * ratio);
        make.height.mas_equalTo(125 * ratio);
        make.top.mas_equalTo(weakSelf.backRimView).offset(2 * ratio);
        make.centerX.mas_equalTo(weakSelf.view);
    }];
    [self.view addSubview:self.userNameTF];
    [self.userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.backRimView.mas_bottom).offset(41 * ratio);
        make.left.mas_equalTo(96 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-32);
        make.height.mas_equalTo(45 * ratio);
    }];
    [self.view addSubview:self.iconUserNameImageView];
    [self.iconUserNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(32);
        make.top.mas_equalTo(weakSelf.userNameTF.mas_top);
        make.right.mas_equalTo(weakSelf.userNameTF.mas_left).offset(-16 * ratio);
        make.height.mas_equalTo(45 * ratio);
    }];
    [self.view addSubview:self.phoneNumberTF];
    [self.phoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.userNameTF);
        make.height.mas_equalTo(45 * ratio);
        make.top.mas_equalTo(weakSelf.userNameTF.mas_bottom);
        make.left.mas_equalTo(weakSelf.userNameTF);
    }];
    [self.view addSubview:self.iconPhoneNumberImageView];
    [self.iconPhoneNumberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(32);
        make.top.mas_equalTo(weakSelf.iconUserNameImageView.mas_bottom);
        make.right.mas_equalTo(weakSelf.phoneNumberTF.mas_left).offset(-16 * ratio);
        make.height.mas_equalTo(45 * ratio);
    }];
    [self.view addSubview:self.captchaTF];
    [self.captchaTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45 * ratio);
        make.top.mas_equalTo(weakSelf.phoneNumberTF.mas_bottom);
        make.left.mas_equalTo(weakSelf.phoneNumberTF);
        make.right.mas_equalTo(weakSelf.view).offset(-147 * ratio);
    }];
    [self.view addSubview:self.iconCaptchaImageView];
    [self.iconCaptchaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(32);
        make.top.mas_equalTo(weakSelf.phoneNumberTF.mas_bottom);
        make.right.mas_equalTo(weakSelf.captchaTF.mas_left).offset(-16 * ratio);
        make.height.mas_equalTo(45 * ratio);
    }];
    [self.view addSubview:self.lineViewUserName];
    [self.lineViewUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.userNameTF.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(weakSelf.view).offset(32);
        make.right.mas_equalTo(weakSelf.view).offset(-32);
    }];
    [self.view addSubview:self.lineViewPhone];
    [self.lineViewPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.phoneNumberTF.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.equalTo(weakSelf.view).offset(32);
        make.right.mas_equalTo(weakSelf.view).offset(-32);
    }];
    [self.view addSubview:self.lineViewCaptcha];
    [self.lineViewCaptcha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.captchaTF.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo (weakSelf.view).offset(32);
        make.right.mas_equalTo(weakSelf.view).offset(-32);
    }];
    [self.view addSubview:self.fuWuXieYi];
    [self.fuWuXieYi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.lineViewCaptcha.mas_left).offset(22 * ratio);
        make.height.mas_equalTo(12 * ratio);
        make.top.mas_equalTo(weakSelf.captchaTF.mas_bottom).offset(12 * ratio);
    }];
    [self.view addSubview:self.captchaBtn];
    [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(115 * ratio);
        make.height.mas_equalTo(32 * ratio);
        make.right.mas_equalTo(weakSelf.phoneNumberTF.mas_right);
        make.centerY.mas_equalTo(weakSelf.captchaTF.mas_centerY);
    }];
    [self.view addSubview:self.reTip];
    [self.reTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.view).offset(-20 * ratio);
    }];
    [self.view addSubview:self.checkboxButton];
    [self.checkboxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(12 * ratio);
        make.top.mas_equalTo(weakSelf.lineViewCaptcha.mas_bottom).offset(12 * ratio);
        make.right.mas_equalTo(weakSelf.fuWuXieYi.mas_left).offset(-10 * ratio);
    }];
    [self.view addSubview:self.reOK];
    [self.reOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(32 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-32 * ratio);
        make.height.mas_equalTo(45 * ratio);
        make.top.mas_equalTo(weakSelf.fuWuXieYi.mas_bottom).offset(50 * ratio);
    }];
}









#pragma mark-控件设定
- (UIView *)backRimView{
    if (_backRimView == nil) {
        _backRimView = [[UIView alloc]init];
        _backRimView.layer.borderWidth = 1.0;
        _backRimView.layer.borderColor = [UIColor colorWithHexString:@"#01c872"].CGColor;
        _backRimView.layer.cornerRadius = 12.0;
    }
    return _backRimView;
}

- (UIImageView *)portraitImage{
    if (_portraitImage == nil) {
        _portraitImage = [[UIImageView alloc]initWithImage:_userImage];
        _portraitImage.layer.cornerRadius = 10;
        _portraitImage.layer.masksToBounds = YES;
        _portraitImage.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImage.userInteractionEnabled = YES;
        _portraitImage.image = [UIImage imageNamed:@"default_touxiang"];
    }
    return _portraitImage;
}

- (UITextField *)userNameTF{
    if (_userNameTF == nil) {
        _userNameTF = [[UITextField alloc]init];
        NSString *holderText = @"真实姓名";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHexString:@"#999999"]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:15]
                            range:NSMakeRange(0, holderText.length)];
        _userNameTF.attributedPlaceholder = placeholder;

        _userNameTF.returnKeyType = UIReturnKeyDone;
        _userNameTF.delegate = self;
    }
    return _userNameTF;
}

- (UIImageView *)iconUserNameImageView{
    if (_iconUserNameImageView == nil) {
        _iconUserNameImageView = [[UIImageView alloc]init];
        [_iconUserNameImageView setImage:[UIImage imageNamed:@"icon_user"]];
    }
    return  _iconUserNameImageView;
}

- (UITextField *)phoneNumberTF{
    if (_phoneNumberTF == nil) {
        _phoneNumberTF = [[UITextField alloc]init];
        NSString *holderText = @"手机号码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHexString:@"#999999"]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:15]
                            range:NSMakeRange(0, holderText.length)];
        _phoneNumberTF.attributedPlaceholder = placeholder;

        _phoneNumberTF.returnKeyType = UIReturnKeyDone;
        _phoneNumberTF.delegate = self;
    }
    return _phoneNumberTF;
}

- (UIImageView *)iconPhoneNumberImageView{
    if (_iconPhoneNumberImageView == nil) {
        _iconPhoneNumberImageView = [[UIImageView alloc]init];
        [_iconPhoneNumberImageView setImage:[UIImage imageNamed:@"icon_phone"]];
    }
    return _iconPhoneNumberImageView;
}

- (UITextField *)captchaTF{
    if (_captchaTF == nil) {
        _captchaTF = [[UITextField alloc]init];
        _captchaTF.returnKeyType = UIReturnKeyDone;
        NSString *holderText = @"验证码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHexString:@"#999999"]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:15]
                            range:NSMakeRange(0, holderText.length)];
        _captchaTF.attributedPlaceholder = placeholder;
        _captchaTF.delegate = self;
    }
    return _captchaTF;
}

- (UIImageView *)iconCaptchaImageView{
    if (_iconCaptchaImageView == nil) {
        _iconCaptchaImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_text"]];
    }
    return _iconCaptchaImageView;
}

- (UIButton *)checkboxButton{
    if (_checkboxButton == nil) {
        _checkboxButton = [[UIButton alloc]init];
        [_checkboxButton setImage:[UIImage imageNamed:@"checkbox_nor"] forState:UIControlStateSelected];
        [_checkboxButton setImage:[UIImage imageNamed:@"checkbox_sel"] forState:UIControlStateNormal];
        [_checkboxButton addTarget:self action:@selector(checkBoxBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkboxButton;
}

- (UIView *)lineViewUserName{
    if (_lineViewUserName == nil) {
        _lineViewUserName = [[UIView alloc]init];
        _lineViewUserName.backgroundColor = [UIColor colorWithHexString:@"#01c872"];
    }
    return _lineViewUserName;
}

- (UIView *)lineViewPhone{
    if (_lineViewPhone == nil) {
        _lineViewPhone = [[UIView alloc]init];
        _lineViewPhone.backgroundColor  = [UIColor colorWithHexString:@"#01c872"];
    }
    return _lineViewPhone;
}

- (UIView *)lineViewCaptcha{
    if (_lineViewCaptcha == nil) {
        _lineViewCaptcha = [[UIView alloc]init];
        _lineViewCaptcha.backgroundColor = [UIColor colorWithHexString:@"#01c872"];
    }
    return _lineViewCaptcha;
}

- (UIButton *)captchaBtn{
    if (_captchaBtn == nil) {
        _captchaBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        [_captchaBtn setBackgroundImage:[UIImage imageNamed:@"button_get_nor"] forState:UIControlStateNormal];
        [_captchaBtn setBackgroundImage:[UIImage imageNamed:@"button_get_dis"] forState:UIControlStateDisabled];
        [_captchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_captchaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _captchaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _captchaBtn.layer.cornerRadius = 47;
        [_captchaBtn addTarget:self action:@selector(getMyCaptcha) forControlEvents:UIControlEventTouchUpInside];
        [_captchaBtn countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
            sender.enabled = NO;
            [sender startCountDownWithSecond:60];
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"点击重新获取";
            }];
        }];
    }
    return _captchaBtn;
}

- (UILabel *)reTip{
    if (_reTip == nil) {
        _reTip = [[UILabel alloc]init];
        _reTip.font = [UIFont systemFontOfSize:12];
        _reTip.text = @"每部手机每天只可以获取三次验证码，暂时先这样";
        _reTip.textAlignment = NSTextAlignmentCenter;
        _reTip.textColor = [UIColor colorWithHexString:@"#999999"];
        _reTip.lineBreakMode = NSLineBreakByWordWrapping;
        _reTip.numberOfLines = 0;
    }
    return _reTip;
}

- (UIButton *)reOK{
    if (_reOK == nil) {
        _reOK = [[UIButton alloc]init];
        [_reOK setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_reOK setTitle:@"注册" forState:UIControlStateNormal];
        _reOK.titleLabel.font = [UIFont systemFontOfSize:14];
        [_reOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reOK addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reOK;
}

- (UILabel *)fuWuXieYi{
    if (_fuWuXieYi == nil) {
        _fuWuXieYi = [[UILabel alloc]init];
        _fuWuXieYi.text = @"同意《上朝啦》服务条款 和 隐私条款";
        _fuWuXieYi.font = [UIFont systemFontOfSize:12];
        _fuWuXieYi.textColor = [UIColor colorWithHexString:@"#999999"];
        _fuWuXieYi.textAlignment = NSTextAlignmentCenter;
        _fuWuXieYi.lineBreakMode = NSLineBreakByWordWrapping;
        _fuWuXieYi.numberOfLines = 0;

    }
    return _fuWuXieYi;
}

@end
