//
//  ModifyremarksController.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/25.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "ModifyremarksController.h"
#import "OMGToast.h"

@interface ModifyremarksController ()
@property(nonatomic,weak) IBOutlet UITextField *textField;
@end

@implementation ModifyremarksController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改备注";
    self.view.backgroundColor = klightGrayColor;

    
    
    UIBarButtonItem *scanningBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
    
    
    [self.navigationItem setRightBarButtonItem:scanningBtn];
    [self.navigationItem.rightBarButtonItem setTintColor:kNavTitleColor];
    
    if (self.userEntity.nickName.length==0) {
        self.textField.text = self.userEntity.name;
    }
    else{
        self.textField.text = self.userEntity.nickName;
    }
    if (self.textField.text.length > 11) {
        self.textField.text = [self.textField.text substringToIndex:11];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.textField];
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
-(void)sure{
   // [self.navigationController popViewControllerAnimated:YES];
    [self modifyRemarkRequest];
}
- (void)modifyRemarkRequest{
    if (self.textField.text.length == 0) {
        self.textField.text = @"";
        [OMGToast showWithText:@"不超过11个字符，只支持数字、中英文，不支持符号"];
        return;
    }
    if ([Utils isIncludeSpecialCharact:self.textField.text]) {
        [OMGToast showWithText:@"不超过11个字符，只支持数字、中英文，不支持符号"];
        return;
    }
    if (self.textField.text.length>22) {
        [OMGToast showWithText:@"昵称过长"];
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:self.userEntity.uid forKey:@"friendUid"];
    [parameters setValue:self.textField.text forKey:@"nickName"];

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/updateFriendNickname" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            /*if (self.m_delegate) {
                [self.m_delegate refreshFriendInfo];
            }*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyremarks" object:self.textField.text];
            [self.navigationController popViewControllerAnimated:YES];
            [OMGToast showWithText:[resultDic objectForKey:@"message"]];

        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}
-(IBAction)clearData:(id)sender{
    self.textField.text = @"";
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.textField == textField)
    {
        if ([toBeString length] > 8 && range.length!=1) {
            [OMGToast showWithText:@"超过最大字数不能输入了"];
            return NO;
        }
    }*/
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.textField];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)refreshFriendInfo
{}
@end
