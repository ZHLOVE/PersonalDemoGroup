//
//  CompanyListTableView.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CompanyListTableView.h"
#import "SKSTableView.h"
#import "CompanyCell.h"
#import "CompnySubCell.h"
#import "AuditingVC.h"
#import "SearchResultVC.h"
#import "CreateCompanyVC.h"


@interface CompanyListTableView ()<SKSTableViewDelegate>

@property(nonatomic,strong) NSMutableArray *companyArray;
@property(nonatomic,strong) SKSTableView *tableView;

@property(nonatomic,strong) UIView *searchView;
@property(nonatomic,strong) UIButton *searchBtn;
@property(nonatomic,strong) UILabel *searchLabel;
@property(nonatomic,strong) UIButton *createComBtn;
@property(nonatomic,strong) UIBarButtonItem *leftBtn;


@property(nonatomic,strong) Employers *employers;
@property(nonatomic,copy) NSString *searchText;
@end

@implementation CompanyListTableView

- (NSMutableArray *)companyArray{
    if (_companyArray == nil) {
        _companyArray = [NSMutableArray array];
    }
    return _companyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self tableViewSetMJRefresh];
    [self xw_addNotificationForName:@"joinCompany" block:^(NSNotification *notification) {
        //直接传object对象过来的话，contract中的employer对象为nil，所以才通过数组的方式传object过来
        NSArray *arr = notification.object;
        AuditingVC *au = [[AuditingVC alloc]init];
        ContractM *contract = [[ContractM alloc]init];
        contract = arr[0];
        contract.employer = arr[1];
        au.contract = contract;
        au.employee = self.employee;
        [self.navigationController pushViewController:au animated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadCompanysList];
}

- (void)backBtnPressed{
    if (self.firstRegister) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableViewSetMJRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCompanysList)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCompanys)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新中..." forState:MJRefreshStatePulling];
    [footer setTitle:@" " forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
}

- (void)gotoSearchResultVC{
    SearchResultVC *resultVC = [[SearchResultVC alloc]init];
    resultVC.firstRegister = self.firstRegister;
    [self.navigationController pushViewController:resultVC animated:NO];
}

- (void)gotoCreateCompany{
    CreateCompanyVC *createCom = [[CreateCompanyVC alloc]init];
    [self.navigationController pushViewController:createCom animated:YES];
}

- (void)loadCompanysList{
    [self.tableView.mj_footer resetNoMoreData];
    __weak typeof (self) weakSelf = self;
    self.employers = [[Employers alloc]init];
    self.employers.per_page = @(35);
    self.employers.name = @"";
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking huoQuGSLB:self.employers token:tokens successBlock:^(NSArray *arr) {
        [weakSelf.tableView.mj_header endRefreshing];
        self.companyArray = [arr mutableCopy];
        [weakSelf.tableView refreshData];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"%ld,%@",(long)statusCode,errStr);
    }];
}

- (void)loadMoreCompanys{
    __weak typeof (self) weakSelf = self;
    NSInteger p = [self.employers.page intValue];
    p = p + 1;
    self.employers.page = @(p);
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking huoQuGSLB:self.employers token:tokens successBlock:^(NSArray *arr) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [self.companyArray addObjectsFromArray:arr];
        if (arr.count < [self.employers.per_page intValue]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView refreshData];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        DLog(@"%ld,%@",(long)statusCode,errStr);
    }];
}


- (void)setUpUI{
    self.navigationItem.title = @"选择公司";
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchView];
    [self.createComBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.searchView.mas_right).offset(-18 * ratio);
        make.centerY.mas_equalTo(self.searchLabel.mas_centerY);
        make.height.mas_equalTo(45 * ratio);
    }];
}

