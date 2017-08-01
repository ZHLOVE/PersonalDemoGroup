//
//  SJVertifyCodeViewController.m
//  ShiJia
//
//  Created by 峰 on 2016/12/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVertifyCodeViewController.h"
#import "SJPhoneFareModel.h"
#import "SJPhoneFareViewModel.h"
#import "SJPayFinishViewController.h"
#import "BIMSManager.h"
#import "HiTVGlobals.h"

@interface SJVertifyCodeViewController ()<PhoneFareDelegate>

@property (weak, nonatomic) IBOutlet UIButton *verCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *codeNumber;
@property (nonatomic, strong) SJPhoneFareViewModel *viewmodel;
@property (nonatomic, strong) confirmRequsetParams *params1;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (nonatomic, strong) smsCodeParams *params2;




@property (weak, nonatomic) IBOutlet UIButton *anhuiBtn1;
@property (weak, nonatomic) IBOutlet UITextField *anhuiInput1;
@property (weak, nonatomic) IBOutlet UILabel *info1;
@property (weak, nonatomic) IBOutlet UILabel *info2;


@end

@implementation SJVertifyCodeViewController

-(confirmRequsetParams *)params1{
    if (!_params1) {
    _params1 = [confirmRequsetParams new];
        _params1.linkId = self.stringID;
        _params1.source = @"PHONE";
    }
    return _params1;
}

-(smsCodeParams *)params2{
    if (!_params2) {
        _params2 = [smsCodeParams new];
        _params2.linkId = self.stringID;
    }
    return _params2;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"支付验证";

    self.verCodeButton.layer.cornerRadius = 3.0f;
    self.verCodeButton.layer.borderWidth = 1.0;
    self.verCodeButton.layer.borderColor = RGB(42, 193, 239, 1).CGColor;
    [self bindViewMolde];
    self.phoneNumber.text =[NSString stringWithFormat:@" %@", [HiTVGlobals sharedInstance].phoneNo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self timeCout];
    _params1 = self.params1;
    _params2 = self.params2;

}

-(void)bindViewMolde{
    _viewmodel  = [SJPhoneFareViewModel new];
    _viewmodel.phonefaredelegate = self;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    self.view.layer.cornerRadius =
    // Dispose of any resources that can be recreated.
}

-(void)initNavgationRightItem{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.backgroundColor =[UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(backAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}
- (IBAction)getCodeAction:(id)sender {
    [self timeCout];
    [_viewmodel getSmsCode:_params2];
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

- (IBAction)payAction:(id)sender {
    if (_codeNumber.text.length==0) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    [MBProgressHUD showMessag:nil toView:self.view];
    _params1.smsCode =_codeNumber.text;
   [_viewmodel confirmPayDealByPhoneFare:_params1];
}


-(void)backAction:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)PhoneFare_receiveSmsCode:(BOOL)codesuccess{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showSuccess:@"验证码已发送" toView:self.view];

}

-(void)PhoneFare_payDealResponse:(BOOL)success{
    if (success==YES) {
        SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
        payFinishVC.productServiceID = _dictParams.serviceId;
        payFinishVC.productEntity = _dictParams;
        payFinishVC.recommArray = self.recommArray;
        [self.navigationController pushViewController:payFinishVC animated:YES];
    }

}
-(void)HandPhoneFareError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showError:[error localizedDescription] toView:self.view];
}


@end
