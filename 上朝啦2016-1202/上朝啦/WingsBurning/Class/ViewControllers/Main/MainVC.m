//
//  MainVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "MainVC.h"
#import "HWWeakTimer.h"
#import "Login.h"
#import "PunchCameraVC.h"
#import "FirstCapture.h"
#import "GuideVC.h"
#import "Record.h"
#import "BaseNavigationCongroller.h"

@interface MainVC ()
@property(nonatomic,strong) UIImageView *backImageView;
@property(nonatomic,strong) UIImageView *bottomImageView;
@property(nonatomic,strong) UIBarButtonItem *leftBtn;
@property(nonatomic,strong) UIBarButtonItem *rightBtn;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UIButton *punchyBtn;
@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic,assign) BOOL punchEnable;


@property(nonatomic,strong) EmployeeM *employee;
@property(nonatomic,strong) EmployerM *employer;

@end


@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self updateTime];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigation];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self checkAccessToken];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}


- (void)checkAccessToken{
    BOOL accessToken = [Verify checkAccessToken];
    if (!accessToken) {
        Login *vc = [[Login alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        [self checkVersion];
    }
}


/**
 *  检查版本
 */
- (void)checkVersion{
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    DLog(@"最新版本%@",version);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [userDefault objectForKey:@"lastOpenVersion"];
    DLog(@"上次版本%@",lastVersion);
    if ([version isEqualToString:lastVersion]) {
        [self getHeadViewInfo];
    }else{
        [userDefault setObject:version forKey:@"lastOpenVersion"];
        [userDefault synchronize];// 保存一下
        GuideVC *guide = [[GuideVC alloc]init];
        [self presentViewController:guide animated:NO completion:^{}];
    }
}

/**
 *  获取个人信息，包括合约信息
 */
- (void)getHeadViewInfo{
        EmployeeM *employee = [Verify getEmployeeFromSandBox];
        TokensM *tokens = [Verify getTokenFromSanBox];
        [Networking huoQuGuYuanXinXi:employee.ID token:tokens successBlock:^(EmployeeM *emp){
            _employee = emp;
            [Verify saveEmployee:emp];
        } failBlock:^(NSString *errStr, NSInteger statusCode) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setMode:MBProgressHUDModeText];
            [hud setCenter:self.view.center];
            NSString *str = [NSString stringWithFormat:@"请检查网络"];
            DLog(@"%ld",(long)statusCode);
            [hud setLabelText:str];
            [hud hide:YES afterDelay:2.0];
        }];
        [Networking huoQuDQHY:employee.ID token:tokens successBlock:^(ContractM *contract, EmployerM *employer) {
            _employer = employer;
            [Verify saveEmployerToSH:employer];
            _punchEnable = [contract.state isEqualToString:@"已经签约"];
            [Verify saveContractStateToSandBox:contract.state];
            [Verify setPunchEnable:_punchEnable];
        } failBlock:^(NSString *errStr, NSInteger statusCode) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setCenter:self.view.center];
            if (statusCode == 404) {
                _punchEnable = NO;
                [Verify setPunchEnable:_punchEnable];
                [hud setMode:MBProgressHUDModeText];
                NSString *str = [NSString stringWithFormat:@"未签约"];
                EmployerM *emptyEmployer = [[EmployerM alloc]init];
                [Verify saveEmployerToSH:emptyEmployer];
                [hud setLabelText:str];
                [hud hide:YES afterDelay:2.0];
            }else{
                DLog(@"%ld",(long)statusCode);
                [hud hide:YES];
            }
        }];
}

/**
 *  获取合约信息
 */
- (void)getContractInfo{
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking huoQuDQHY:employee.ID token:tokens successBlock:^(ContractM *contract, EmployerM *employer) {
        _employer = employer;
        [Verify saveEmployerToSH:employer];
        _punchEnable = [contract.state isEqualToString:@"已经签约"];
        [Verify setPunchEnable:_punchEnable];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setCenter:self.view.center];
        if (statusCode == 404) {
            _punchEnable = NO;
            [Verify setPunchEnable:_punchEnable];
            NSString *str = [NSString stringWithFormat:@"未签约"];
            EmployerM *emptyEmployer = [[EmployerM alloc]init];
            [Verify saveEmployerToSH:emptyEmployer];
            [hud setLabelText:str];
            [hud hide:YES afterDelay:2.0];
        }else{
            NSString *str = [NSString stringWithFormat:@"请检查网络"];
            DLog(@"%ld",(long)statusCode);
            [hud setLabelText:str];
            [hud hide:YES afterDelay:2.0];
        }
    }];
}

- (void)judgeLocationEnable{
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        DLog(@"定位服务未开启");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setCenter:self.view.center];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:@"请开启定位服务"];
        [hud hide:YES afterDelay:1.5];
    }else{
        DLog(@"定位服务已开启");
        [self goToPunch];
    }
}