- (void)joinTheCompany:(id)sender{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    UIButton *btn = (UIButton *)sender;
    NSInteger row = btn.tag -1000;
    DLog(@"加入第%ld个公司",(long)row);
    EmployerM *emp = self.companyArray[row];
    TokensM *tokens = [Verify getTokenFromSanBox];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [Networking chuangJianHeYue:emp.ID token:tokens successBlock:^(ContractM *contract) {
        DLog(@"申请加入公司成功");
        [ud setObject:contract.ID forKey:@"contractID"];
        [hud hideAnimated:YES];
        AuditingVC *au = [[AuditingVC alloc]init];
        au.contract = contract;
        au.employee = self.employee;
        if (self.firstRegister) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController pushViewController:au animated:YES];
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        NSString *str = [NSString stringWithFormat:@"网络错误"];
        if (statusCode == 422) {
            str = @"您已存在合约";
        }
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = str;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
}

#pragma mark-TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.companyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89 * ratio;
}


- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94 * ratio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *comCellID = [NSString stringWithFormat:@"compCell%ld%ld",(long)indexPath.row,(long)indexPath.section];
    CompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:comCellID];
    if (!cell) {
        cell = [[CompanyCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:comCellID];
        cell.joinComBtn.tag = indexPath.row + 1000;
        [cell.joinComBtn addTarget:self action:@selector(joinTheCompany:) forControlEvents:UIControlEventTouchUpInside];
        EmployerM *employer = self.companyArray[indexPath.row];
        cell.employer = employer;
    }
    return cell;
}

- (UITableViewCell *)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *subCellID = [NSString stringWithFormat:@"compSubCell%ld%ld",(long)indexPath.row,(long)indexPath.section];
    CompnySubCell *cell = [tableView dequeueReusableCellWithIdentifier:subCellID];
    if (cell == nil) {
        cell = [[CompnySubCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:subCellID];
        EmployerM *employer = self.companyArray[indexPath.row];
        cell.employer = employer;
    }
    return cell;
}

- (SKSTableView *)tableView{
    if (_tableView == nil) {
        CGRect tableFrame = CGRectMake(0, self.searchView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchView.frame.size.height);
        _tableView = [[SKSTableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
        _tableView.SKSTableViewDelegate = self;
        _tableView.scrollEnabled = YES;
        UIView *hv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 0.01)];
        _tableView.tableHeaderView = hv;
    }
    return _tableView;
}

- (UIView *)searchView{
    if (_searchView == nil) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 99)];
        _searchView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];
        [_searchView addSubview:self.searchBtn];
        [_searchView addSubview:self.searchLabel];
        [_searchView addSubview:self.createComBtn];
    }
    return _searchView;
}
- (UIButton *)searchBtn{
    if (_searchBtn == nil) {
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(18, 10, screenWidth-36, 44)];
        _searchBtn.backgroundColor = [UIColor whiteColor];
        [_searchBtn setTitle:@"  搜索公司" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _searchBtn.layer.cornerRadius = 4;
        _searchBtn.layer.borderWidth = 0;
        [_searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(gotoSearchResultVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UILabel *)searchLabel{
    if (_searchLabel == nil) {
        _searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 55, screenWidth-200, 45)];
        _searchLabel.backgroundColor = [UIColor clearColor];
        _searchLabel.text = @"选择公司加入";
        _searchLabel.font = [UIFont systemFontOfSize:13];
        _searchLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _searchLabel;
}

- (UIButton *)createComBtn{
    if (_createComBtn == nil) {
        _createComBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-96, 55, 78, 45)];
        [_createComBtn setImage:[UIImage imageNamed:@"img_plus"] forState:UIControlStateNormal];
        _createComBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_createComBtn setTitleColor:[UIColor colorWithHexString:@"#01c872"] forState:UIControlStateNormal];
        [_createComBtn setTitle:@" 创建公司" forState:UIControlStateNormal];
        [_createComBtn addTarget:self action:@selector(gotoCreateCompany) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createComBtn;
}

- (UIBarButtonItem *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed)];
    }
    return _leftBtn;
}

@end
















