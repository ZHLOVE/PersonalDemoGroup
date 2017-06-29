//
//  MainVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "MainVC.h"
#import "MainLeftVC.h"
#import "HWWeakTimer.h"
#import "Login.h"
#import "PunchCameraVC.h"
#import "FirstCapture.h"
#import "GuideVC.h"
#import "Record.h"
#import "BaseNavigationCongroller.h"
#import "CompanyListTableView.h"
#import "AuditingVC.h"
#import "JPUSHService.h"
#import "CustomPopView.h"


@interface MainVC ()
@property(nonatomic,strong) UIView *backGreenView;
@property(nonatomic,strong) CAGradientLayer *greenLayer;
@property(nonatomic,strong) UIImageView *bottomImageView;
@property(nonatomic,strong) UIBarButtonItem *leftBtn;
@property(nonatomic,strong) UIBarButtonItem *rightBtn;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UIView *blackView;
@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic,assign) BOOL punchEnable;
@property(nonatomic,strong) CustomPopView *popView;
@property(nonatomic,strong) UIButton *popViewCloseBtn;
@property(nonatomic,strong) EmployeeM *employee;
@property(nonatomic,strong) EmployerM *employer;
@property(nonatomic,strong) TokensM *tokens;
@property(nonatomic,strong) UIButton *guideView;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UIImageView *barImageView;

@end


@implementation MainVC

- (void)viewWillLayoutSubviews{
    self.greenLayer.frame = self.backGreenView.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self updateTime];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground)name:UIApplicationWillEnterForegroundNotification object:nil];
    [self setNavigation];
    [self checkAccessToken];
    [self getContractInfoWithContract:^(ContractM *contract) {}];
    [self checkShare];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self showGuideView:@"bg-1"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillEnterForeground{
    [self checkWifi];
}

