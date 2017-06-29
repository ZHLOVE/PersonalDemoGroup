//
//  Record.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Record.h"
#import "FSCalendar.h"
#import "FSCalendarExtensions.h"
#import "UIViewController+MMDrawerController.h"
#import "RecordHeadView.h"
#import "NormalTableViewCell.h"
#import "RecordTableViewCell.h"
#import "PunchCameraVC.h"
#import "MJExtension.h"
#import "FirstCapture.h"
#import "MainVC.h"
#import "BaseNavigationCongroller.h"
#import "CustomPopView.h"


@interface Record ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource, FSCalendarDelegateAppearance>

@property(nonatomic,strong) EmployeeM *employee;
@property(nonatomic,strong) EmployerM *employer;
@property(nonatomic,strong) TokensM *tokens;
@property(nonatomic,assign) BOOL punchEnable;
@property(nonatomic,strong) NSCalendar *gregorian;
@property(nonatomic,strong) NSDateFormatter *formatter;
@property(nonatomic,strong) UIBarButtonItem *leftBtn;
@property(nonatomic,strong) FSCalendar *calender;
@property(nonatomic,strong) UIView *backBottomView;
@property(nonatomic,strong) UIButton *previousButton;
@property(nonatomic,strong) UIButton *nextButton;
@property(nonatomic,strong) UIView *kgCircleView;
@property(nonatomic,strong) UIView *cdCircleView;
@property(nonatomic,strong) UIView *zcCircleView;
@property(nonatomic,strong) UILabel *kgLabel;
@property(nonatomic,strong) UILabel *cdLabel;
@property(nonatomic,strong) UILabel *zcLabel;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) RecordHeadView *recHeadView;
@property(nonatomic,strong) UIButton *punchyBtn;
@property(nonatomic,strong) PageM *page;
@property(nonatomic,strong) PunchesGather *punchGather;
@property(nonatomic,strong) CustomPopView *popView;
@property(nonatomic,strong) UIButton *popViewCloseBtn;
@property(nonatomic,strong) UIView *blackView;
@property(nonatomic,strong) UIButton *guideView;
@property(nonatomic,strong) UIButton *closeBtn;


/**
 *  默认时要填充色的数组（迟到与早退需要填充色）
 */
@property(nonatomic,strong) NSMutableDictionary *fillDaysColors;
/**
 *  选中时要填充色的数组（迟到与早退需要填充色）
 */
@property(nonatomic,strong) NSMutableDictionary *fillDaysSelectColors;
/**
 *  点击选中的边框
 */
@property(nonatomic,strong) NSMutableDictionary *borderDaysColors;
/**
 *  默认选中的边框
 */
@property(nonatomic,strong) NSMutableDictionary *borderDaysDefaultColors;

/**
 *  默认有打卡记录的文字
 */
@property(nonatomic,strong) NSMutableDictionary *normalTitleRecordDefaultColor;
/**
 *  每日打卡数据，给TableView提供数据
 */
@property(nonatomic,strong) NSMutableArray *dayPunchListArray;
/**
 *  Allpunch模型数组
 */
@property(nonatomic,strong) NSMutableDictionary *punchMonthDict;
/**
 *  每日状态，设置颜色时候用
 */
@property(nonatomic,strong) NSMutableDictionary *allDayStateDict;

/**
 *  既旷工又早退
 */
@property(nonatomic,strong) NSMutableArray *absentAndLaterArray;


@end
//显示当天打卡详细标志位
static BOOL showDetailList;
//旷工的颜色
static UIColor *absentFillDefulColor;
static UIColor *absentFillSelectColor;
static UIColor *absentBordColor;
//迟到的颜色
static UIColor *laterFillDefulColor;
static UIColor *laterFillSelectColor;
static UIColor *laterBordColor;
//正常的颜色
static UIColor *normalFillDefulColor;
static UIColor *normalFillSelectColor;
static UIColor *normalBordColor;
//文字的颜色
static UIColor *normalTitleSelectColor;
static UIColor *titleSpecialColor;

@implementation Record

