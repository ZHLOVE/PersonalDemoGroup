//
//  SJLoginViewController.m
//  ShiJia
//
//  Created by yy on 16/2/2.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJLoginViewController.h"
#import "Utils.h"
#import "BIMSManager.h"
#import "TPIMUser.h"
#import "OMGToast.h"

#import "SJConnectTVViewController.h"
#import "SJLightViewController.h"

#define APP_VERCODE_LIMIT 60

@interface SJLoginViewController ()
{
    NSTimer *verTimer;              //验证码计时器
    
    NSUInteger verTimeLimit;        //验证码计数
}
@property(nonatomic,weak) IBOutlet UIButton *backButton;
@property(nonatomic,weak) IBOutlet UIButton *getCodeButton;
@property(nonatomic,weak) IBOutlet UIButton *loginButton;
@property(nonatomic,weak) IBOutlet UIButton *tryButton;

@property(nonatomic,weak) IBOutlet UIImageView *lineImg;
@property(nonatomic,weak) IBOutlet UIImageView *line2Img;

@property(nonatomic,weak) IBOutlet UITextField *phoneTextField;
@property(nonatomic,weak) IBOutlet UITextField *pwdTextField;

@property(nonatomic,weak) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bitmapImg;
@property (weak, nonatomic) IBOutlet UIImageView *bellowLogo;

@end

@implementation SJLoginViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //if (self.firstLaunch) {
        self.navigationController.navigationBarHidden = YES;
        self.backButton.hidden = YES;
    //}
    
    [self initUI];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    //tapGr.cancelsTouchesInView = NO;
    
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];*/
    
    [self.view addGestureRecognizer:tapGr];

}
-(void)initUI
{
    self.lineImg.backgroundColor = kColorTryButton;
    self.line2Img.backgroundColor = kColorTryButton;
    [self.getCodeButton setTintColor:kColorBlueTheme];
    self.getCodeButton.layer.borderWidth = 0.5f;
    self.getCodeButton.layer.borderColor = [kColorBlueTheme CGColor];
    [self.getCodeButton setTitleColor:kColorBlueTheme forState:UIControlStateNormal];

    self.loginButton.backgroundColor = kColorBlueTheme;
//    self.tryButton.backgroundColor = kColorTryButton;
    self.tipLab.backgroundColor = RGB(241, 241, 241, 1);
    if (!self.firstLaunch) {
//        self.tryButton.backgroundColor = kColorLoginButton;
        [self.tryButton setTitle:@"取  消" forState:UIControlStateNormal];
    }
    self.tryButton.hidden = YES;
#ifdef JiangSu
    self.bitmapImg.hidden = NO;
    self.bellowLogo.hidden = NO;
#else
    self.bitmapImg.hidden = YES;
    self.bellowLogo.hidden = YES;
#endif
    
    
    self.logoImageView.image = [UIImage imageNamed:LoginLogoImageName];
    self.tipLab.text = SJLOGINBELLOWTIP;
    NSString *phoneNo = [NSUserDefaultsManager getObjectForKey:PHONENO];
    self.phoneTextField.text = phoneNo;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = YES;
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self downKeyboard];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    verTimer=nil;
    
}
-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)validateCode:(id)sender{
#ifdef BeiJing
    [self bj_validateCode];
#else
    [self js_validateCode];
#endif
}

