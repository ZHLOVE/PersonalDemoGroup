//
//  BorrowPunchVC.m
//  WingsBurning
//
//  Created by MBP on 16/9/14.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BorrowPunchVC.h"
#import "BorrowSearchResultVC.h"
#import "BorrowTableViewCell.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
#import "PunchCameraVC.h"
#import "CustomPopView.h"

@interface BorrowPunchVC()<UITableViewDataSource, UITableViewDelegate>


@property(nonatomic,strong) UIView *searchView;
@property(nonatomic,strong) UIButton *searchBtn;
@property(nonatomic,strong) NSMutableArray *allDataArr;
@property(nonatomic,strong) NSMutableArray *rowArr;
@property(nonatomic,strong) NSMutableArray *sectionArr;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *resultArray;
@property(nonatomic,copy) NSString *searchText;
@property(nonatomic,strong) PageM *pageM;
@property(nonatomic,strong) CustomPopView *popView;
@property(nonatomic,strong) UIButton *popViewCloseBtn;
@property(nonatomic,strong) UIView *blackView;
@property(nonatomic,strong) EmployerM *employer;
@property(nonatomic,strong) TokensM *tokens;
@end

@implementation BorrowPunchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self tableViewSetMJRefresh];
    [self loadContactsList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)setUpUI{
    self.navigationItem.title = @"借他打卡";
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(weakSelf.view);
    }];
}

- (void)tableViewSetMJRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadContactsList)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreContactsList)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新中..." forState:MJRefreshStatePulling];
    [footer setTitle:@" " forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
}

/**
 *  获取雇员列表
 */
- (void)loadContactsList{
    [self.tableView.mj_footer resetNoMoreData];
    __weak typeof (self) weakSelf = self;
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    TokensM *tokens = [Verify getTokenFromSanBox];
    PageM *tempPage = [[PageM alloc]init];
    tempPage.page = @1;
    tempPage.per_page = @20;
    self.pageM = tempPage;
    NSLog(@"%@",self.pageM.page);
    [Networking huoQuGYLB:employee.ID token:tokens page:tempPage successBlock:^(NSArray *colleagues, PageM *page) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSMutableArray *mArr = [NSMutableArray array];
        for (ColleaguesContractM *coll in colleagues) {
            if (coll != nil) {
                EmployeeM *ee = coll.employee;
                [mArr addObject:ee];
            }
        }
        weakSelf.allDataArr = [mArr mutableCopy];
        weakSelf.rowArr = [ContactDataHelper getFriendListDataBy:mArr];
        weakSelf.sectionArr = [ContactDataHelper getFriendListSectionBy:weakSelf.rowArr];
        [weakSelf.tableView reloadData];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        DLog(@"%ld,%@",(long)statusCode,errStr);
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
/**
 *  加载更多雇员列表
 */
- (void)loadMoreContactsList{
    int p = [self.pageM.page intValue];
    p += 1;
    self.pageM.page = @(p);
    NSLog(@"%@",self.pageM.page);
    __weak typeof (self) weakSelf = self;
    PageM *tempPage = self.pageM;
    TokensM *tokens = [Verify getTokenFromSanBox];
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    [Networking huoQuGYLB:employee.ID token:tokens page:tempPage successBlock:^(NSArray *colleagues, PageM *page) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (ColleaguesContractM *coll in colleagues) {
            if (coll != nil) {
                EmployeeM *ee = coll.employee;
                [mArr addObject:ee];
            }
        }
        if (colleagues.count < [weakSelf.pageM.per_page intValue]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.allDataArr addObjectsFromArray:mArr];
        weakSelf.rowArr = [ContactDataHelper getFriendListDataBy:weakSelf.allDataArr];
        weakSelf.sectionArr = [ContactDataHelper getFriendListSectionBy:weakSelf.rowArr];
        [weakSelf.tableView reloadData];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        DLog(@"%ld,%@",(long)statusCode,errStr);
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)gotoBorrowSearchResultVC{
    BorrowSearchResultVC *result = [[BorrowSearchResultVC alloc]init];
    result.rowArr = self.rowArr;
    result.allDataArr = self.allDataArr;
    result.sectionArr = self.sectionArr;
    [self.navigationController pushViewController:result animated:NO];
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
    [window addSubview:self.blackView];
    NSString *changeTime = [NSString stringWithFormat:@"%@-%@",[change.begin_at substringWithRange:NSMakeRange(0, 5)],[change.end_at substringWithRange:NSMakeRange(0, 5)]];
    self.popView.changeTime = changeTime;
    [window addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(315 * ratio);
        make.height.mas_equalTo(280 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY);
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
 * 判断定位开启
 */
- (void)judgeLocationEnable{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        DLog(@"定位服务未开启");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = @"请开启定位服务";
        [hud hideAnimated:YES afterDelay:1.5];
    }else{
        DLog(@"定位服务已开启");
        [self checkWorkTimeChange];
    }
}

/**
 * 进入相机
 */
- (void)pushTheCamera{
    [self removeTheTipView];
    PunchCameraVC *cam = [[PunchCameraVC alloc]init];;
    cam.naviTitle = [NSString stringWithFormat:@"%@打卡",self.employee.name];
    cam.otherEmployeeID = self.employee.ID;
    [self.navigationController pushViewController:cam animated:YES];
}



#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.rowArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.rowArr[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 45)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHexString:@"#444444"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    style.firstLineHeadIndent = 12.0f;
    label.attributedText = [[NSAttributedString alloc]initWithString:self.sectionArr[section] attributes:@{NSParagraphStyleAttributeName : style}];
    return label;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionArr;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.employee = self.rowArr[indexPath.section][indexPath.row];
    [self judgeLocationEnable];
}

#pragma mark - UITableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *comCellID = [NSString stringWithFormat:@"borrowCell%ld%ld",(long)indexPath.row,(long)indexPath.section];
    BorrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:comCellID];
    if (!cell) {
        cell = [[BorrowTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:comCellID];
    }

    EmployeeM *employee = self.rowArr[indexPath.section][indexPath.row];
    cell.employee = employee;
    return cell;
}

#pragma mark-懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSectionIndexColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.48 alpha:1.00]];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        _tableView.backgroundView = [UIView new];
        _tableView.tableHeaderView = self.searchView;
    }
    return _tableView;
}

- (UIView *)searchView{
    if (_searchView == nil) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 54)];
        _searchView.backgroundColor = [UIColor clearColor];
        [_searchView addSubview:self.searchBtn];
    }
    return _searchView;
}
- (UIButton *)searchBtn{
    if (_searchBtn == nil) {
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(18, 15, screenWidth-36, 44)];
        _searchBtn.backgroundColor = [UIColor whiteColor];
        [_searchBtn setTitle:@"  搜索姓名" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _searchBtn.layer.cornerRadius = 4;
        _searchBtn.layer.borderWidth = 1;
        _searchBtn.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
        [_searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(gotoBorrowSearchResultVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (NSMutableArray *)sectionArr{
    if (_sectionArr == nil) {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
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


@end
