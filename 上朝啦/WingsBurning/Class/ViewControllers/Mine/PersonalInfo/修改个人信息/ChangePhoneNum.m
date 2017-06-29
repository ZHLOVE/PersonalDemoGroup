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

#pragma mark - TextFieldDelegate限制输入长度11位
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

- (void)setUpUI{
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.lineView];
    [self.topView addSubview:self.phoneNumberTF];
    [self.topView addSubview:self.captchaTF];
    [self.topView addSubview:self.captchaBtn];
    [self.view addSubview:self.buttonOK];
}


- (void)updateEmployeeInfo{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
         EmployeeM *newEmployee = array[0];
         DLog(@"更新成功%@",newEmployee);
         hud.label.text = @"更新成功";
         [hud hideAnimated:YES afterDelay:1.5];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
         });
     } failBlock:^(NSString *errStr, NSInteger statusCode) {
         DLog(@"%ld:%@",(long)statusCode,errStr);
         hud.label.text = errStr;
         [hud hideAnimated:YES afterDelay:1.5];
     }];
}

#pragma mark-获取验证码
- (void)getMyCaptcha{
    __weak typeof(self) weakSelf = self;
    BOOL isPhoneNumber = [CheckDataTool checkForMobilePhoneNo:self.phoneNumberTF.text];
    if (isPhoneNumber) {
        weakSelf.captchaBtn.enabled = NO;
        [Networking huoQuYZM:self.phoneNumberTF.text action:@"register" successBlock:^{
            DLog(@"验证码获取成功");
            [weakSelf.captchaTF becomeFirstResponder];
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
            DLog(@"%ld%@",(long)statusCode,errStr);
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 46, screenWidth, 1)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    }
    return _lineView;
}




- (UITextField *)phoneNumberTF{
    if (_phoneNumberTF == nil) {
        _phoneNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(18, 0, screenWidth - 18, 46)];
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
        _captchaTF = [[UITextField alloc]initWithFrame:CGRectMake(18, 46, screenWidth - 180 * ratio, 46)];
        _captchaTF.returnKeyType = UIReturnKeyDone;
        _captchaTF.keyboardType = UIKeyboardTypeNumberPad;
        _captchaTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _captchaTF.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        [_captchaTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _captchaTF;
}

- (UIButton *)captchaBtn{
    if (_captchaBtn == nil) {
        _captchaBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        _captchaBtn.frame = CGRectMake(screenWidth - 112, 53, 94, 32);
        [_captchaBtn setCaptchaButtonCreated];
        [_captchaBtn addTarget:self action:@selector(getMyCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captchaBtn;
}

- (UIButton *)buttonOK{
    if (_buttonOK == nil) {
        _buttonOK = [[UIButton alloc]initWithFrame:CGRectMake(18, 163, screenWidth - 36, 44)];
        [_buttonOK setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [_buttonOK setTitle:@"保  存" forState:UIControlStateNormal];
        _buttonOK.titleLabel.font = [UIFont systemFontOfSize:14];
        [_buttonOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonOK addTarget:self action:@selector(updateEmployeeInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonOK;
}


@end
