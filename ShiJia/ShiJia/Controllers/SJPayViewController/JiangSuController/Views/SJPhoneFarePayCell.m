//
//  SJPhoneFarePayCell.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/6/23.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJPhoneFarePayCell.h"

@interface SJPhoneFarePayCell ()<PhoneFareDelegate>

@property (weak, nonatomic) IBOutlet UIButton *verCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *line;

@property (nonatomic, strong) SJPhoneFareViewModel *viewmodel;
@property (nonatomic, strong) smsCodeParams *params2;
@property (nonatomic, strong) confirmRequsetParams *params3;


@property (nonatomic, assign) BOOL hasSubmitPay;

@end

@implementation SJPhoneFarePayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.verCodeButton.layer.cornerRadius = 20.0f;
    self.verCodeButton.layer.borderWidth = 1.0;
    self.verCodeButton.layer.borderColor = kColorBlueTheme.CGColor;
    [self.verCodeButton setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
    
    self.line.backgroundColor = klightGrayColor;
    
    [self bindViewMolde];

}
-(void)setIsCheck:(BOOL)isCheck{
    if (isCheck) {
        self.selectedImg.image = [UIImage imageNamed:@"xuanzhong"];
    }
    else{
        self.selectedImg.image = [UIImage imageNamed:@"feixuanzhong"];
    }
}
-(void)bindViewMolde{
    _viewmodel  = [SJPhoneFareViewModel new];
    _viewmodel.phonefaredelegate = self;

}


-(smsCodeParams *)params2{
    if (!_params2) {
        _params2 = [smsCodeParams new];
    }
    return _params2;
}
-(confirmRequsetParams *)params3{
    if (!_params3) {
        _params3 = [confirmRequsetParams new];
        _params3.smsCode = @"";
        _params3.source = @"PHONE";
        // _params2.linkId = @"";
    }
    return _params3;
}
- (IBAction)getCodeAction:(id)sender {
    
    [MBProgressHUD showMessag:nil toView:self];
    if (self.hasSubmitPay) {
        [self timeCout];
        
        [MBProgressHUD show:nil icon:nil view:self];
        [_viewmodel getSmsCode:self.params2];
    }
    else{
        [_viewmodel payDealByPhoneFare:self.params1];
    }

}
-(void)timeCout{
    __block int timeout=90; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_verCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                _verCodeButton.userInteractionEnabled = YES;
            });
        }else{
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_verCodeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _verCodeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        [self timeCout];

        [MBProgressHUD show:nil icon:nil view:self];
        [_viewmodel confirmPayDealByPhoneFare:self.params3];
    }
}

-(void)PhoneFare_makeDealResopnse:(BOOL)success withData:(PhoneFareResponse *)data{
    [MBProgressHUD hideHUD];
    self.hasSubmitPay = YES;

    if ([data.isNeedSmsCode isEqualToString:@"1"]) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"连续包月" message:@"确认开通连续包包月业务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 0;
        [alert show];
        
    }else{
        [self timeCout];
    }
    self.params2.linkId = data.linkId;
    self.params3.linkId = data.linkId;
    
    if (self.m_delegate) {
        [self.m_delegate noticeLinkId:data.linkId];
    }
}
-(void)PhoneFare_receiveSmsCode:(BOOL)codesuccess{
    [MBProgressHUD hideHUDForView:self animated:NO];
    [MBProgressHUD showSuccess:@"验证码已发送" toView:self];
    
}


-(void)HandPhoneFareError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self animated:NO];
    [MBProgressHUD showError:[error localizedDescription] toView:self];
}

-(void)PhoneFare_payDealResponse:(BOOL)response{
    [MBProgressHUD hideHUDForView:self animated:NO];
    if (response==YES) {
        [self.m_delegate payFinished];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