- (void)checkAccessToken{
    BOOL accessToken = [Verify checkAccessToken];
    if (!accessToken) {
        Login *vc = [[Login alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        //用户ID作为极光别名，用于定向推送
        EmployeeM *employeeInfo =  [Verify getEmployeeFromSandBox];
        [JPUSHService setAlias:employeeInfo.ID callbackSelector:nil object:self];
        //检查版本
        [self checkVersion];
    }
}

- (void)checkWifi{
    if ([Verify isWiFiEnabled]) {
        DLog(@"Wifi开关已开启");
    }else{
        DLog(@"请打开Wifi提高定位精度");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = @"请打开Wifi提高定位精度";
        [hud hideAnimated:YES afterDelay:1.5];
    }
}

/**
 *  检查分享
 */
- (void)checkShare{
    [Networking shareEnableSuccessBlock:^(NSString *shareStr) {
        DLog(@"checkShare: %@",shareStr);
        [Verify saveShareEnable:shareStr];
    } failBlock:^(NSInteger statusCode, NSString *errStr) {
        DLog(@"%ld,%@",(long)statusCode,errStr);
    }];
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
    self.employee = [Verify getEmployeeFromSandBox];
    self.tokens = [Verify getTokenFromSanBox];
    [Networking huoQuGuYuanXinXi:self.employee.ID token:self.tokens successBlock:^(EmployeeM *emp){
        _employee = emp;
        [Verify saveEmployee:emp];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {

    }];
}

/**
 *  获取合约信息
 */
- (void)getContractInfoWithContract:(void (^)(ContractM *contract))contractBlock{
    __weak typeof(self) weakSelf = self;
    self.employee = [Verify getEmployeeFromSandBox];
    self.tokens = [Verify getTokenFromSanBox];
    [Networking huoQuDQHY:self.employee.ID token:self.tokens successBlock:^(ContractM *contract, EmployerM *employer) {
        [Verify saveContractStateToSandBox:contract.state];
        weakSelf.employer = employer;
        [Verify saveEmployerToSH:employer];
        weakSelf.punchEnable = [contract.state isEqualToString:@"已经签约"];
        [Verify setPunchEnable:_punchEnable];
        contractBlock(contract);
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        if (statusCode == 404) {
            contractBlock(nil);
            DLog(@"未签约%ld",(long)statusCode);
            EmployerM *emper = weakSelf.employer;
            emper.name = @" ";
            [Verify saveEmployerToSH:emper];
        }else{
            DLog(@"%ld,%@",(long)statusCode,errStr);
        }
    }];
}

/**
 *  检查时间变更
 */
- (void)checkWorkTimeChange{
    [Networking jianChaSJBG:self.employee.ID employerID:self.employer.ID token:self.tokens successBlock:^(ChangePeriod *change) {
        if (change.ID) {
            [self showTheChangePeriodCustiomView:change];
        }else{
            [self getTheWaring];
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        NSString *str = [NSString stringWithFormat:@"网络错误请重试"];
        DLog(@"%ld",(long)statusCode);
        hud.label.text = str;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
}

/**
 *  修改时间
 */
- (void)changePeriod:(UIButton *)btn{
    [self removeTheTipView];
    ChangePeriod *change = objc_getAssociatedObject(btn, "change");
    [Networking xiuGaiGZSJ:self.employee.ID periodID:change.ID token:self.tokens successBlock:^(PeriodM *p) {
        DLog(@"打卡时间修改成功");
        [self pushTheCamera];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        NSString *str = [NSString stringWithFormat:@"网络错误请重试"];
        DLog(@"打卡时间修改失败%ld",(long)statusCode);
        hud.label.text = str;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
}

/**
 *  警告显示
 */
- (void)getTheWaring{
    [Networking twentyfourCheckPoint:self.employee.ID token:self.tokens SuccessBlock:^(BOOL waring, PeriodM *period) {
        [self removeTheTipView];
        if (waring) {
            DLog(@"弹窗,%@",period);
            [self showTheWaringTipCustiomView:period];
        }else{
            DLog(@"不弹");
            [self pushTheCamera];
        }
    } failBlock:^(NSInteger statusCode, NSString *errStr) {
        DLog(@"%ld,%@",(long)statusCode,errStr);
    }];
}

/**
 *  警告显示弹窗
 */
- (void)showTheWaringTipCustiomView:(PeriodM *)period{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    self.blackView.alpha = 0.6;
    [window addSubview:self.blackView];
    NSString *changeTime = [NSString stringWithFormat:@"%@-%@",[period.begin_at substringWithRange:NSMakeRange(0, 5)],[period.end_at substringWithRange:NSMakeRange(0, 5)]];
    self.popView.waringTime = changeTime;
    [window addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(315 * ratio);
        make.height.mas_equalTo(280 * ratio);
        make.centerX.mas_equalTo(window.mas_centerX);
        make.centerY.mas_equalTo(window.mas_centerY);
    }];
    [self.popView.btnYES addTarget:self action:@selector(pushTheCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.popView.btnNO addTarget:self action:@selector(removeTheTipView) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  修改时间弹窗
 */
- (void)showTheChangePeriodCustiomView:(ChangePeriod *)change{
    __weak typeof(self) weakSelf = self;
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    self.blackView.alpha = 0.6;
    [self.navigationController.view addSubview:self.blackView];
    NSString *changeTime = [NSString stringWithFormat:@"%@-%@",[change.begin_at substringWithRange:NSMakeRange(0, 5)],[change.end_at substringWithRange:NSMakeRange(0, 5)]];
    self.popView.changeTime = changeTime;
    [self.navigationController.view addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(315 * ratio);
        make.height.mas_equalTo(280 * ratio);
        make.centerX.mas_equalTo(window.mas_centerX);
        make.centerY.mas_equalTo(window.mas_centerY);
    }];
    [self.navigationController.view addSubview:self.popViewCloseBtn];
    [self.popViewCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30 * ratio);
        make.right.mas_equalTo(weakSelf.popView.mas_right).offset(-10 * ratio);
        make.bottom.mas_equalTo(weakSelf.popView.mas_top).offset(-14 * ratio);
    }];
    objc_setAssociatedObject(self.popView.btnYES, "change", change, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.popView.btnYES addTarget:self action:@selector(changePeriod:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView.btnNO addTarget:self action:@selector(getTheWaring) forControlEvents:UIControlEventTouchUpInside];
    [self.popViewCloseBtn addTarget:self action:@selector(removeTheTipView) forControlEvents:UIControlEventTouchUpInside];
}



/**
 *  移除弹窗
 */
- (void)removeTheTipView{
    [self.popView.btnYES removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.popView.btnNO removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.blackView removeFromSuperview];
    [self.popView removeFromSuperview];
    [self.popViewCloseBtn removeFromSuperview];
}

/**
 * 判断定位开启
 */
- (void)judgeLocationEnable{
    self.punchyBtn.enabled = YES;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        DLog(@"定位服务未开启");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = @"请开启定位服务";
        [hud hideAnimated:YES afterDelay:1.5];
        self.punchyBtn.enabled = YES;
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
        timeFormat.dateFormat = @"HH:mm:ss";
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
/**
 * 打卡记录按钮
 */
- (void)rightBtnPressed{
    self.rightBtn.enabled = NO;
    [Networking huoQuDQHY:self.employee.ID token:self.tokens successBlock:^(ContractM *contract, EmployerM *employer) {
        self.rightBtn.enabled = YES;
        self.employer = employer;
        [Verify saveEmployerToSH:employer];
        if ([contract.state isEqualToString:@"等待合约审核"]) {
            [self gotoAuditingVC:contract];
        }else{
            [self gotoPunchRecordViewController];
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        self.rightBtn.enabled = YES;
        if (statusCode == 404) {
            [self gotoCompanyListVC];
        }else{
            DLog(@"%@%ld",errStr,(long)statusCode);
            EmployerM *emp = [[EmployerM alloc]init];
            emp.name = @" ";
            self.employer = emp;
            [Verify saveEmployerToSH:emp];
        }
    }];
}

/**
 * 进入打卡记录
 */
- (void)gotoPunchRecordViewController{
    Record *recordVC = [[Record alloc]init];
    BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
    [navi pushViewController:recordVC animated:YES];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}

/**
 * 进入相机
 */
- (void)pushTheCamera{
    [self removeTheTipView];
    PunchCameraVC *cam = [[PunchCameraVC alloc]init];;
    cam.naviTitle = [NSString stringWithFormat:@"%@打卡",self.employee.name];
    [self.navigationController pushViewController:cam animated:YES];
}

/**
 * 打卡
 */
- (void)goToPunch{
    [Networking huoQuDQHY:self.employee.ID token:self.tokens successBlock:^(ContractM *contract, EmployerM *employer) {
        _employer = employer;
        [Verify saveEmployerToSH:employer];
        BOOL establish = [contract.state isEqualToString:@"已经签约"];
        BOOL termination_requested = [contract.state isEqualToString:@"等待解约审核"];
        _punchEnable = establish || termination_requested;
        [Verify saveContractStateToSandBox:contract.state];
        [Verify setPunchEnable:_punchEnable];
        self.punchyBtn.enabled = YES;
        if (_punchEnable) {
            if ([Verify getFirstCapture]) {
                FirstCapture *fc = [[FirstCapture alloc]init];
                [self.navigationController pushViewController:fc animated:YES];
            }else{
                [self checkWorkTimeChange];
            }
        }else{
            if ([contract.state isEqualToString:@"等待合约审核"]) {
                [self gotoAuditingVC:contract];
            }
            EmployerM *emptyEmployer = [[EmployerM alloc]init];
            [Verify saveEmployerToSH:emptyEmployer];
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        self.punchyBtn.enabled = YES;
        if (statusCode == 404) {
            [hud hideAnimated:YES];
            _punchEnable = NO;
            [Verify setPunchEnable:_punchEnable];
            [self gotoCompanyListVC];
        }else{
            NSString *str = [NSString stringWithFormat:@"网络错误请重试"];
            DLog(@"%ld",(long)statusCode);
            hud.label.text = str;
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];
}


/**
 *  查看合约
 */
- (void)gotoAuditingVC:(ContractM *)contract{
    AuditingVC *au = [[AuditingVC alloc]init];
    au.contract = contract;
    au.employee = self.employee;
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
        [navi pushViewController:au animated:NO];
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}
/**
 *  公司列表
 */
- (void)gotoCompanyListVC{
    CompanyListTableView *com = [[CompanyListTableView alloc]init];
    com.employee = self.employee;
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
        [navi pushViewController:com animated:NO];
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}
#pragma mark-页面布局
- (void)setUpUI{
    __weak typeof (self) weakSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backGreenView];
    [self.backGreenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(200 * ratio);
    }];
    [self.backGreenView.layer addSublayer:self.greenLayer];
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
        make.centerY.mas_equalTo(weakSelf.backGreenView.mas_centerY);
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
    UIView *rightBlackView = [[UIView alloc]initWithFrame:self.view.frame];
    rightBlackView.backgroundColor = [UIColor blackColor];
    rightBlackView.alpha = 0.0;
    [self.navigationController.view addSubview:rightBlackView];
    [self.mm_drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        [rightBlackView setAlpha:(percentVisible -  0.4)];
        if (percentVisible == 1) {
            [weakSelf showGuideView:@"bg-3"];
        }
    }];
}

/**
 *  新手引导
 */
- (void)showGuideView:(NSString *)imgName{
    GuideShow *show = [Verify getGuideShow];
    if ([imgName isEqualToString:@"bg-1"]) {
        if (show.mainGuide) {
            return;
        }else{
            DLog(@"首次显示");
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
            UIButton *imgView = [[UIButton alloc]init];
            [imgView setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            [imgView setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
            self.guideView = imgView;
            imgView.frame = [UIScreen mainScreen].bounds;
            [self.navigationController.view addSubview:imgView];
            UIButton *closeBtn = [[UIButton alloc]init];
            self.closeBtn = closeBtn;
            [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭提示"] forState:UIControlStateNormal];
            closeBtn.frame = CGRectMake(235*ratio, 591*ratio, 118*ratio, 41*ratio);
            [self.navigationController.view addSubview:closeBtn];
            objc_setAssociatedObject(closeBtn, "imgName", imgName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [closeBtn addTarget:self action:@selector(removeGuideView:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        if (show.slideGuide) {
            return;
        }else{
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
            UIButton *imgView = [[UIButton alloc]init];
            [imgView setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            [imgView setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateHighlighted];
            self.guideView = imgView;
            UIWindow *win = [[[UIApplication sharedApplication] windows] lastObject];
            imgView.frame = win.frame;
            [win addSubview:imgView];
            UIButton *closeBtn = [[UIButton alloc]init];
            self.closeBtn = closeBtn;
            [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭提示"] forState:UIControlStateNormal];
            closeBtn.frame = CGRectMake(235*ratio, 591*ratio, 118*ratio, 41*ratio);
            [win addSubview:closeBtn];
            objc_setAssociatedObject(closeBtn, "imgName", imgName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [closeBtn addTarget:self action:@selector(removeGuideView:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)removeGuideView:(UIButton *)btn{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    NSString *imgName = objc_getAssociatedObject(btn, "imgName");
    GuideShow *show = [Verify getGuideShow];
    if ([imgName isEqualToString:@"bg-1"]) {
        show.mainGuide = YES;
    }else{
        show.slideGuide = YES;
    }
    [self.guideView removeFromSuperview];
    [self.closeBtn removeFromSuperview];
    [Verify setGuideShow:show];
}


- (void)setNavigation{
    self.navigationItem.title = @"打卡";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

#pragma mark-控件设置
- (UIView *)backGreenView{
    if (_backGreenView == nil) {
        _backGreenView = [[UIView alloc]init];
    }
    return _backGreenView;
}

- (CAGradientLayer *)greenLayer{
    if (_greenLayer == nil) {
        _greenLayer = [CAGradientLayer layer];
        _greenLayer.colors = @[(id)[UIColor colorWithHexString:@"#0edf6f"].CGColor,
                              (id)[UIColor colorWithHexString:@"#02ca72"].CGColor];
        _greenLayer.locations = @[@(0.0f),@(1.0f)];
        _greenLayer.startPoint = CGPointMake(0,0);
        _greenLayer.endPoint = CGPointMake(1, 0);
    }
    return _greenLayer;
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
        timeFormat.dateFormat = @"HH:mm:ss";
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

- (UIView *)blackView{
    if (_blackView == nil) {
        _blackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0.0;
    }
    return _blackView;
}

- (CustomPopView *)popView{
    if (_popView == nil) {
        _popView = [[CustomPopView alloc]init];
        _popView.layer.cornerRadius = 7;
        _popView.layer.masksToBounds = YES;
    }
    return _popView;
}

- (UIButton *)popViewCloseBtn{
    if (_popViewCloseBtn == nil) {
        _popViewCloseBtn = [[UIButton alloc]init];
        [_popViewCloseBtn setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    }
    return _popViewCloseBtn;
}

- (EmployeeM *)employee{
    if (_employee.ID == nil) {
        _employee = [Verify getEmployeeFromSandBox];
    }
    return _employee;
}

- (EmployerM *)employer{
    if (_employer.ID == nil) {
        _employer = [Verify getEmployerFromSH];
    }
    return _employer;
}

- (TokensM *)tokens{
    if (_tokens.access_token == nil) {
        _tokens = [Verify getTokenFromSanBox];
    }
    return _tokens;
}



-(void)dealloc {
    //**timer定时器*/
    [_timer invalidate];
    DLog(@"%@ dealloc", NSStringFromClass([self class]));
}
@end
