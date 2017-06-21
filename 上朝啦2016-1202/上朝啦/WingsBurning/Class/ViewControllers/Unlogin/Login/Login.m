//
//  Login.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Login.h"
#import "RegisterCameraVC.h"
#import "GuideVC.h"
#import "JKCountDownButton.h"
#import "ZYKeyboardUtil.h"
#import "MainVC.h"

#define MARGIN_KEYBOARD 20
@interface Login()<UITextFieldDelegate>

@property(nonatomic,strong) UIBarButtonItem *leftBtn;
@property(nonatomic,strong) UIBarButtonItem *rightBtn;
@property(nonatomic,strong) UIView *backRimView;
@property(nonatomic,strong) UIImageView *portraitImage;
@property(nonatomic,strong) UITextField *phoneNumberTF;
@property(nonatomic,strong) UIImageView *iconPhoneNumberImageView;
@property(nonatomic,strong) UITextField *captchaTF;
@property(nonatomic,strong) UIImageView *iconCaptchaImageView;
@property(nonatomic,strong) UIView *lineViewPhone;
@property(nonatomic,strong) UIView *lineViewCaptcha;
@property(nonatomic,strong) JKCountDownButton *captchaBtn;
@property(nonatomic,strong) UILabel *loginTip;
@property(nonatomic,strong) UIButton *loginOK;

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;



@end

@implementation Login


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpUI];
    [self configKeyBoardRespond];
    [self checkVersion];
}

- (void)checkVersion{
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSLog(@"最新版本%@",version);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [userDefault objectForKey:@"lastOpenVersion"];
    NSLog(@"上次版本%@",lastVersion);
    if (![version isEqualToString:lastVersion]) {
        [userDefault setObject:version forKey:@"lastOpenVersion"];
        [userDefault synchronize];// 保存一下
        GuideVC *guide = [[GuideVC alloc]init];
        [self presentViewController:guide animated:NO completion:^{

        }];
    }
}



/**为了隐藏导航栏返回按钮*/
- (void)leftBtnPressed{

}

#pragma mark - 注册
- (void)registerBtnPressed{
    [Verify setFirstCapture:YES];//用于CaptureImage里人脸检测通过时判断
    RegisterCameraVC *cam = [[RegisterCameraVC alloc]init];
    cam.firstPunch = YES;
    cam.changeFace = NO;
    [self.navigationController pushViewController:cam animated:true];
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];
     __weak typeof (self) weakSelf = self;
#pragma mark - 全自动键盘弹出/收起处理 
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf.navigationController adaptiveView:weakSelf.phoneNumberTF,weakSelf.captchaTF,nil];
    }];
#pragma mark - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
    }];
}

#pragma mark - 限制输入长度11位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 11;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark-获取验证码
- (void)getMyCaptcha{
    BOOL isPhoneNumber = [CheckDataTool checkForMobilePhoneNo:self.phoneNumberTF.text];
    if (isPhoneNumber) {
        [Networking huoQuYZM:self.phoneNumberTF.text action:@"login" successBlock:^{
            NSLog(@"获取成功");
        } failBlock:^(NSInteger statusCode,NSString *errStr) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setMode:MBProgressHUDModeText];
            [hud setCenter:self.view.center];
            [hud setLabelText:errStr];
            [hud hide:YES afterDelay:1.2];
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setCenter:self.view.center];
        [hud setLabelText:@"手机格式错误"];
        [hud hide:YES afterDelay:1.2];
    }
}
#pragma mark-登录
- (void)loginUser{
    BOOL isPhoneNumber = [CheckDataTool checkForMobilePhoneNo:self.phoneNumberTF.text];
    if (isPhoneNumber) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        [hud setLabelText:@"登录中"];
        [Networking dengLu:self.phoneNumberTF.text yanZhenMa:self.captchaTF.text successBlock:^(NSArray *arr) {
            EmployeeM *employee = arr[0];
            TokensM *tokens = arr[1];
            [Verify saveToken:tokens];
            [Verify saveEmployee:employee];
            [hud hide:YES];
            MainVC *mainvc = self.navigationController.viewControllers[0];
            [mainvc getHeadViewInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failBlock:^(NSInteger statusCode,NSString *errStr) {
            [hud setMode:MBProgressHUDModeText];
            [hud setCenter:self.view.center];
            [hud setLabelText:NSLocalizedString(errStr, @"")];
            [hud hide:YES afterDelay:1.0];
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setCenter:self.view.center];
        [hud setLabelText:@"手机格式错误"];
        [hud hide:YES afterDelay:1.2];
    }
}

#pragma mark-布局设定
- (void)setUpUI{
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;//禁用原来的手势
    self.navigationItem.title = @"登录";
    __weak typeof (self) weakSelf = self;
    [self.view addSubview:self.backRimView];
    [self.backRimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(60.5 * ratio);
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
    [self.view addSubview:self.phoneNumberTF];
    [self.phoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.backRimView.mas_bottom).offset(41 * ratio);
        make.left.mas_equalTo(96 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-32);
        make.height.mas_equalTo(45 * ratio);
    }];
    [self.view addSubview:self.iconPhoneNumberImageView];
    [self.iconPhoneNumberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(32);
        make.top.mas_equalTo(weakSelf.phoneNumberTF.mas_top);
        make.right.mas_equalTo(weakSelf.phoneNumberTF.mas_left).offset(-16 * ratio);
        make.height.mas_equalTo(45 * ratio);
    }];
    [self.view addSubview:self.captchaTF];
    [self.captchaTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45 * ratio);
        make.top.mas_equalTo(_phoneNumberTF.mas_bottom);
        make.left.mas_equalTo(_phoneNumberTF);
        make.right.mas_equalTo(weakSelf.view).offset(-147 * ratio);
    }];
    [self.view addSubview:self.iconCaptchaImageView];
    [self.iconCaptchaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(32);
        make.top.mas_equalTo(weakSelf.iconPhoneNumberImageView.mas_bottom);
        make.right.mas_equalTo(weakSelf.captchaTF.mas_left).offset(-16 * ratio);
        make.height.mas_equalTo(45 * ratio);
    }];
    [self.view addSubview:self.captchaBtn];
    [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(115 * ratio);
        make.height.mas_equalTo(32 * ratio);
        make.right.mas_equalTo(weakSelf.phoneNumberTF.mas_right);
        make.centerY.mas_equalTo(weakSelf.captchaTF.mas_centerY);
    }];
    [self.view addSubview:self.lineViewPhone];
    [self.lineViewPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.phoneNumberTF.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(weakSelf.view).offset(32 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-32 * ratio);
    }];
    [self.view addSubview:self.lineViewCaptcha];
    [self.lineViewCaptcha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.captchaTF.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(weakSelf.view).offset(32 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-32 * ratio);
    }];
    [self.view addSubview:self.loginTip];
    [self.loginTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconCaptchaImageView.mas_left);
        make.top.mas_equalTo(weakSelf.lineViewCaptcha.mas_bottom).offset(12 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-32 * ratio);
    }];
    [self.view addSubview:self.loginOK];
    [self.loginOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(32 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-32 * ratio);
        make.height.mas_equalTo(45 * ratio);
        make.top.mas_equalTo(weakSelf.loginTip.mas_bottom).offset(50 * ratio);
    }];
}