/**
 *  定时器显示时间
 */
- (void)updateTime{
    _timer =  [HWWeakTimer scheduledTimerWithTimeInterval:1.0f block:^(id userInfo) {
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
        timeFormat.dateFormat = @"HH:mm";
        NSString *timeStr = [timeFormat stringFromDate:nowDate];
        self.timeLabel.text = timeStr;
        NSDateFormatter *dayFormat = [[NSDateFormatter alloc]init];
        dayFormat.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [dayFormat stringFromDate:nowDate];
        NSString *weekDay = [Verify weekdayStringFromDate:nowDate];
        NSString *showStr = [NSString stringWithFormat:@"%@   %@",dateString,weekDay];
        self.dateLabel.text = showStr;
    } userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)leftBtnPressed{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {

    }];
}

- (void)rightBtnPressed{
    Record *recordVC = [[Record alloc]init];
    BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
    [navi pushViewController:recordVC animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}

- (void)goToPunch{
    if (self.punchEnable) {
        if ([Verify getFirstCapture]) {
            FirstCapture *fc = [[FirstCapture alloc]init];
            [self.navigationController pushViewController:fc animated:YES];
        }else{
            EmployeeM *employee = [Verify getEmployeeFromSandBox];
            PunchCameraVC *cam = [[PunchCameraVC alloc]init];;
            cam.naviTitle = [NSString stringWithFormat:@"%@打卡",employee.name];
            [self.navigationController pushViewController:cam animated:YES];
        }
    }else{
        [self getContractInfo];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setCenter:self.view.center];
        NSString *state = [Verify getContractStateToSandBox];
        NSString *str = @" ";
        if ([state isEqualToString:@"已经签约"]) {
            str = [NSString stringWithFormat:@"服务器连接失败请重试"];
        }else{
            str = [NSString stringWithFormat:@"请检查合约"];
        }
        [hud setLabelText:str];
        [hud hide:YES afterDelay:1.2];
    }
}

#pragma mark-页面布局
- (void)setUpUI{
    __weak typeof (self) weakSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(200 * ratio + 64);
    }];
    [self.view addSubview:self.bottomImageView];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(135 * ratio);
    }];
    [self.view addSubview:self.punchyBtn];
    [self.punchyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(111 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-80 * ratio);
    }];

    [self.view addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.centerY.mas_equalTo(weakSelf.backImageView.mas_centerY).offset(20);
        make.width.mas_equalTo(240 * ratio);
        make.height.mas_equalTo(40 * ratio);
    }];
    [self.view addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.timeLabel.mas_bottom).offset(17 * ratio);
        make.width.mas_equalTo(200 * ratio);
        make.height.mas_equalTo(15 * ratio);
    }];

    //设置灰色遮罩
    UIView *blackView = [[UIView alloc]initWithFrame:self.view.frame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.0;
    [self.view addSubview:blackView];
    [self.mm_drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        [blackView setAlpha:(percentVisible -  0.4)];
    }];
}




- (void)setNavigation{
    self.navigationItem.title = @"打卡";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

#pragma mark-控件设置
- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clockin_topbg"]];
    }
    return _backImageView;
}

- (UIImageView *)bottomImageView{
    if (_bottomImageView == nil) {
        _bottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clockin_bg"]];
    }
    return _bottomImageView;
}

- (UIBarButtonItem *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_more"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnPressed)];
    }
    return _leftBtn;
}

- (UIBarButtonItem *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"打卡记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnPressed)];
    }
    return _rightBtn;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont boldSystemFontOfSize:44];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
        timeFormat.dateFormat = @"HH:mm";
        NSString *timeStr = [timeFormat stringFromDate:nowDate];
        _timeLabel.text = timeStr;
    }
    return _timeLabel;
}

- (UILabel *)dateLabel{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc]init];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dayFormat = [[NSDateFormatter alloc]init];
        dayFormat.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [dayFormat stringFromDate:nowDate];
        NSString *weekDay = [Verify weekdayStringFromDate:nowDate];
        NSString *showStr = [NSString stringWithFormat:@"%@   %@",dateString,weekDay];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = showStr;
    }
    return _dateLabel;
}

- (UIButton *)punchyBtn{
    if (_punchyBtn == nil) {
        _punchyBtn = [[UIButton alloc]init];
        [_punchyBtn setBackgroundImage:[UIImage imageNamed:@"button_clockin"] forState:UIControlStateNormal];
        _punchyBtn.layer.cornerRadius = 47.0;
        [_punchyBtn addTarget:self action:@selector(judgeLocationEnable) forControlEvents:UIControlEventTouchUpInside];
    }
    return _punchyBtn;
}


-(void)dealloc {
    //**timer定时器*/
    [_timer invalidate];
    DLog(@"%@ dealloc", NSStringFromClass([self class]));
}
@end
