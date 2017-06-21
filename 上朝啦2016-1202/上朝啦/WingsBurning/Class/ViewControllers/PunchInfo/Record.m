//
//  Record.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Record.h"
#import "FSCalendar.h"
#import "DayCell.h"
#import "FSCalendarExtensions.h"
#import "UIViewController+MMDrawerController.h"
#import "NormalHeadView.h"
#import "RecordHeadView.h"
#import "NormalTableViewCell.h"
#import "RecordTableViewCell.h"
#import "PunchCameraVC.h"
#import "MJExtension.h"

@interface Record ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource, FSCalendarDelegateAppearance>

@property(nonatomic,strong) FSCalendar *calender;
@property(nonatomic,strong) NSCalendar *gregorian;
@property(nonatomic,strong) NSDateFormatter *formatter;
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
@property(nonatomic,strong) NormalHeadView *norHeadView;
@property(nonatomic,strong) UIButton *punchyBtn;
@property(nonatomic,strong) PageM *page;
@property(nonatomic,strong) PunchesGather *punchGather;

/**
 *  默认时要填充色的数组（迟到与早退需要填充色）
 */
@property(nonatomic,strong) NSMutableDictionary *fillDaysColors;
/**
 *  选中时要填充色的数组（迟到与早退需要填充色）
 */
@property(nonatomic,strong) NSMutableDictionary *fillDaysSelectColors;
/**
 *  选中的边框
 */
@property(nonatomic,strong) NSMutableDictionary *borderDaysColors;
/**
 *  未选中的边框
 */
@property(nonatomic,strong) NSMutableDictionary *borderDaysDefaultColors;
/**
 *  选中的文字
 */
@property(nonatomic,strong) NSMutableDictionary *titleDaysColors;
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

static BOOL showDetailList;
//旷工的颜色
static UIColor *absentFillColor;
static UIColor *absentBordColor;
//迟到的颜色
static UIColor *laterFillColor;
static UIColor *laterBordColor;
//正常的颜色
static UIColor *normalFillSelectColor;
static UIColor *normalFillDefulColor;
static UIColor *normalBordColor;
//文字的颜色
static UIColor *normalTitleColor;
static UIColor *unNormalTitleColor;

@implementation Record