//更新计时器
- (void)verUpdate
{
    if (verTimeLimit == 0) {
        if ([verTimer isValid]) {
            [verTimer invalidate];
            [self.getCodeButton setEnabled:YES];
            [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        }
    }
    else{
        [self.getCodeButton setEnabled:NO];
        NSString *str = [NSString stringWithFormat:@"(%ld)秒",(unsigned long)verTimeLimit];
        [self.getCodeButton setTitle:str forState:UIControlStateDisabled];
        
        //        [self.verificationBtn.titleLabel setText:str];
    }
    verTimeLimit--;
}
-(IBAction)LoginClick:(id)sender
{
#ifdef BeiJing
    [self bj_Login];
#else
    [self js_Login];
#endif
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 10001:
        {
            if (buttonIndex == 0) {
                if (![HiTVGlobals sharedInstance].anonymousUid) {
                    [[BIMSManager sharedInstance] boot];
                }
                else{
                    [self LoginClick:nil];
                }
            }
        }
            break;
        case 10002:
        {
            if (buttonIndex == 0) {
                if (![HiTVGlobals sharedInstance].anonymousUid) {
                    [[BIMSManager sharedInstance] boot];
                }
                else{
                    [self validateCode:nil];
                }
            }
        }
            break;
        default:
            break;
    }
    
    
}
-(IBAction)tryOut:(id)sender{
    if (self.firstLaunch) {
        SJConnectTVViewController *connectVC = [[SJConnectTVViewController alloc] init];
        [self.navigationController pushViewController:connectVC animated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        self.lineImg.backgroundColor = kColorBlueTheme;
        self.line2Img.backgroundColor = kColorTryButton;
    }
    else{
        self.lineImg.backgroundColor = kColorTryButton;
        self.line2Img.backgroundColor = kColorBlueTheme;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.phoneTextField == textField)
    {
        if ([toBeString length] > 11 && range.length!=1) {
            //[OMGToast showWithText:@"超过最大字数不能输入了"];
            return NO;
        }
    }
    else{
        if ([toBeString length] > 6 && range.length!=1) {
            // [OMGToast showWithText:@"超过最大字数不能输入了"];
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showKeyboard];
}
-(void)hiddenKeyboard
{
    [_phoneTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
}
-(void)showKeyboard{
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(0, -140, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

-(void)downKeyboard{
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    
    [self hiddenKeyboard];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)keyboardDidHide{
    [self downKeyboard];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)showLoginErrorView:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 10001;
    [alert show];
}
-(void)showGetcodeErrorView:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 10002;
    [alert show];
}
-(void)bj_validateCode{
    if (![Utils isMobileNumber:_phoneTextField.text]) {
        [self showAlert:@"请填写正确的手机号" withDelegate:nil];
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[self regularcheck:_phoneTextField] forKey:@"phoneNo"];
    [parameters setValue:@"bjydLogin" forKey:@"msgType"];
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.getCodeButton setTitle:@"发送中" forState:UIControlStateNormal];
    
    
    [BaseAFHTTPManager postRequestOperationForHost:BSS_HOST forParam:@"/mobile/sendValidateCode" forParameters:parameters completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"BSS-000"]) {
            verTimeLimit = APP_VERCODE_LIMIT;
            verTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(verUpdate) userInfo:nil repeats:YES];
        }else{
            [self.getCodeButton setEnabled:YES];
            [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
            [self showAlert:[responseDic objectForKey:@"message"] withDelegate:nil];
        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [self.getCodeButton setEnabled:YES];
        [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        //[weakSelf p_handleNetworkError];
        [self showGetcodeErrorView:@"网络连接错误，请检查网络设置"];
        
    }];
}
-(void)bj_Login{
    if ([HiTVGlobals sharedInstance].isLogin) {
        if([AppDelegate appDelegate].appdelegateService.hasMainVC){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [[AppDelegate appDelegate].appdelegateService showMainViewController];
        }
        return;
    }
    if (![Utils isMobileNumber:_phoneTextField.text]) {
        [self showAlert:@"请填写正确的手机号" withDelegate:nil];
        return;
    }
    if (_pwdTextField.text.length == 0) {
        [OMGToast showWithText:@"验证码不能为空"];
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[self regularcheck:_phoneTextField] forKey:@"phoneNo"];
    [parameters setObject:BIMS_DOMAIN forKey:@"domain"];
    [parameters setValue:[self regularcheck:_pwdTextField] forKey:@"validateCode"];
    [parameters setValue:[HiTVGlobals sharedInstance].anonymousUid forKey:@"uid"];
    [parameters setValue:@(1) forKey:@"userSource"];
    [parameters setValue:isNullString([Utils platformString]) forKey:@"deviceType"];
    
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:BSS_HOST forParam:@"/mobile/doLogin" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"BSS-000"]) {
            responseDic = [responseDic objectForKey:@"data"];
            [Utils BDLog:1 module:@"603" action:@"AppLogin" content:@"result=0&state=&content="];
            
            NSString *uid = [responseDic objectForKey:@"uid"];
            
            [NSUserDefaultsManager saveObject:[NSString stringWithFormat:@"%ld",[uid longValue]] forKey:P_UID];
            
            [NSUserDefaultsManager saveObject:[NSNumber numberWithBool:YES] forKey:ISLOGIN];
            
            [HiTVGlobals sharedInstance].uid = [NSUserDefaultsManager getObjectForKey:P_UID];
            [[HiTVGlobals sharedInstance] setIsManualLogIn:YES];
            
            //获取用户信息
            [[HiTVGlobals sharedInstance] setIsManualLogIn:YES];
            [[BIMSManager sharedInstance] getUserInfo];
            
            //[OMGToast showWithText:[responseDic objectForKey:@"message"]];
            
            
            if (self.firstLaunch) {
                SJConnectTVViewController *connectVC = [[SJConnectTVViewController alloc] init];
                [self.navigationController pushViewController:connectVC animated:YES];
            }
            else if([AppDelegate appDelegate].appdelegateService.hasMainVC){
                [self dismissViewControllerAnimated:YES completion:^{
                    [self isHavePersonalResultRequest];
                }];
            }
            else{
                [[AppDelegate appDelegate].appdelegateService showMainViewController];
            }
            
            
        }
        else{
            [Utils BDLog:1 module:@"603" action:@"AppLogin" content:@"result=-1&state=&content="];
            
            [OMGToast showWithText:[responseDic objectForKey:@"message"]];
            
        }
    }failure:^(NSString *error) {
        [Utils BDLog:1 module:@"603" action:@"AppLogin" content:@"result=-1&state=&content="];
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        //        [weakSelf p_handleNetworkError];
        
        [self showLoginErrorView:@"网络连接错误，请检查网络设置"];
    }];
    }