- (instancetype)init
{
    self = [super init];
    if (self) {
        showDetailList = NO;
        absentFillDefulColor = [UIColor colorWithHexString:@"#F9E6DF"];
        absentFillSelectColor = [UIColor colorWithHexString:@"#FD936F"];
        absentBordColor = [UIColor colorWithHexString:@"#FFFFFF"];

        laterFillDefulColor = [UIColor colorWithHexString:@"#FBF2DD"];
        laterFillSelectColor = [UIColor colorWithHexString:@"#FBCE64"];
        laterBordColor = [UIColor colorWithHexString:@"#FFFFFF"];

        normalFillDefulColor = [UIColor colorWithHexString:@"#DDF6E9"];
        normalFillSelectColor = [UIColor colorWithHexString:@"#00C46D"];
        normalBordColor = [UIColor colorWithHexString:@"#FFFFFF"];

        normalTitleSelectColor = [UIColor colorWithHexString:@"#666666"];
        titleSpecialColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    showDetailList = NO;
    NSDateFormatter *format = self.formatter;
    NSDate *beDate = [self.gregorian fs_firstDayOfMonth:self.calender.today];
    NSDate *enDate = [self.gregorian fs_lastDayOfMonth:self.calender.today];
    NSString *beginDay = [format stringFromDate:beDate];
    NSString *endDay = [format stringFromDate:enDate];
    [self loadLastDataWithBeginDay:beginDay andEndDay:endDay];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showGuideView];
}

- (void)backBtnPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  获取当前月份打卡记录
 */
- (void)loadLastDataWithBeginDay:(NSString *)begin andEndDay:(NSString *)end{
    __weak typeof(self) weakSelf = self;
    showDetailList = NO;
    if (self.tokens.access_token) {
        [Networking daKaJiLu:self.employee.ID token:self.tokens beginDay:begin endDay:end successBlock:^(NSDictionary *punchDict,PunchesGather *punchGather) {
            weakSelf.punchMonthDict = [punchDict mutableCopy];
            for (NSString *key in punchDict.allKeys) {
                NSMutableArray *array = [[punchDict objectForKey:key] mutableCopy];
                NSString *today = [weakSelf.formatter stringFromDate:weakSelf.calender.today];
                switch (array.count) {
                    case 0:
                        break;
                    case 1:
                        if ([key isEqualToString:today]) {
                            [weakSelf allDayStateSetDictWithArray:array dayKey:key];
                        }else{
                            [weakSelf.allDayStateDict setObject:@"absent_accepted" forKey:key];
                        }
                        break;
                    case 2:
                        [weakSelf allDayStateSetDictWithArray:array dayKey:key];
                        break;
                    default:break;
                }
            }
            [weakSelf fillDaySetFromDayAttenceState];
            [weakSelf.calender reloadData];
            _punchGather = punchGather;
            [weakSelf.tableView reloadData];
        } failBlock:^(NSString *errStr, NSInteger statusCode) {
            DLog(@"%ld%@",(long)statusCode,errStr);
            [weakSelf.calender selectDate:weakSelf.calender.currentPage];
            [weakSelf.calender reloadData];
            _punchGather = nil;
            [weakSelf.tableView reloadData];
        }];
    }
}

/**
 *  获取工作时间
 */
