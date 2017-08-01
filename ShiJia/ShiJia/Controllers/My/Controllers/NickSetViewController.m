//
//  NickSetViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/6/28.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "NickSetViewController.h"
#import "OMGToast.h"

@interface NickSetViewController ()<UITextFieldDelegate>

@end

@implementation NickSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = klightGrayColor;
    self.title = @"修改昵称";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nickNameTextField];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:16.0f],
                                NSFontAttributeName,
                                kNavTitleColor,
                                NSForegroundColorAttributeName, nil];
    UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(userUpdateUserInfo)];
    [sureBtn setTitleTextAttributes:attributes forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:sureBtn];

    self.nickNameTextField.text = [HiTVGlobals sharedInstance].nickName;
    if (self.nickNameTextField.text.length > 11) {
        self.nickNameTextField.text = [self.nickNameTextField.text substringToIndex:11];
    }
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[self textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 11) {
                textField.text = [toBeString substringToIndex:11];
                [OMGToast showWithText:@"超过最大字数不能输入了"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 11) {
            textField.text = [toBeString substringToIndex:11];
        }
    }
}

-(void)pushUserImageSetVc{
    
}

-(IBAction)nextStep:(id)sender{
    [self userUpdateUserInfo];
}

/**
 *  用户信息修改
 */
-(void)userUpdateUserInfo
{
    if (self.nickNameTextField.text.length == 0) {
        [self showAlert:@"请输入昵称" withDelegate:self];
        return;
    }
    if ([Utils isIncludeSpecialCharact:self.nickNameTextField.text]) {
        [OMGToast showWithText:@"不超过11个字符，只支持数字、中英文，不支持符号"];
        return;
    }
    if (self.nickNameTextField.text.length>16) {
        [OMGToast showWithText:@"昵称过长"];
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    //modify by jhl 20150819
    [parameters setValue:self.nickNameTextField.text forKey:@"nickName"];
    /* [parameters setValue:@"" forKey:@"birth"];
     [parameters setValue:@"27637263@qq.com" forKey:@"email"];
     [parameters setValue:@"15251879099" forKey:@"phoneno"];
     [parameters setValue:@"2133133" forKey:@"qq"];
     [parameters setValue:@"新区" forKey:@"address"];*/
    //end
    NSString *sk = [NSUserDefaultsManager getObjectForKey:SK];
    
    [parameters setValue:[NSString stringWithFormat:@"%@^%@",[HiTVGlobals sharedInstance].uid ,sk] forKey:@"authkey"];
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN  forParam:@"/userservice/update/userinfo" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            [HiTVGlobals sharedInstance].nickName = [parameters objectForKey:@"nickName"];
            [OMGToast showWithText:[responseDic objectForKey:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
            [self uploadUserInfoRequest];
        }
        else{
            [self showAlert:[responseDic objectForKey:@"message"] withDelegate:nil];
        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf p_handleNetworkError];
    }];
    
}
/**
 *  上报社交系统
 */
-(void)uploadUserInfoRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setObject:[HiTVGlobals sharedInstance].longitude forKey:@"longitude"];
    [parameters setObject:[HiTVGlobals sharedInstance].latitude forKey:@"latitude"];
    [parameters setObject:[HiTVGlobals sharedInstance].intranetIp forKey:@"intranetIp"];
    [parameters setObject:[HiTVGlobals sharedInstance].ssid forKey:@"ssid"];
    [parameters setObject:[HiTVGlobals sharedInstance].gateWay forKey:@"gateWay"];
    [parameters setObject:[HiTVGlobals sharedInstance].gateWayMac forKey:@"gateWayMac"];
    [parameters setObject:[HiTVGlobals sharedInstance].uid forKey:@"typeId"];
    [parameters setObject:[HiTVGlobals sharedInstance].xmppUserId forKey:@"jId"];
    if (![HiTVGlobals sharedInstance].nickName) {
        [HiTVGlobals sharedInstance].nickName = @"";
    }
    if (![HiTVGlobals sharedInstance].faceImg) {
        [HiTVGlobals sharedInstance].faceImg = @"";
    }
    [parameters setObject:[HiTVGlobals sharedInstance].nickName forKey:@"nickName"];
    [parameters setObject:XMPPHOST forKey:@"jIdAddr"];
    [parameters setObject:[HiTVGlobals sharedInstance].faceImg forKey:@"faceImg"];
    //[parameters setObject:@"TOGETHER_SAME_NET" forKey:@"state"];
    if ([HiTVGlobals sharedInstance].serviceAddrs) {
        [parameters setObject:[HiTVGlobals sharedInstance].serviceAddrs forKey:@"serviceAddr"];
    }
    [parameters setObject:@"APP" forKey:@"type"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *jsonString = [parameters mj_JSONString];
    
    [dic setObject:jsonString forKey:@"info"];
    [dic setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [dic setObject:@"APP" forKey:@"type"];
    [parameters setObject:BIMS_DOMAIN forKey:@"area"];

    [BaseAFHTTPManager postRequestOperationForHost:MultiHost  forParam:@"/ms_update_phoneInfo" forParameters:dic  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            
        }
        
    }failure:^(NSString *error) {
        
    }];
}
-(IBAction)clearData:(id)sender{
    self.nickNameTextField.text = @"";
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.nickNameTextField == textField)
    {
        if ([toBeString length] > 8 && range.length!=1) {
            [OMGToast showWithText:@"超过最大字数不能输入了"];
            return NO;
        }
    }*/
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.nickNameTextField];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