-(void)js_validateCode{
    
    if (![Utils isMobileNumber:_phoneTextField.text]) {
        [self showAlert:@"请填写正确的手机号" withDelegate:nil];
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[self regularcheck:_phoneTextField] forKey:@"phoneNo"];
    
    [parameters setValue:@"superLogin" forKey:@"msgType"];
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.getCodeButton setTitle:@"发送中" forState:UIControlStateNormal];
    
    
    [BaseAFHTTPManager postRequestOperationForHost:BSS_HOST forParam:@"/mobile/sendValidateCode" forParameters:parameters completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *result = [responseDic objectForKey:@"result"];
        if ([result isEqualToString:@"BSS-000"]) {
            verTimeLimit = APP_VERCODE_LIMIT;
            verTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(verUpdate) userInfo:nil repeats:YES];
        }else{
            [self.getCodeButton setEnabled:YES];
            [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
            [self showAlert:[responseDic objectForKey:@"message"] withDelegate:nil];
        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [self.getCodeButton setEnabled:YES];
        [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        //[weakSelf p_handleNetworkError];
        [self showGetcodeErrorView:@"网络连接错误，请检查网络设置"];
        
    }];
    
}
-(void)js_Login{
    
    if ([HiTVGlobals sharedInstance].isLogin) {
        if([AppDelegate appDelegate].appdelegateService.hasMainVC){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [[AppDelegate appDelegate].appdelegateService showMainViewController];
        }
        return;
    }
    
    if (![Utils isMobileNumber:_phoneTextField.text]) {
        [self showAlert:@"请填写正确的手机号" withDelegate:nil];
        return;
    }
    if (_pwdTextField.text.length == 0) {
        [OMGToast showWithText:@"验证码不能为空"];
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    NSString *phoneNo = [self regularcheck:_phoneTextField];
    [parameters setValue:phoneNo forKey:@"phoneNo"];
    [parameters setValue:@"MOBILE" forKey:@"deviceType"];
    if (![CHANNELID isEqualToString:taipanTest63]) {
        [parameters setObject:BIMS_DOMAIN forKey:@"domain"];
    }
    [parameters setValue:[self regularcheck:_pwdTextField] forKey:@"validateCode"];
    [parameters setValue:[HiTVGlobals sharedInstance].anonymousUid forKey:@"uid"];
    [parameters setValue:@(1) forKey:@"userSource"];
    NSString *version = APPVersion;
    [parameters setValue:isNullString(version) forKey:@"version"];
    [parameters setValue:@"IOS" forKey:@"phoneOS"];
    [parameters setValue:@"苹果" forKey:@"phoneType"];
    [parameters setValue:T_STBext forKey:@"screenId"];

    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:BSS_HOST  forParam:@"/mobile/doLogin" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if ([code isEqualToString:@"BSS-000"]) {
            
            NSString *uid = [responseDic[@"data"] objectForKey:@"uid"];
            
            [NSUserDefaultsManager saveObject:[NSString stringWithFormat:@"%d",[uid intValue]] forKey:P_UID];
            [NSUserDefaultsManager saveObject:[NSNumber numberWithBool:YES] forKey:ISLOGIN];
            
            [HiTVGlobals sharedInstance].uid = [NSUserDefaultsManager getObjectForKey:P_UID];
            
            NSDictionary *screeIdDic = [[responseDic[@"screenId"] stringByRemovingPercentEncoding] mj_JSONObject];
            NSString *districtCode = screeIdDic[@"districtCode"];

            [NSUserDefaultsManager saveObject:districtCode forKey:CITYCODE];
            [[HiTVGlobals sharedInstance] setIsManualLogIn:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_REFRASHMAIN object:nil];

            //获取用户信息
            [[BIMSManager sharedInstance] getUserInfo];
            
            [OMGToast showWithText:@"登录成功"];
            //加载二维码
            //[self getUserInfo];
            
            if (self.firstLaunch) {
                SJConnectTVViewController *connectVC = [[SJConnectTVViewController alloc] init];
                [self.navigationController pushViewController:connectVC animated:YES];
            }
            else if([AppDelegate appDelegate].appdelegateService.hasMainVC){
                [self dismissViewControllerAnimated:YES completion:^{
                    [self isHavePersonalResultRequest];
                }];
            }
            else{
                [[AppDelegate appDelegate].appdelegateService showMainViewController];
            }
            
            
        }
        else{
            [Utils BDLog:2 module:@"603" action:@"AppLogin" content:@"result=-1&state=&content="];
            
            [OMGToast showWithText:[responseDic objectForKey:@"message"]];
        }
    }failure:^(NSString *error) {
        [Utils BDLog:2 module:@"603" action:@"AppLogin" content:@"result=-1&state=&content="];
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        [self showLoginErrorView:@"网络连接错误，请检查网络设置"];
        
    }];
    
}