#pragma mark-控件设定
- (UIBarButtonItem *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage new] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnPressed)];
    }
    return _leftBtn;
}

- (UIBarButtonItem *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerBtnPressed)];
    }
    return _rightBtn;
}

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
        _portraitImage = [[UIImageView alloc]init];
        _portraitImage.layer.cornerRadius = 10;
        _portraitImage.layer.masksToBounds = YES;
        _portraitImage.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImage.userInteractionEnabled = YES;
        [_portraitImage setImage:[UIImage imageNamed:@"default_touxiang"]];
        EmployeeM *employee = [Verify getEmployeeFromSandBox];
        if (employee.avatar_url != nil) {
            [_portraitImage sd_setImageWithURL:[NSURL URLWithString:employee.avatar_url]];
        }
    }
    return _portraitImage;
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
                            value:[UIFont systemFontOfSize:15]
                            range:NSMakeRange(0, holderText.length)];
        _phoneNumberTF.attributedPlaceholder = placeholder;
        _phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        _captchaTF.keyboardType = UIKeyboardTypeNumberPad;
        NSString *holderText = @"验证码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHexString:@"#999999"]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:15]
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

- (UIView *)lineViewPhone{
    if (_lineViewPhone == nil) {
        _lineViewPhone = [[UIView alloc]init];
        _lineViewPhone.backgroundColor  = [UIColor colorWithHexString:@"01c872"];
    }
    return _lineViewPhone;
}

- (UIView *)lineViewCaptcha{
    if (_lineViewCaptcha == nil) {
        _lineViewCaptcha = [[UIView alloc]init];
        _lineViewCaptcha.backgroundColor = [UIColor colorWithHexString:@"01c872"];
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
            //判断正则表达式
            BOOL isPhoneNumber = [CheckDataTool checkForMobilePhoneNo:self.phoneNumberTF.text];
            if (isPhoneNumber) {
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
            }

        }];
    }
    return _captchaBtn;
}

- (UILabel *)loginTip{
    if (_loginTip == nil) {
        _loginTip = [[UILabel alloc]init];
        _loginTip.font = [UIFont systemFontOfSize:12];
        _loginTip.text = @"每部手机每天只可以获取三次验证码，请谨慎使用。";
        _loginTip.textAlignment = NSTextAlignmentLeft;
        _loginTip.textColor = [UIColor colorWithHexString:@"#999999"];
        _loginTip.lineBreakMode = NSLineBreakByWordWrapping;
        [_loginTip setNumberOfLines:0];
        [_loginTip sizeToFit];
    }
    return _loginTip;
}

- (UIButton *)loginOK{
    if (_loginOK == nil) {
        _loginOK = [[UIButton alloc]init];
        [_loginOK setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_loginOK setTitle:@"登录" forState:UIControlStateNormal];
        _loginOK.titleLabel.font = [UIFont systemFontOfSize:14];
        [_loginOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginOK addTarget:self action:@selector(loginUser) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginOK;
}
@end




