//
//  AuditingVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "AuditingVC.h"
#import "CardView.h"

@interface AuditingVC ()<CustomIOSAlertViewDelegate>

@property(nonatomic,strong) CardView *cardView;
@property(nonatomic,strong) UIImageView *backImgView;
@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIBarButtonItem *leftBtn;
@end


@implementation AuditingVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contract = [[ContractM alloc]init];
        self.cardView = [[CardView alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setContract:(ContractM *)contract{
    _contract = contract;
    self.cardView.contract = contract;
    if ([contract.state isEqualToString:@"等待合约审核"]) {
        self.tipLabel.text = @"如果您想撤销合约，请点击撤销按钮";
        [self.cancelBtn setTitle:@"撤销合约" forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(giveUpCreateContract) forControlEvents:UIControlEventTouchUpInside];
    }else if ([contract.state isEqualToString:@"已经签约"]){
        self.tipLabel.text = @"如果您想申请解约，请点击解约按钮";
        [self.cancelBtn setTitle:@"解约" forState:UIWindowLevelNormal];
        [self.cancelBtn addTarget:self action:@selector(giveUpEstablished) forControlEvents:UIControlEventTouchUpInside];
    }else if ([contract.state isEqualToString:@"等待解约审核"]){
        self.tipLabel.text = @"如果您想撤销解约，请点击撤销按钮";
        [self.cancelBtn setTitle:@"撤销解约" forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(giveUpCreateTerminationRequested) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setEmployee:(EmployeeM *)employee{
    self.cardView.employee = employee;
}

/**
 *  撤销合约
 */
- (void)giveUpCreateContract{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    __weak typeof(self) weakSelf = self;
    NSString *contractID = self.contract.ID;
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking cheXiaoCJHY:contractID token:tokens successBlock:^{
        [hud hide:YES];
        [weakSelf backBtnPressed];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        NSString *str = [NSString stringWithFormat:@"网络错误%ld",(long)statusCode];
        hud.mode = MBProgressHUDModeText;
        [hud setLabelText:str];
        [hud hide:YES afterDelay:2.0];
    }];
}

/**
 *  创建解约
 */
- (void)giveUpEstablished{
    [self showAlert];
}

- (void)showAlert{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    CustomView *customView = [[CustomView alloc]initWithTitle:@"更换公司" andDetail:@"提交与公司解除合约申请，静待公司批准，批准后可重新选择公司。"];
    [alertView setContainerView:customView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确认", nil]];
    [alertView setDelegate:self];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {}];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

//AlertDelegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        __weak typeof(self) weakSelf = self;
        NSString *contractID = self.contract.ID;
        TokensM *tokens = [Verify getTokenFromSanBox];
        [Networking zhongZhiHeYue:contractID token:tokens successBlock:^{
            [hud hide:YES];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } failBlock:^(NSString *errStr, NSInteger statusCode) {
            NSString *str = [NSString stringWithFormat:@"网络错误%ld",(long)statusCode];
            hud.mode = MBProgressHUDModeText;
            [hud setLabelText:str];
            [hud hide:YES afterDelay:2.0];
        }];
    }
    [alertView close];
}



/**
 *  撤销解约
 */
- (void)giveUpCreateTerminationRequested{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    __weak typeof(self) weakSelf = self;
    NSString *contractID = self.contract.ID;
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking chexiaoZZHY:contractID token:tokens successBlock:^{
        [hud hide:YES];
        [weakSelf backBtnPressed];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        NSString *str = [NSString stringWithFormat:@"网络错误%ld",(long)statusCode];
        hud.mode = MBProgressHUDModeText;
        [hud setLabelText:str];
        [hud hide:YES afterDelay:2.0];
    }];
}

/**
 *  取消模态窗口
 */
- (void)backBtnPressed{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.2];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:kCATransitionFromLeft];
    [[[[UIApplication sharedApplication]keyWindow]layer]addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}



- (void)setUpUI{
     __weak typeof (self) weakSelf = self;
    self.navigationItem.title = @"合约信息";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    [self.view addSubview:self.backImgView];
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(200 * ratio);
    }];
    [self.view addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(173 * ratio);
        make.left.mas_equalTo(weakSelf.view).offset(18 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-18 * ratio);
        make.top.mas_equalTo(weakSelf.view).offset(84 * ratio);
    }];
    [self.view addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view).offset(-80 * ratio);
        make.height.mas_equalTo(44 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(18 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-18 * ratio);
        make.top.mas_equalTo(weakSelf.cardView.mas_bottom).offset(25 * ratio);
        make.height.mas_equalTo(15 * ratio);
    }];
//    [self.view addSubview:self.backBtn];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg"] forBarMetrics:UIBarMetricsDefault];
}




#pragma mark-控件设置
- (UIImageView *)backImgView{
    if (_backImgView == nil) {
        _backImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clockin_topbg"]];
    }
    return _backImgView;
}

- (UILabel *)tipLabel{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.numberOfLines = 2;
    }
    return _tipLabel;
}

- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:@"撤销" forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = -47;
    }
    return _cancelBtn;
}

- (UIButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 20, 40, 35)];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIBarButtonItem *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed)];
    }
    return _leftBtn;
}



@end
