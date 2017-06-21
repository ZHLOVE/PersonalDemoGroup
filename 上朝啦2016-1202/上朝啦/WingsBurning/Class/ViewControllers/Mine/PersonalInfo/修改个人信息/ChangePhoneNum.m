//
//  ChangePhoneNum.m
//  WingsBurning
//
//  Created by MBP on 16/9/14.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ChangePhoneNum.h"
#import "JKCountDownButton.h"

@interface ChangePhoneNum()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UITextField *phoneNumberTF;
@property(nonatomic,strong) UITextField *captchaTF;
@property(nonatomic,strong) UIButton *buttonOK;
@property(nonatomic,strong) JKCountDownButton *captchaBtn;
@end

@implementation ChangePhoneNum

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
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

- (void)setUpUI{
    __weak typeof(self) weakSelf = self;
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.lineView];
    [self.topView addSubview:self.phoneNumberTF];
    [self.phoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(46 * ratio);
        make.top.mas_equalTo(weakSelf.topView).offset(3 * ratio);
        make.left.mas_equalTo(weakSelf.topView).offset(18 * ratio);
        make.right.mas_equalTo(weakSelf.topView);
    }];
    [self.topView addSubview:self.captchaTF];
    [self.captchaTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(46 * ratio);
        make.bottom.mas_equalTo(weakSelf.topView.mas_bottom).offset(3 * ratio);
        make.left.mas_equalTo(weakSelf.topView).offset(18 * ratio);
        make.width.mas_equalTo(150);
    }];
    [self.topView addSubview:self.captchaBtn];
    [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.captchaTF.mas_centerY).offset(-3 * ratio);
        make.width.mas_equalTo(94 * ratio);
        make.height.mas_equalTo(32 * ratio);
        make.right.mas_equalTo(weakSelf.topView).offset(-18 * ratio);
    }];
    [self.view addSubview:self.buttonOK];
    [self.buttonOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topView.mas_bottom).offset(60 * ratio);
        make.left.mas_equalTo(weakSelf.view).offset(18 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-18 * ratio);
    }];

}


- (void)updateEmployeeInfo{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    __weak typeof(self) weakSelf = self;
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    TokensM *tokens = [Verify getTokenFromSanBox];
    Employees *updateEmployees = [[Employees alloc]init];
    updateEmployees.userName = employee.name;
    updateEmployees.phone_number = self.phoneNumberTF.text;
    updateEmployees.captcha = self.captchaTF.text;
    [Networking xiuGaiGuYuanXinXi:employee.ID Employees:updateEmployees token:tokens successBlock:^(NSArray *array)
     {
         EmployeeM *employee = array[0];
         DLog(@"更新成功%@",employee);
         [hud setCenter:self.view.center];
         [hud setLabelText:@"更新成功"];
         [hud hide:YES afterDelay:1.0];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
         });
     } failBlock:^(NSString *errStr, NSInteger statusCode) {
         DLog(@"%ld:%@",(long)statusCode,errStr);
         [hud setCenter:self.view.center];
         [hud setLabelText:errStr];
         [hud hide:YES afterDelay:1.0];
     }];
    

}

#pragma mark-获取验证码
- (void)getMyCaptcha{
    BOOL isPhoneNumber = [CheckDataTool checkForMobilePhoneNo:self.phoneNumberTF.text];
    if (isPhoneNumber) {
        [Networking huoQuYZM:self.phoneNumberTF.text action:@"register" successBlock:^{
            DLog(@"验证码获取成功");
        } failBlock:^(NSInteger statusCode,NSString *errStr) {
            DLog(@"%ld%@",(long)statusCode,errStr);
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

- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screenWidth, 92)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 56, screenWidth, 1)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    }
    return _lineView;
}




- (UITextField *)phoneNumberTF{
    if (_phoneNumberTF == nil) {
        _phoneNumberTF = [[UITextField alloc]init];
        _phoneNumberTF.returnKeyType = UIReturnKeyDone;
        _phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        NSString *holderText = @"新手机号";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHexString:@"#999999"]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:14]
                            range:NSMakeRange(0, holderText.length)];
        _phoneNumberTF.attributedPlaceholder = placeholder;
        _phoneNumberTF.delegate = self;
    }
    return _phoneNumberTF;
}

- (UITextField *)captchaTF{
    if (_captchaTF == nil) {
        _captchaTF = [[UITextField alloc]init];
        _captchaTF.returnKeyType = UIReturnKeyDone;
        _captchaTF.keyboardType = UIKeyboardTypeNumberPad;
        _captchaTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        NSString *holderText = @"验证码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHexString:@"#999999"]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:14]
                            range:NSMakeRange(0, holderText.length)];
        _captchaTF.attributedPlaceholder = placeholder;
        _captchaTF.delegate = self;
    }
    return _captchaTF;
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
            BOOL isPhoneNumber = [CheckDataTool checkForMobilePhoneNo:_phoneNumberTF.text];
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

- (UIButton *)buttonOK{
    if (_buttonOK == nil) {
        _buttonOK = [[UIButton alloc]init];
        [_buttonOK setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_buttonOK setTitle:@"保  存" forState:UIControlStateNormal];
        _buttonOK.titleLabel.font = [UIFont systemFontOfSize:14];
        [_buttonOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonOK addTarget:self action:@selector(updateEmployeeInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonOK;
}

@end
