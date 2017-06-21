//
//  MainLeftVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "MainLeftVC.h"
#import "HeadView.h"
#import "PersonalVC.h"
#import "BorrowPunchVC.h"
#import "SettingVC.h"

#import "Record.h"

#import "BaseNavigationCongroller.h"
@interface MainLeftVC ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UITableView *leftTableView;
@property(nonatomic,strong) EmployeeM *employee;
@property(nonatomic,strong) EmployerM *employer;

@end

static NSArray *iconNameArr;
static NSArray *titleStrArr;

@implementation MainLeftVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        iconNameArr = @[@"sidebar_icon_clockin",@"sidebar_icon_record",@"sidebar_icon_lend",@"sidebar_icon_setting"];
        titleStrArr = @[@"打卡",@"打卡记录",@"借他打卡",@"设置"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTableView];

}

- (void)setUpUI{
    [self.view addSubview:self.leftTableView];
}

- (void)setTableView{
    self.leftTableView.scrollEnabled = NO;
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoPersonalInfo)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    HeadView *headV = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, screenWidth - 100*ratio, 162 * ratio)];
    EmployerM *er = [Verify getEmployerFromSH];
    EmployeeM *ee = [Verify getEmployeeFromSandBox];
    DLog(@"%@",ee.name);
    headV.employer = er;
    self.employer = er;
    headV.employee = ee;
    self.employee = ee;
    self.leftTableView.tableHeaderView = headV;
    [self.leftTableView.tableHeaderView addGestureRecognizer:tapGesture];
}

/**
 *  个人信息
 */
- (void)gotoPersonalInfo{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        PersonalVC *perVC = [[PersonalVC alloc]init];
        perVC.employee = self.employee;
        perVC.employer = self.employer;
        perVC.title = @"个人信息";
        BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
        [navi pushViewController:perVC animated:NO];
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}
/**
 *  打卡
 */
- (void)gotoMain{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {

    }];
}
/**
 *  打卡记录
 */
- (void)goToRightSlider{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        Record *recordVC = [[Record alloc]init];
        BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
        [navi pushViewController:recordVC animated:NO];
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];

}
/**
 *  借他打卡
 */
- (void)goToBorrow{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        BorrowPunchVC *bpVC = [[BorrowPunchVC alloc]init];
        BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
        [navi pushViewController:bpVC animated:NO];
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}
/**
 *  设置
 */
- (void)goToSetting{

    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        SettingVC *setVC = [[SettingVC alloc]init];
        BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
        [navi pushViewController:setVC animated:NO];
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}

#pragma mark-TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cell%lu %lu",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = titleStrArr[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    NSString *str = iconNameArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:str];
    cell.textLabel.font = [UIFont systemFontOfSize:15 * ratio];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self gotoMain];
            break;
        case 1:
            [self goToRightSlider];
            break;
        case 2:
            [self goToBorrow];
            break;
        case 3:
            [self goToSetting];
            break;
        default:
            break;
    }

}



- (UITableView *)leftTableView{
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth , screenHeight) style:UITableViewStylePlain];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _leftTableView;
}

@end