- (instancetype)init
{
    self = [super init];
    if (self) {
        showDetailList = NO;
        absentFillColor = [UIColor colorWithHexString:@"#FD936F"];
        absentBordColor = [UIColor colorWithHexString:@"#f55723"];

        laterFillColor = [UIColor colorWithHexString:@"#FBCE64"];
        laterBordColor = [UIColor colorWithHexString:@"#e59d03"];

        normalFillSelectColor = [UIColor colorWithHexString:@"#01c26d"];
        normalFillDefulColor = [UIColor colorWithHexString:@"#FFFFFF"];
        normalBordColor = [UIColor colorWithHexString:@"#04cf71"];

        normalTitleColor = [UIColor colorWithHexString:@"#666666"];
        unNormalTitleColor = [UIColor colorWithHexString:@"#FFFFFF"];
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
    [self loadPunchGatherWithBeginDay:beginDay andEndDay:endDay];
    [self.tableView reloadData];
}

- (void)loadTestData{
    [self.fillDaysColors setObject:absentFillColor forKey:@"2016-09-02"];
    [self.borderDaysColors setObject:absentBordColor forKey:@"2016-09-02"];
    [self.titleDaysColors setObject:unNormalTitleColor forKey:@"2016-09-02"];
    [self.fillDaysColors setObject:laterFillColor forKey:@"2016-09-12"];
    [self.borderDaysColors setObject:laterBordColor forKey:@"2016-09-12"];
    [self.titleDaysColors setObject:unNormalTitleColor forKey:@"2016-09-12"];
    [self.fillDaysColors setObject:laterFillColor forKey:@"2016-09-13"];
    [self.borderDaysColors setObject:laterBordColor forKey:@"2016-09-13"];
    [self.titleDaysColors setObject:unNormalTitleColor forKey:@"2016-09-13"];
}



/**
 *  获取当前月份打卡记录
 */
- (void)loadLastDataWithBeginDay:(NSString *)begin andEndDay:(NSString *)end{
    __weak typeof(self) weakSelf = self;
    TokensM *tokens = [Verify getTokenFromSanBox];
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    DLog(@"begin:%@,end:%@",begin,end);
    if (tokens.access_token) {
        [Networking daKaJiLu:employee.ID token:tokens beginDay:begin endDay:end successBlock:^(NSDictionary *punchDict) {
            weakSelf.punchMonthDict = [punchDict mutableCopy];
            for (NSString *key in punchDict.allKeys) {
                NSMutableArray *array = [[punchDict objectForKey:key] mutableCopy];
                NSString *today = [weakSelf.formatter stringFromDate:weakSelf.calender.today];
                switch (array.count) {
                    case 0:break;
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
        } failBlock:^(NSString *errStr, NSInteger statusCode) {
            DLog(@"%ld%@",(long)statusCode,errStr);
        }];
    }
}

/**
 *  获取工作时间
 */
- (void)getWorkTime{
    __weak typeof(self) weakSelf = self;
    TokensM *tokens = [Verify getTokenFromSanBox];
    EmployerM *employer = [Verify getEmployerFromSH];
    [Networking huoQuGZSJ:employer.ID token:tokens successBlock:^(NSArray *array) {
        PeriodM *p = array[0];
        weakSelf.recHeadView.period = p;
        [weakSelf.tableView reloadData];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        DLog(@"%ld,%@",(long)statusCode,errStr);
    }];


}

/**
 *  获取每月汇总
 */
- (void)loadPunchGatherWithBeginDay:(NSString *)begin andEndDay:(NSString *)end{
    showDetailList = NO;
    __weak typeof(self) weakSelf = self;
    TokensM *tokens = [Verify getTokenFromSanBox];
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    DLog(@"begin:%@,end:%@",begin,end);
    if (tokens.access_token) {
        [Networking huoQuDaKaHuiZong:employee.ID token:tokens beginDay:begin endDay:end successBlock:^(PunchesGather *punchGather) {
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
 */
- (void)fillDaySetFromDayAttenceState{
    for (NSString *key in self.allDayStateDict.allKeys) {
        NSArray *statesArray = @[@"normal_accepted", @"late_accepted", @"early_accepted",@"absent_accepted",@"absent_later"];
        NSUInteger index = [statesArray indexOfObject:self.allDayStateDict[key]];
        switch (index) {
            case 0:
                [self.borderDaysDefaultColors setObject:normalBordColor forKey:key];
                [self.fillDaysColors setObject:normalFillDefulColor forKey:key];
                [self.fillDaysSelectColors setObject:normalFillSelectColor forKey:key];
                [self.titleDaysColors setObject:normalTitleColor forKey:key];
                break;
            case 1:
                [self.borderDaysColors setObject:laterBordColor forKey:key];
                [self.fillDaysColors setObject:laterFillColor forKey:key];
                [self.fillDaysSelectColors setObject:laterFillColor forKey:key];
                [self.titleDaysColors setObject:unNormalTitleColor forKey:key];
                break;
            case 2:
                [self.borderDaysColors setObject:laterBordColor forKey:key];
                [self.fillDaysColors setObject:laterFillColor forKey:key];
                [self.fillDaysSelectColors setObject:laterFillColor forKey:key];
                [self.titleDaysColors setObject:unNormalTitleColor forKey:key];
                break;
            case 3:
                [self.borderDaysColors setObject:absentBordColor forKey:key];
                [self.fillDaysColors setObject:absentFillColor forKey:key];
                [self.fillDaysSelectColors setObject:absentFillColor forKey:key];
                [self.titleDaysColors setObject:unNormalTitleColor forKey:key];
            case 4:
                [self.fillDaysColors setObject:absentFillColor forKey:key];
                [self.fillDaysSelectColors setObject:absentFillColor forKey:key];
                [self.titleDaysColors setObject:unNormalTitleColor forKey:key];
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


- (void)goToPunch{
    if ([Verify getPunchEnable]) {
        EmployeeM *employee = [Verify getEmployeeFromSandBox];
        PunchCameraVC *cam = [[PunchCameraVC alloc]init];
        cam.naviTitle = [NSString stringWithFormat:@"%@打卡",employee.name];
        cam.otherEmployeeID = nil;
        [self.navigationController pushViewController:cam animated:true];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setCenter:self.view.center];
        NSString *str = [NSString stringWithFormat:@"请检查合约"];
        [hud setLabelText:str];
        [hud hide:YES afterDelay:2.0];
    }
}

#pragma mark-自定义Cell
//delegate
- (__kindof FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position{
    DayCell *cell = [calendar dequeueReusableCellWithIdentifier:@"dayCell" forDate:date atMonthPosition:position];
    return cell;
}

#pragma mark-FSCalendar Delegate
- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    DayCell *diyCell = (DayCell *)cell;
    NSString *key = [self.formatter stringFromDate:date];
    diyCell.circleImageView.hidden = ![self.absentAndLaterArray containsObject:key];
}

#pragma mark-FSCalendarDelegateAppearance
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
    NSArray *allKeys = self.titleDaysColors.allKeys;
    if ([allKeys containsObject:key]) {
        UIColor *color = self.titleDaysColors[key];
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
    showDetailList = YES;
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
    self.recHeadView.titleLabel.text = str;
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
    [self loadPunchGatherWithBeginDay:monBeginDay andEndDay:monEndDay];
}





#pragma mark-TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (showDetailList) {
        return self.dayPunchListArray.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (showDetailList) {
        return 89 * ratio;
    }else{
        return 80 * ratio;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46 * ratio;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (showDetailList) {
        return self.recHeadView;
    }else{
        return self.norHeadView;
    }
}

#pragma mark-TableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (showDetailList) {
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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    __weak typeof (self) weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    [self.view addSubview:self.calender];
    [self.calender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(300 * ratio);
    }];
    [self.view addSubview:self.previousButton];
    [self.previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(103 * ratio);
        make.top.mas_equalTo(weakSelf.view).offset(11 * ratio);
        make.width.mas_equalTo(30);
    }];
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view).offset(-103 * ratio);
        make.centerY.mas_equalTo(weakSelf.previousButton.mas_centerY);
        make.width.mas_equalTo(30);
    }];
    [self.view addSubview:self.kgCircleView];
    [self.kgCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(12);
        make.centerY.mas_equalTo(weakSelf.calender.mas_bottom).offset(22 * ratio);
        make.left.mas_equalTo(weakSelf.view).offset(18 *ratio);
    }];
    [self.view addSubview:self.kgLabel];
    [self.kgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.mas_equalTo(12 * ratio);
        make.left.mas_equalTo(weakSelf.kgCircleView.mas_right).offset(10 * ratio);
    }];
    [self.view addSubview:self.cdCircleView];
    [self.cdCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.width.mas_equalTo(weakSelf.kgCircleView);
        make.left.mas_equalTo(weakSelf.kgLabel.mas_right).offset(28 * ratio);
    }];
    [self.view addSubview:self.cdLabel];
    [self.cdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.mas_equalTo(12 * ratio);
        make.left.mas_equalTo(weakSelf.cdCircleView.mas_right).offset(10 * ratio);
    }];
    [self.view addSubview:self.zcCircleView];
    [self.zcCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.width.mas_equalTo(weakSelf.kgCircleView);
        make.left.mas_equalTo(weakSelf.cdLabel.mas_right).offset(28 * ratio);
    }];
    [self.view addSubview:self.zcLabel];
    [self.zcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.kgCircleView.mas_centerY);
        make.height.mas_equalTo(12 * ratio);
        make.left.mas_equalTo(weakSelf.zcCircleView.mas_right).offset(10 * ratio);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(226 * ratio);
        make.top.mas_equalTo(weakSelf.calender.mas_bottom).offset(44 * ratio);
    }];
    [self.view addSubview:self.punchyBtn];
    [self.punchyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(80 * ratio);
        make.right.mas_equalTo(weakSelf.view).offset(-28 * ratio);
        make.bottom.mas_equalTo(weakSelf.view).offset(-20 * ratio);
    }];
}


#pragma mark-控件设置
- (FSCalendar *)calender{
    if (_calender == nil) {
        _calender = [[FSCalendar alloc]init];
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
        [_calender setAllowsSelection:YES];
        [_calender  setAllowsMultipleSelection:NO];
        [_calender.appearance setTitleDefaultColor:[UIColor colorWithHexString:@"#666666"]];
        [_calender registerClass:[DayCell class] forCellReuseIdentifier:@"dayCell"];
        _calender.dataSource = self;
        _calender.delegate = self;
    }
    return _calender;
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
//默认的文字
- (NSMutableDictionary *)titleDaysColors{
    if (_titleDaysColors == nil) {
        _titleDaysColors = [NSMutableDictionary dictionary];
    }
    return _titleDaysColors;
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

- (NormalHeadView *)norHeadView{
    if (_norHeadView == nil) {
        _norHeadView = [[NormalHeadView alloc]init];
    }
    return _norHeadView;
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
    }
    return _punchyBtn;
}


-(void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}


@end