- (void)getWorkTime{
    __weak typeof(self) weakSelf = self;
    [Networking huoQuGZSJ:self.employee.ID token:self.tokens successBlock:^(PeriodM *p) {
        if (p != nil) {
            weakSelf.recHeadView.period = p;
            [weakSelf.tableView reloadData];
        }else{
            DLog(@"获取工作时间异常");
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        DLog(@"%ld,%@",(long)statusCode,errStr);
    }];
}

/**
 *  获取每月汇总(已经废弃)
 */
- (void)loadPunchGatherWithBeginDay:(NSString *)begin andEndDay:(NSString *)end{
    showDetailList = NO;
    __weak typeof(self) weakSelf = self;
    DLog(@"begin:%@,end:%@",begin,end);
    if (self.tokens.access_token) {
        [Networking huoQuDaKaHuiZong:self.employee.ID token:self.tokens beginDay:begin endDay:end successBlock:^(PunchesGather *punchGather) {
            _punchGather = punchGather;
            [weakSelf.tableView reloadData];
        } failBlock:^(NSString *errStr, NSInteger statusCode) {
            DLog(@"%ld%@",(long)statusCode,errStr);
            _punchGather = nil;
            [weakSelf.tableView reloadData];
        }];
    }

}


/**
 *  根据每天打卡记录的attence_state对当天圈圈颜色设置value
 *  key是日期，value是颜色
 */
- (void)allDayStateSetDictWithArray:(NSArray *)array dayKey:(NSString *)key{
    NSMutableArray *attenctStateArray = [NSMutableArray array];
    for (NSDictionary *tempDict in array) {
        [attenctStateArray addObject:tempDict[@"attence_state"]];
    }
    BOOL absent = [attenctStateArray containsObject: @"absent_accepted"];
    BOOL late = [attenctStateArray containsObject:@"late_accepted"];
    BOOL early = [attenctStateArray containsObject:@"early_accepted"];
    BOOL normal = [attenctStateArray containsObject:@"normal_accepted"];
    if (absent) {
        if (late || early) {
            [self.absentAndLaterArray addObject:key];
            [self.allDayStateDict setObject:@"absent_later" forKey:key];
        }else{
            [self.allDayStateDict setObject:@"absent_accepted" forKey:key];
        }
    }else if (late || early){
        [self.allDayStateDict setObject:@"late_accepted" forKey:key];
    }else if (normal){
        [self.allDayStateDict setObject:@"normal_accepted" forKey:key];
    }
}

/**
 *  根据day_attence_state对日历设置
 *  设置规则依旧是以日期为key，颜色为value；
 *  switch从数组中匹配index
 *  [self.fillDaysColors setObject:absentFillDefulColor forKey:@"2016-09-02"];
 */
- (void)fillDaySetFromDayAttenceState{
    NSArray *statesArray = @[@"normal_accepted", @"late_accepted", @"early_accepted",@"absent_accepted",@"absent_later"];
    for (NSString *key in self.allDayStateDict.allKeys) {
        NSUInteger index = [statesArray indexOfObject:self.allDayStateDict[key]];
        switch (index) {
            case 0:
                [self.borderDaysDefaultColors setObject:normalBordColor forKey:key];
                [self.fillDaysColors setObject:normalFillDefulColor forKey:key];
                [self.fillDaysSelectColors setObject:normalFillSelectColor forKey:key];
                [self.normalTitleRecordDefaultColor setObject:normalTitleSelectColor forKey:key];
                break;
            case 1:
                [self.borderDaysColors setObject:laterBordColor forKey:key];
                [self.fillDaysColors setObject:laterFillDefulColor forKey:key];
                [self.fillDaysSelectColors setObject:laterFillSelectColor forKey:key];
                [self.normalTitleRecordDefaultColor setObject:normalTitleSelectColor forKey:key];
                break;
            case 2:
                [self.borderDaysColors setObject:laterBordColor forKey:key];
                [self.fillDaysColors setObject:laterFillDefulColor forKey:key];
                [self.fillDaysSelectColors setObject:laterFillDefulColor forKey:key];
                [self.normalTitleRecordDefaultColor setObject:normalTitleSelectColor forKey:key];
                break;
            case 3:
                [self.borderDaysColors setObject:absentBordColor forKey:key];
                [self.fillDaysColors setObject:absentFillDefulColor forKey:key];
                [self.fillDaysSelectColors setObject:absentFillSelectColor forKey:key];
                [self.normalTitleRecordDefaultColor setObject:normalTitleSelectColor forKey:key];
            case 4:
                [self.fillDaysColors setObject:absentFillDefulColor forKey:key];
                [self.fillDaysSelectColors setObject:absentFillSelectColor forKey:key];
                [self.normalTitleRecordDefaultColor setObject:normalTitleSelectColor forKey:key];
                break;
        }
    }
}



- (void)previousClicked{
    NSDate *currentMonth =  self.calender.currentPage;
    NSDate *preMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calender setCurrentPage:preMonth animated:YES];
}

- (void)nextClicked{
    NSDate *currentMonth =  self.calender.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calender setCurrentPage:nextMonth animated:YES];
}