#pragma mark -  Request 查询是否需要点亮页
- (void)isHavePersonalResultRequest
{
    //自动点亮有数据则上传
    if ([HiTVGlobals sharedInstance].interested) {
        [[BIMSManager sharedInstance] submitUserInterestedClass];
    }
    else{
        __weak __typeof(self)weakSelf = self;
        NSDictionary *param = @{
                                @"userId" : [HiTVGlobals sharedInstance].uid,
                                @"abilityString" :  T_STBext,
                                };
        NSString* url = [NSString stringWithFormat:@"%@personal/isHavePersonalResult",
                         MYEPG];
        
        DDLogInfo(@"url: %@", url);
        //    [HUD showAnimated:YES];
        [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:param completion:^(id responseObject) {
            //        [HUD hideAnimated:YES];
            

            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                if ([[resultDic objectForKey:@"isHave"] intValue] == 1) {
                }
                else{
                   // [strongSelf goSJSetFavoriteViewController];
                    SJLightViewController * favoriteVC = [[SJLightViewController alloc] init];
                    // [self.navigationController pushViewController:favoriteVC animated:YES];
                    [[AppDelegate appDelegate].window.rootViewController presentViewController:favoriteVC animated:YES completion:^{
                    }];
                }
            }
            else{
                //[strongSelf goSJSetFavoriteViewController];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSString *error) {

        }];
    }
    
}
-(void)goSJSetFavoriteViewController{
    /*SJSetFavoriteViewController * favoriteVC = [[SJSetFavoriteViewController alloc] init];
     [self.navigationController pushViewController:favoriteVC animated:YES];*/
    SJLightViewController * favoriteVC = [[SJLightViewController alloc] init];
    // [self.navigationController pushViewController:favoriteVC animated:YES];
    [[AppDelegate appDelegate].window.rootViewController presentViewController:favoriteVC animated:YES completion:^{
    }];
}
@end
