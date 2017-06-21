//
//  Record.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Record.h"
#import "FSCalendar.h"
@interface Record ()<UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate,FSCalendarDataSource, FSCalendarDelegateAppearance>

@property(nonatomic,strong) UIBarButtonItem *leftBtn;
@property(nonatomic,strong) FSCalendar *calender;
@property(nonatomic,strong) UIButton *previousButton;
@property(nonatomic,strong) UIButton *nextButton;
@property(nonatomic,strong) UIView *kgCircleView;
@property(nonatomic,strong) UIView *cdCircleView;
@property(nonatomic,strong) UILabel *kgLabel;
@property(nonatomic,strong) UILabel *cdLabel;
@property(nonatomic,strong) UITableView *tableView;

/**
 *  选中的日期
 */
@property(nonatomic,strong) NSMutableDictionary *fillSelectionColors;
/**
 *  选中的边框
 */
@property(nonatomic,strong) NSMutableDictionary *borderSelectionColors;
/**
 *  每日打卡数据
 */
@property(nonatomic,strong) NSMutableArray *dayPunchListArray;




@end

@implementation Record

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)previousClicked{

}

- (void)nextClicked{

}


#pragma mark-布局设置
- (void)setUpUI{
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
}















//self.view.addSubview(cdCircleView)
//cdCircleView.snp_makeConstraints { (make) in
//    make.centerY.equalTo(kgCircleView.snp_centerY)
//    make.height.width.equalTo(kgCircleView)
//    make.left.equalTo(kgLabel.snp_right).offset(28 * ratio)
//}
//self.view.addSubview(cdLabel)
//cdLabel.snp_makeConstraints { (make) in
//    make.centerY.equalTo(kgCircleView.snp_centerY)
//    make.height.equalTo(12 * ratio)
//    make.left.equalTo(cdCircleView.snp_right).offset(10 * ratio)
//}

#pragma mark-控件设置
- (FSCalendar *)calender{
    if (_calender == nil) {
        _calender = [[FSCalendar alloc]init];
        _calender.backgroundColor = [UIColor whiteColor];
        _calender.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
        _calender.appearance.headerMinimumDissolvedAlpha = 0;
        [_calender.appearance setCaseOptions:FSCalendarCaseOptionsHeaderUsesUpperCase];
        _calender.appearance.headerDateFormat = @"yyyy年MM月";
        [_calender.appearance setHeaderTitleColor:[UIColor colorWithHexString:@"#444444"]];
        [_calender.appearance setWeekdayTextColor:[UIColor colorWithHexString:@"#999999"]];
        [_calender.appearance setWeekdayFont:[UIFont systemFontOfSize:14]];
        //今日颜色
        [_calender.appearance setTodayColor:[UIColor colorWithHexString:@"#123456"]];
        [_calender.appearance setTitlePlaceholderColor:[UIColor colorWithHexString:@"#d5d5d5"]];
        [_calender setAllowsSelection:YES];
        [_calender  setAllowsMultipleSelection:NO];
        [_calender.appearance setTitleDefaultColor:[UIColor colorWithHexString:@"#666666"]];
    }
    return _calender;
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

////选中的日期
- (NSMutableDictionary *)fillSelectionColors{
    if (_fillSelectionColors == nil) {
        _fillSelectionColors = [NSMutableDictionary dictionary];
    }
    return _fillSelectionColors;
}

////选中的边框
- (NSMutableDictionary *)borderSelectionColors{
    if (_borderSelectionColors == nil) {
        _borderSelectionColors = [NSMutableDictionary dictionary];
    }
    return _borderSelectionColors;
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

- (NSMutableArray *)dayPunchListArray{
    if (_dayPunchListArray == nil) {
        _dayPunchListArray = [NSMutableArray array];
    }
    return _dayPunchListArray;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
    }
    return _tableView;
}
@end



