#pragma mark-FSCalendarDelegateAppearance
/**
 *  动态调整日历行数
 */
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    self.backBottomView.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame), screenWidth, self.view.frame.size.height - calendar.frame.size.height);
}
/**
 *  设置固定日期的默认填充颜色
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    NSString *key = [self.formatter stringFromDate:date];
    NSArray *allKeys = self.fillDaysColors.allKeys;
    if ([allKeys containsObject:key]) {
        UIColor *color = self.fillDaysColors[key];
        return color;
    }
    return nil;
}

/**
 *  设置固定日期选中时的填充颜色
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
    NSString *key = [self.formatter stringFromDate:date];
    NSArray *allKeys = self.fillDaysSelectColors.allKeys;
    if ([allKeys containsObject:key]) {
        UIColor *color = self.fillDaysSelectColors[key];
        return color;
    }
    return nil;
}

/**
 *  设置固定日期的默认边框颜色
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date{
    NSString *key = [self.formatter stringFromDate:date];
    NSArray *allKeys = self.borderDaysDefaultColors.allKeys;
    if ([allKeys containsObject:key]) {
        UIColor *color = self.borderDaysDefaultColors[key];
        return color;
    }
    return nil;
}
/**
 *  设置固定日期的选中时边框颜色
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date{
    NSString *key = [self.formatter stringFromDate:date];
    NSArray *allKeys = self.borderDaysColors.allKeys;
    if ([allKeys containsObject:key]) {
        UIColor *color = self.borderDaysColors[key];
        return color;
    }
    return nil;
}

/**
 *  设置默认日期的文字颜色
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    NSString *key = [self.formatter stringFromDate:date];
    NSArray *allKeys = self.normalTitleRecordDefaultColor.allKeys;
    if ([allKeys containsObject:key]) {
        UIColor *color = self.normalTitleRecordDefaultColor[key];
        return color;
    }
    return nil;
}

/**
 *  设置固定日期选中的文字颜色
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    NSString *key = [self.formatter stringFromDate:date];
    NSArray *allKeys = self.fillDaysSelectColors.allKeys;
    if ([allKeys containsObject:key]) {
        return [UIColor whiteColor];
    }
    return nil;
}



/**
 *  点击日期
 */
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    [self getWorkTime];
    NSDateFormatter *formatter = self.formatter;
    [formatter setDateFormat:@"M月d日"];
    NSString *day = [formatter stringFromDate:date];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *selectDay = [formatter stringFromDate:date];
    NSString *wd = [Verify weekdayStringFromDate:date];
    NSString *str = [NSString stringWithFormat:@"%@ %@",day,wd];
    [self.dayPunchListArray removeAllObjects];
    NSArray *arr = self.punchMonthDict[selectDay];
    self.dayPunchListArray = [Punch mj_objectArrayWithKeyValuesArray:arr];
    if (self.dayPunchListArray.count > 0) {
        showDetailList = YES;
        self.recHeadView.titleLabel.text = str;
    }else{
        showDetailList = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        NSString *str = [NSString stringWithFormat:@"当天没有打卡记录"];
        hud.label.text = str;
        [hud hideAnimated:YES afterDelay:0.7];
    }
    [self.tableView reloadData];
}


/**
 *  切换月份
 */
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    NSDate *beDate = [self.gregorian fs_firstDayOfMonth:calendar.currentPage];
    NSDate *enDate = [self.gregorian fs_lastDayOfMonth:calendar.currentPage];
    NSString *monBeginDay = [self.formatter stringFromDate:beDate];
    NSString *monEndDay = [self.formatter stringFromDate:enDate];
    [self loadLastDataWithBeginDay:monBeginDay andEndDay:monEndDay];
}

#pragma mark-打卡业务
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    [window addSubview:self.blackView];
    NSString *changeTime = [NSString stringWithFormat:@"%@-%@",[change.begin_at substringWithRange:NSMakeRange(0, 5)],[change.end_at substringWithRange:NSMakeRange(0, 5)]];
    self.popView.changeTime = changeTime;
    [window addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(315 * ratio);
        make.height.mas_equalTo(280 * ratio);
        make.centerX.mas_equalTo(window.mas_centerX);
        make.centerY.mas_equalTo(window.mas_centerY);
    }];
    [window addSubview:self.popViewCloseBtn];
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
 * 进入相机
 */
- (void)pushTheCamera{
    [self removeTheTipView];
    PunchCameraVC *cam = [[PunchCameraVC alloc]init];;
    cam.naviTitle = [NSString stringWithFormat:@"%@打卡",self.employee.name];
    [self.navigationController pushViewController:cam animated:YES];
}

/**
 * 判断定位开启
 */
