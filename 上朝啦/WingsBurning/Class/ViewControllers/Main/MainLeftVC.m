//
//  MainLeftVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "MainLeftVC.h"
#import "MainVC.h"
#import "PerCusCell.h"
#import "PersonalVC.h"
#import "BorrowPunchVC.h"
#import "SettingVC.h"
#import "CompanyListTableView.h"
#import "Record.h"
#import "AuditingVC.h"
#import "BaseNavigationCongroller.h"
#import "WebVC.h"
@interface MainLeftVC ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) EmployeeM *employee;
@property(nonatomic,strong) EmployerM *employer;
@property(nonatomic,strong) ContractM *contract;

@end

static NSArray *iconNameArr;
static NSArray *titleStrArr;
BOOL cellSelectRepeat;

@implementation MainLeftVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        cellSelectRepeat = NO;
        iconNameArr = @[@"自定义单元格",@"sidebar_icon_clockin",@"sidebar_icon_record",@"sidebar_icon_lend",@"img_welfare",@"sidebar_icon_setting"];
        titleStrArr = @[@"自定义单元格",@"打卡",@"打卡记录",@"借他打卡",@"福利",@"设置"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getHeadViewInfo];
    BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
    MainVC *mainVC = navi.viewControllers[0];
    [mainVC getContractInfoWithContract:^(ContractM *contract) {
        self.contract = contract;
        [self.leftTableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)setUpUI{
    [self.view addSubview:self.leftTableView];
}


- (void)setEmployer:(EmployerM *)employer{
    _employer = employer;
}


/**
 *  获取个人信息，包括合约信息
 */
- (void)getHeadViewInfo{
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking huoQuGuYuanXinXi:employee.ID token:tokens successBlock:^(EmployeeM *emp){
        self.employee = emp;
        [Verify saveEmployee:emp];
        [self.leftTableView reloadData];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
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
    Record *recordVC = [[Record alloc]init];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
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
 *  福利
 */
- (void)gotoFuLi{
    WebVC *webVC = [[WebVC alloc]initWithTitleString:@"福利"];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
        [navi pushViewController:webVC animated:NO];
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
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 162 * ratio;
    }else{
        return 46 * ratio;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *PccellID = [NSString stringWithFormat:@"pcCell%lu %lu",(long)indexPath.row,(long)indexPath.section];
        PerCusCell *pcCell = [tableView dequeueReusableCellWithIdentifier:PccellID];
        if (pcCell == nil) {
            pcCell = [[PerCusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PccellID];
        }
        EmployeeM *ee = [Verify getEmployeeFromSandBox];
        pcCell.employee = ee;
        EmployerM *er = [Verify getEmployerFromSH];
        if ([self.contract.state isEqualToString:@"等待合约审核"]) {
            er.name = self.contract.state;
        }
        pcCell.employer = er;
        return pcCell;
    }else{
        NSString *cellID = [NSString stringWithFormat:@"cell%lu %lu",(long)indexPath.row,(long)indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = titleStrArr[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        NSString *str = iconNameArr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:str];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"点了%ld",(long)indexPath.row);

    if (cellSelectRepeat == NO) {
        cellSelectRepeat = YES;
        DLog(@"禁止重复点击");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cellSelectRepeat = NO;
            DLog(@"可以点击");
        });
        if (indexPath.row == 0) {
            [self gotoPersonalInfo];
        }else if (indexPath.row == 5){
            [self goToSetting];
        }else if (indexPath.row == 4){
            [self canPushToViewContorller:indexPath.row];
        }else{
            EmployeeM *employee = [Verify getEmployeeFromSandBox];
            TokensM *tokens = [Verify getTokenFromSanBox];
            [Networking huoQuDQHY:employee.ID token:tokens successBlock:^(ContractM *contract, EmployerM *employer) {
                self.employer = employer;
                [Verify saveEmployerToSH:employer];
                if ([contract.state isEqualToString:@"等待合约审核"]) {
                    [self gotoAuditingVC:contract];
                }else{
                    [self canPushToViewContorller:indexPath.row];
                }
            } failBlock:^(NSString *errStr, NSInteger statusCode) {
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
    }else{
        DLog(@"点不了");
        return;
    }
}


- (void)canPushToViewContorller:(NSInteger)row{
    switch (row) {
        case 1:
            [self gotoMain];
            break;
        case 2:
            [self goToRightSlider];
            break;
        case 3:
            [self goToBorrow];
            break;
        case 4:
            [self gotoFuLi];
            break;
        default:
            break;
    }
}


- (UITableView *)leftTableView{
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth , screenHeight) style:UITableViewStylePlain];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.scrollEnabled = NO;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _leftTableView;
}

@end




