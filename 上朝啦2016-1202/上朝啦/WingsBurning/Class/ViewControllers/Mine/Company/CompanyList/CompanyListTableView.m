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
#import "MySearchBar.h"
#import "MySearchController.h"

@interface CompanyListTableView ()<SKSTableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

@property(nonatomic,strong) NSMutableArray *companyArray;
@property(nonatomic,strong) SKSTableView *tableView;

@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) NSMutableArray *resultArray;

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



- (SKSTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[SKSTableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.SKSTableViewDelegate = self;
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
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
    [self initSearchController];

}

- (void)tableViewSetMJRefresh{
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadCompanysList];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCompanys)];
}

- (void)loadCompanysList{
    __weak typeof (self) weakSelf = self;
    self.employers = [[Employers alloc]init];
    self.employers.per_page = @(10);
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
        [weakSelf.tableView refreshData];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        NSLog(@"%ld,%@",(long)statusCode,errStr);
    }];
}


- (void)setUpUI{
    self.navigationItem.title = @"选择公司";
    [self.view addSubview:self.tableView];
}

- (void)joinTheCompany:(id)sender{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    UIButton *btn = (UIButton *)sender;
    NSInteger row = btn.tag -1000;
    NSLog(@"加入第%ld个公司",(long)row);
    EmployerM *emp = self.companyArray[row];
    TokensM *tokens = [Verify getTokenFromSanBox];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [Networking chuangJianHeYue:emp.ID token:tokens successBlock:^(ContractM *contract) {
        NSLog(@"申请加入公司成功");
        [ud setObject:contract.ID forKey:@"contractID"];
        [hud hide:YES];
        AuditingVC *au = [[AuditingVC alloc]init];
        au.contract = contract;
        au.employee = self.employee;
        if (self.firstRegister) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            UINavigationController *naviAu = [[UINavigationController alloc]initWithRootViewController:au];
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.2];
            [animation setType:kCATransitionReveal];
            [animation setSubtype:kCATransitionFromRight];
            [[[[UIApplication sharedApplication]keyWindow]layer]addAnimation:animation forKey:nil];
            [weakSelf presentViewController:naviAu animated:NO completion:nil];
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        NSString *str = [NSString stringWithFormat:@"Error%ld,%@",(long)statusCode,errStr];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:str];
        [hud hide:YES afterDelay:2.0];
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

#pragma mark-搜索条
- (void)initSearchController{

    SearchResultVC *resultTVC = [SearchResultVC alloc];
    self.searchController = [[MySearchController alloc] initWithSearchResultsController:resultTVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,self.searchController.searchBar.frame.origin.y,self.searchController.searchBar.frame.size.width,44);
    self.searchController.searchBar.placeholder = @"搜索公司";
    /** 将SearchBar背景色移除 */
    for(UIView* view in [[[self.searchController.searchBar subviews]lastObject]subviews] ) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        }
    }
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - UISearchResultsUpdating
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    __weak typeof (self) weakSelf = self;

    if (self.searchText.length > 0) {
        TokensM *tokens = [Verify getTokenFromSanBox];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.searchController.view animated:YES];
        hud.labelText = @"努力搜索中";
        hud.dimBackground = NO;
        Employers *emp = [[Employers alloc]init];
        emp.per_page = @(10);
        emp.name = self.searchText;
        [Networking huoQuGSLB:emp token:tokens successBlock:^(NSArray *arr) {
            [weakSelf.tableView.mj_header endRefreshing];
            [self.resultArray removeAllObjects];
            self.resultArray = [NSMutableArray arrayWithArray:arr];
            SearchResultVC *searchResult = (SearchResultVC *)self.searchController.searchResultsController;
            searchResult.searchResultArr = self.resultArray;
            [hud hide:YES];
        } failBlock:^(NSString *errStr, NSInteger statusCode) {
            [hud setMode:MBProgressHUDModeText];
            [hud setCenter:self.view.center];
            NSString *str = [NSString stringWithFormat:@"网络错误%ld",(long)statusCode];
            [hud setLabelText:str];
            [hud hide:YES afterDelay:2.0];
        }];
    }
}




- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //过滤搜索文字中的前后空格
    NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *searchStr = [searchText stringByTrimmingCharactersInSet:set];
    self.searchText = searchStr;
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    [self.navigationController pushViewController:searchController animated:YES];
}



@end