- (void)judgeLocationEnable{
    self.punchyBtn.enabled = NO;
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
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
        self.punchyBtn.enabled = YES;
        if (_punchEnable) {
            if ([Verify getFirstCapture]) {
                FirstCapture *fc = [[FirstCapture alloc]init];
                [self.navigationController pushViewController:fc animated:YES];
            }else{
                [self checkWorkTimeChange];
            }
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            [hud setMode:MBProgressHUDModeText];
            NSString *str = [NSString stringWithFormat:@" "];
            if ([contract.state isEqualToString:@"等待合约审核"]) {
                str = @"您的HR尚未同意您加入公司";
            }
            if (contract.state == nil) {
                str = @"请先加入公司";
            }
            EmployerM *emptyEmployer = [[EmployerM alloc]init];
            [Verify saveEmployerToSH:emptyEmployer];
            hud.label.text = str;
            [hud hideAnimated:YES afterDelay:1.5];
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.punchyBtn.enabled = YES;
        if (statusCode == 404) {
            _punchEnable = NO;
            [Verify setPunchEnable:_punchEnable];
            [hud setMode:MBProgressHUDModeText];
            NSString *str = [NSString stringWithFormat:@"获取合约信息失败，请重试"];
            EmployerM *emptyEmployer = [[EmployerM alloc]init];
            [Verify saveEmployerToSH:emptyEmployer];
            hud.label.text = str;
            [hud hideAnimated:YES afterDelay:1.5];
        }else{
            self.punchyBtn.enabled = YES;
            [hud setMode:MBProgressHUDModeText];
            NSString *str = [NSString stringWithFormat:@"网络错误请重试"];
            DLog(@"%ld",(long)statusCode);
            hud.label.text = str;
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];

}


#pragma mark-TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (showDetailList) {
        return 2;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (showDetailList && section == 1) {
        return self.dayPunchListArray.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (showDetailList && indexPath.section == 1) {
        return 89 * ratio;
    }else{
        return 136 * ratio;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 46 * ratio;
    }else{
        return 0;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (showDetailList && section == 1) {
        return self.recHeadView;
    }else{
        return nil;
    }
}

#pragma mark-TableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (showDetailList && indexPath.section == 1) {
        //复用单元格
        NSString *reCellID = [NSString stringWithFormat:@"reCell%lu%lu",(long)indexPath.row,(long)indexPath.section];
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reCellID];
        if (!cell) {
            cell =[[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reCellID];
        }
        cell.punchInfo = self.dayPunchListArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSString *cellID = [NSString stringWithFormat:@"norCell%lu%lu",(long)indexPath.row,(long)indexPath.section];
        NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            NormalTableViewCell *cell = [[NormalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            return cell;
        }
        cell.punchGather = self.punchGather;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark-设置tableView
- (void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
#pragma mark-布局设置
- (void)setUpUI{
    self.navigationItem.title = @"打卡记录";
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    __weak typeof (self) weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    [self.view addSubview:self.calender];
    [self.view addSubview:self.previousButton];
    [self.previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(73 * ratio);
        make.top.mas_equalTo(weakSelf.view).offset(11 * ratio);
        make.width.mas_equalTo(80);
    }];
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view).offset(-73 * ratio);
        make.centerY.mas_equalTo(weakSelf.previousButton.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    [self.view addSubview:self.backBottomView];
    [self.backBottomView addSubview:self.kgCircleView];

    [self.kgCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(12);
        make.centerY.mas_equalTo(weakSelf.backBottomView.mas_top).offset(22 * ratio);
        make.left.mas_equalTo(weakSelf.view).offset(18 *ratio);
    }];
    [self.backBottomView addSubview:self.kgLabel];
    [self.kgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.mas_equalTo(12 * ratio);
        make.left.mas_equalTo(weakSelf.kgCircleView.mas_right).offset(10 * ratio);
    }];
    [self.backBottomView addSubview:self.cdCircleView];
    [self.cdCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.width.mas_equalTo(weakSelf.kgCircleView);
        make.left.mas_equalTo(weakSelf.kgLabel.mas_right).offset(28 * ratio);
    }];
    [self.backBottomView addSubview:self.cdLabel];
    [self.cdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.mas_equalTo(12 * ratio);
        make.left.mas_equalTo(weakSelf.cdCircleView.mas_right).offset(10 * ratio);
    }];
    [self.backBottomView addSubview:self.zcCircleView];
    [self.zcCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.width.mas_equalTo(weakSelf.kgCircleView);
        make.left.mas_equalTo(weakSelf.cdLabel.mas_right).offset(28 * ratio);
    }];
    [self.backBottomView addSubview:self.zcLabel];
    [self.zcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.mas_equalTo(12 * ratio);
        make.left.mas_equalTo(weakSelf.zcCircleView.mas_right).offset(10 * ratio);
    }];
    [self.backBottomView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.backBottomView.mas_top).offset(44 * ratio);
        make.bottom.mas_equalTo(weakSelf.backBottomView.mas_bottom);
    }];
    [self.view addSubview:self.punchyBtn];
    [self.punchyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(80 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-28 * ratio);
        make.bottom.mas_equalTo(weakSelf.view).offset(-20 * ratio);
    }];
}

