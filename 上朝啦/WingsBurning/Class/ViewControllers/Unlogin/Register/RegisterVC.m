//
//  RegisterVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "RegisterVC.h"
#import "JKCountDownButton.h"
#import "ZYKeyboardUtil.h"
#import "M80AttributedLabel.h"
#import "WebVC.h"
#import "CompanyListTableView.h"

@interface RegisterVC ()<UITextFieldDelegate,M80AttributedLabelDelegate>

@property(nonatomic,strong) UIImageView *portraitImage;
@property(nonatomic,strong) UIView *backRimView;
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
@property(nonatomic,strong) M80AttributedLabel *fuWuXieYi;

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;


@end

@implementation RegisterVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userImage = [[UIImage alloc]init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // 设置代理
    [self setUpUI];
    [self configKeyBoardRespond];

}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];
    __weak typeof (self) weakSelf = self;
#pragma mark - 全自动键盘弹出/收起处理
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf.navigationController adaptiveView:weakSelf.userNameTF,weakSelf.phoneNumberTF,weakSelf.captchaTF,nil];
    }];
#pragma mark - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
    }];
}


#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneNumberTF becomeFirstResponder];
    return YES;
}
#pragma mark - 限制输入长度11位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneNumberTF) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 11;
    }else if (textField == self.captchaTF){
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;

        return newLength <= 6;
    }
    return YES;
}

#pragma mark - 长度为6收起键盘
- (void)textFieldDidChange{
    if (self.captchaTF.text.length == 6) {
        [self.captchaTF resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)checkBoxBtnPressed{
    self.checkboxButton.selected = !self.checkboxButton.selected;
    self.reOK.enabled = !self.checkboxButton.selected;
}

#pragma mark-获取验证码
- (void)getMyCaptcha{
    __weak typeof(self) weakSelf = self;
    BOOL length = ![self.userNameTF.text isEqualToString:@""] ;
    BOOL isUserName = [CheckDataTool isChinese:self.userNameTF.text];
    BOOL isPhoneNumber = [CheckDataTool checkForMobilePhoneNo:self.phoneNumberTF.text];
    if (isUserName & length) {
        if (isPhoneNumber) {
            weakSelf.captchaBtn.enabled = NO;
            [Networking huoQuYZM:self.phoneNumberTF.text action:@"register" successBlock:^{
                DLog(@"验证码获取成功");
                [self.captchaTF becomeFirstResponder];
                [weakSelf.captchaBtn startCountDownWithSecond:60];
                [weakSelf.captchaBtn countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                    NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                    return title;
                }];
                [weakSelf.captchaBtn countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                    countDownButton.enabled = YES;
                    return @"点击重新获取";
                }];
            } failBlock:^(NSInteger statusCode,NSString *errStr) {
                weakSelf.captchaBtn.enabled = YES;
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                [hud setMode:MBProgressHUDModeText];
                hud.label.text = errStr;
                [hud hideAnimated:YES afterDelay:1.5];
            }];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            [hud setMode:MBProgressHUDModeText];
            hud.label.text = @"手机格式错误";
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = @"姓名格式错误";
        [hud hideAnimated:YES afterDelay:1.5];
    }
}

#pragma mark-M80AttributedLabelDelegate
- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData
{
    NSLog(@"%@",linkData);
    NSString *str = [label.text substringWithRange:[linkData rangeValue]];
    if ([str isEqualToString:@"服务协议"]) {
        WebVC *webVC = [[WebVC alloc]initWithTitleString:str];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if ([str isEqualToString:@"隐私协议"]){
        WebVC *webVC = [[WebVC alloc]initWithTitleString:str];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}



#pragma MARK-注册
- (void)registerUser{

    BOOL length = ![self.userNameTF.text isEqualToString:@""] ;
    BOOL isUserName = [CheckDataTool isChinese:self.userNameTF.text];
    BOOL isPhoneNumber = [CheckDataTool checkForMobilePhoneNo:self.phoneNumberTF.text];
    if (isUserName & length) {
        if (isPhoneNumber) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
            hud.label.text = @"注册中";
            Employees *emp = [[Employees alloc]init];
            emp.userName = self.userNameTF.text;
            emp.phone_number = self.phoneNumberTF.text;
            emp.captcha = self.captchaTF.text;
            /**传图到七牛*/
            BOOL isHttps = TRUE;
            QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = httpsZone;
            }];
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            QNUploadOption *option = [[QNUploadOption alloc]initWithMime:@"jpeg" progressHandler:nil params:nil checkCrc:false cancellationSignal:nil];
            [Networking zhuCe:emp successBlock:^(NSArray *arr) {
                TokensM *tokens = arr[1];
                EmployeeM *employee = arr[0];
                ImageUploadToken *imgULToken = arr[2];
                [Verify saveToken:tokens];
                [Verify saveEmployee:employee];
                //image转SHA1
                NSData *imgData = UIImageJPEGRepresentation(self.portraitImage.image, 0.2);
                [upManager putData:imgData key:imgULToken.key token:imgULToken.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    NSLog(@"%@",info);
                    NSLog(@"%@",resp);
                    [hud hideAnimated:YES];
                    CompanyListTableView *com = [[CompanyListTableView alloc]init];
                    com.employee = employee;
                    com.firstRegister = YES;
                    [Verify saveEmployeeImage:imgData];
                    [self.navigationController pushViewController:com animated:YES];
                } option:option];
            } failBlock:^(NSString *error) {
                [hud setMode:MBProgressHUDModeText];
                hud.label.text = NSLocalizedString(error, @"");
                [hud hideAnimated:YES afterDelay:1.5];
            }];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            [hud setMode:MBProgressHUDModeText];
            hud.label.text = @"手机格式错误";
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = @"姓名格式错误";
        [hud hideAnimated:YES afterDelay:1.5];
    }
}