/**
 *  新手引导
 */
- (void)showGuideView{
    GuideShow *show = [Verify getGuideShow];
    if (show.punchRecordGuide) {
        return;
    }else{
        DLog(@"首次显示");
        UIButton *imgView = [[UIButton alloc]init];
        [imgView setBackgroundImage:[UIImage imageNamed:@"bg-2"] forState:UIControlStateNormal];
        [imgView setBackgroundImage:[UIImage imageNamed:@"bg-2"] forState:UIControlStateHighlighted];
        self.guideView = imgView;
        imgView.frame = [UIScreen mainScreen].bounds;
        [self.navigationController.view addSubview:imgView];
        UIButton *closeBtn = [[UIButton alloc]init];
        self.closeBtn = closeBtn;
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭提示"] forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(235*ratio, 591*ratio, 118*ratio, 41*ratio);
        [self.navigationController.view addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(removeGuideView) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)removeGuideView{
    GuideShow *show = [Verify getGuideShow];
    show.punchRecordGuide = YES;
    [self.guideView removeFromSuperview];
    [self.closeBtn removeFromSuperview];
    [Verify setGuideShow:show];
}


#pragma mark-控件设置
- (FSCalendar *)calender{
    if (_calender == nil) {
        _calender = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 300)];
        _calender.backgroundColor = [UIColor whiteColor];
        _calender.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
        _calender.appearance.headerMinimumDissolvedAlpha = 0;
        _calender.appearance.headerDateFormat = @"yyyy年MM月";
        [_calender.appearance setHeaderTitleColor:[UIColor colorWithHexString:@"#444444"]];
        [_calender.appearance setWeekdayTextColor:[UIColor colorWithHexString:@"#999999"]];
        [_calender.appearance setWeekdayFont:[UIFont systemFontOfSize:14]];
        [_calender.appearance setTodayColor:[UIColor clearColor]];
        [_calender.appearance setTitleTodayColor:[UIColor colorWithHexString:@"#666666"]];
        [_calender.appearance setBorderSelectionColor:[UIColor clearColor]];
        [_calender.appearance setSelectionColor:[UIColor clearColor]];
        [_calender.appearance setTitleSelectionColor:[UIColor colorWithHexString:@"#666666"]];
        [_calender.appearance setTitlePlaceholderColor:[UIColor colorWithHexString:@"#d5d5d5"]];
        [_calender.appearance setTitleDefaultColor:[UIColor colorWithHexString:@"#666666"]];
        [_calender setAllowsSelection:YES];
        [_calender setAllowsMultipleSelection:NO];
        _calender.placeholderType = FSCalendarPlaceholderTypeNone;
        _calender.dataSource = self;
        _calender.delegate = self;
    }
    return _calender;
}

- (UIView *)backBottomView{
    if (_backBottomView == nil) {
        _backBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calender.frame), screenWidth, self.view.frame.size.height - self.calender.frame.size.height)];
        _backBottomView.backgroundColor = [UIColor clearColor];
    }
    return _backBottomView;
}