#pragma mark-页面设置
- (void)setUpUI{
    self.navigationItem.title = @"注册";
    __weak typeof (self) weakSelf = self;
    [self.view addSubview:self.backRimView];
    [self.backRimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(60.5 * ratio);
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
        make.height.mas_equalTo(30 * ratio);
        make.top.mas_equalTo(weakSelf.captchaTF.mas_bottom).offset(12 * ratio);
        make.right.mas_equalTo(weakSelf.lineViewCaptcha.mas_right);
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
        make.height.width.mas_equalTo(18 * ratio);
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
        _portraitImage.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImage.layer.cornerRadius = 10;
        _portraitImage.layer.masksToBounds = YES;
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
                            value:[UIFont systemFontOfSize:15]
                            range:NSMakeRange(0, holderText.length)];
        _userNameTF.attributedPlaceholder = placeholder;
        _userNameTF.keyboardType = UIKeyboardTypeDefault;
        _userNameTF.returnKeyType = UIReturnKeyDone;
        _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        [_captchaTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
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
       [_captchaBtn setCaptchaButtonCreated];
       [_captchaBtn addTarget:self action:@selector(getMyCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captchaBtn;
}

- (UILabel *)reTip{
    if (_reTip == nil) {
        _reTip = [[UILabel alloc]init];
        _reTip.font = [UIFont systemFontOfSize:12];
        _reTip.text = @"每部手机每天只可以获取三次验证码，请谨慎使用！";
        _reTip.textAlignment = NSTextAlignmentLeft;
        _reTip.textColor = [UIColor colorWithHexString:@"#999999"];
        _reTip.lineBreakMode = NSLineBreakByWordWrapping;
        _reTip.numberOfLines = 0;
        [_reTip sizeToFit];
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

- (M80AttributedLabel *)fuWuXieYi{
    if (_fuWuXieYi == nil) {
        _fuWuXieYi = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
        _fuWuXieYi.font = [UIFont systemFontOfSize:13];
        _fuWuXieYi.textColor = [UIColor colorWithHexString:@"#999999"];
        _fuWuXieYi.underLineForLink = NO;
        NSString *text = @"同意《上朝啦》服务协议 和 隐私协议";
        NSRange range1 = [text rangeOfString:@"服务协议"];
        _fuWuXieYi.text = text;
        [_fuWuXieYi addCustomLink:[NSValue valueWithRange:range1] forRange:range1 linkColor:[UIColor colorWithHexString:@"#f2420a"]];
        NSRange range2 = [text rangeOfString:@"隐私协议"];
        [_fuWuXieYi addCustomLink:[NSValue valueWithRange:range2] forRange:range2 linkColor:[UIColor colorWithHexString:@"#f2420a"]];
        _fuWuXieYi.delegate = self;
    }
    return _fuWuXieYi;
}

@end