- (NSCalendar *)gregorian{
    if (_gregorian == nil) {
        _gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorian;
}

- (NSDateFormatter *)formatter{
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}

- (UIButton *)previousButton{
    if (_previousButton == nil) {
        _previousButton = [[UIButton alloc]init];
        [_previousButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_previousButton addTarget:self action:@selector(previousClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousButton;
}

- (UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [[UIButton alloc]init];
        [_nextButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

//默认的日期的填充色
- (NSMutableDictionary *)fillDaysColors{
    if (_fillDaysColors == nil) {
        _fillDaysColors = [NSMutableDictionary dictionary];
    }
    return _fillDaysColors;
}
//选中的日期的填充色
- (NSMutableDictionary *)fillDaysSelectColors{
    if (_fillDaysSelectColors == nil) {
        _fillDaysSelectColors = [NSMutableDictionary dictionary];
    }
    return _fillDaysSelectColors;
}
//选中的边框
- (NSMutableDictionary *)borderDaysColors{
    if (_borderDaysColors == nil) {
        _borderDaysColors = [NSMutableDictionary dictionary];
    }
    return _borderDaysColors;
}
//默认的边框
- (NSMutableDictionary *)borderDaysDefaultColors{
    if (_borderDaysDefaultColors == nil) {
        _borderDaysDefaultColors = [NSMutableDictionary dictionary];
    }
    return _borderDaysDefaultColors;
}

//默认有打卡记录的文字
- (NSMutableDictionary *)normalTitleRecordDefaultColor{
    if (_normalTitleRecordDefaultColor == nil) {
        _normalTitleRecordDefaultColor = [NSMutableDictionary dictionary];
    }
    return _normalTitleRecordDefaultColor;
}
- (UIView *)kgCircleView{
    if (_kgCircleView == nil) {
        _kgCircleView = [[UIView alloc]init];
        _kgCircleView.backgroundColor = [UIColor colorWithHexString:@"#fd936f"];
        _kgCircleView.layer.cornerRadius = 6;
        _kgCircleView.clipsToBounds = YES;
    }
    return _kgCircleView;
}

- (UIView *)cdCircleView{
    if (_cdCircleView == nil) {
        _cdCircleView = [[UIView alloc]init];
        _cdCircleView.backgroundColor = [UIColor colorWithHexString:@"#fbce64"];
        _cdCircleView.layer.cornerRadius = 6;
        _cdCircleView.clipsToBounds = YES;
    }
    return _cdCircleView;
}

- (UIView *)zcCircleView{
    if (_zcCircleView == nil) {
        _zcCircleView = [[UIView alloc]init];
        _zcCircleView.backgroundColor = [UIColor colorWithHexString:@"#01c26d"];
        _zcCircleView.layer.cornerRadius = 6;
        _zcCircleView.clipsToBounds = YES;
    }
    return _zcCircleView;
}

- (UILabel *)kgLabel{
    if (_kgLabel == nil) {
        _kgLabel = [[UILabel alloc]init];
        _kgLabel.text = @"旷工";
        _kgLabel.font = [UIFont systemFontOfSize:12];
        _kgLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _kgLabel;
}

- (UILabel *)cdLabel{
    if (_cdLabel == nil) {
        _cdLabel = [[UILabel alloc]init];
        _cdLabel.text = @"迟到、早退";
        _cdLabel.font = [UIFont systemFontOfSize:12];
        _cdLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _cdLabel;
}

- (UILabel *)zcLabel{
    if (_zcLabel == nil) {
        _zcLabel = [[UILabel alloc]init];
        _zcLabel.text = @"正常";
        _zcLabel.font = [UIFont systemFontOfSize:12];
        _zcLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _zcLabel;
}

- (NSMutableArray *)dayPunchListArray{
    if (_dayPunchListArray == nil) {
        _dayPunchListArray = [NSMutableArray array];
    }
    return _dayPunchListArray;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

- (RecordHeadView *)recHeadView{
    if (_recHeadView == nil) {
        _recHeadView = [[RecordHeadView alloc]init];
    }
    return _recHeadView;
}

- (NSMutableDictionary *)punchMonthDict{
    if (_punchMonthDict == nil) {
        _punchMonthDict = [NSMutableDictionary dictionary];
    }
    return _punchMonthDict;
}

- (NSMutableDictionary *)allDayStateDict{
    if (_allDayStateDict == nil) {
        _allDayStateDict = [NSMutableDictionary dictionary];
    }
    return _allDayStateDict;
}

- (NSMutableArray *)absentAndLaterArray{
    if (_absentAndLaterArray == nil) {
        _absentAndLaterArray = [NSMutableArray array];
    }
    return _absentAndLaterArray;
}

- (UIButton *)punchyBtn{
    if (_punchyBtn == nil) {
        _punchyBtn = [[UIButton alloc]init];
        [_punchyBtn setBackgroundImage:[UIImage imageNamed:@"button_clockin"] forState:UIControlStateNormal];
        _punchyBtn.layer.cornerRadius = 47.0;
        [_punchyBtn addTarget:self action:@selector(judgeLocationEnable) forControlEvents:UIControlEventTouchUpInside];
        _punchyBtn.alpha = 0.7f;
    }
    return _punchyBtn;
}

- (UIBarButtonItem *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed)];
    }
    return _leftBtn;
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
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}


@end


