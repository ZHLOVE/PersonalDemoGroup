//
//  BorrowPunchVC.m
//  WingsBurning
//
//  Created by MBP on 16/9/14.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BorrowPunchVC.h"
#import "BorrowTableViewCell.h"
#import "BorrowSearchController.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool

#import "PunchCameraVC.h"

@interface BorrowPunchVC()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating,UISearchBarDelegate>

@property(nonatomic,strong) NSMutableArray *allDataArr;
@property(nonatomic,strong) NSMutableArray *rowArr;
@property(nonatomic,strong) NSMutableArray *sectionArr;
@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) NSArray *resultArray;
@property(nonatomic,copy) NSString *searchText;
@property(nonatomic,strong) PageM *pageM;


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
    [self initSearchController];
}


- (void)viewWillDisappear:(BOOL)animated{
    self.searchController.active = NO;
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
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadContactsList];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreContactsList)];
}

/**
 *  获取雇员列表
 */
- (void)loadContactsList{
    __weak typeof (self) weakSelf = self;
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    TokensM *tokens = [Verify getTokenFromSanBox];
    PageM *tempPage = [[PageM alloc]init];
    tempPage.page = @1;
    tempPage.per_page = @35;
    self.pageM = tempPage;
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
        [weakSelf.tableView.mj_header endRefreshing];
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

    }
    return _tableView;
}


- (NSMutableArray *)sectionArr{
    if (_sectionArr == nil) {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //section
    if (self.searchController.active) {
        return 1;
    }
    return self.rowArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //row
    if (self.searchController.active) {
        return self.resultArray.count;
    }
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
    if (self.searchController.active) {
        return 0;
    }
    return 45.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PunchCameraVC *pCamera = [[PunchCameraVC alloc]init];
    if (self.searchController.active) {
        EmployeeM *employee = self.resultArray[indexPath.row];
        pCamera.naviTitle = [NSString stringWithFormat:@"%@打卡",employee.name];
        pCamera.otherEmployeeID = employee.ID;
        [self.searchController dismissViewControllerAnimated:YES completion:nil];
    }else{
        EmployeeM *employee = self.rowArr[indexPath.section][indexPath.row];
        pCamera.naviTitle = [NSString stringWithFormat:@"%@打卡",employee.name];
        pCamera.otherEmployeeID = employee.ID;
    }
    [self.navigationController pushViewController:pCamera animated:true];
}

#pragma mark - UITableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *comCellID = [NSString stringWithFormat:@"borrowCell%ld%ld",(long)indexPath.row,(long)indexPath.section];
    BorrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:comCellID];
    if (!cell) {
        cell = [[BorrowTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:comCellID];
    }
    if (self.searchController.active) {
        EmployeeM *employee = self.resultArray[indexPath.row];
        cell.employee = employee;
    }else{
        EmployeeM *employee = self.rowArr[indexPath.section][indexPath.row];
        cell.employee = employee;
    }
    return cell;
}


#pragma mark-搜索条
- (void)initSearchController{
    self.searchController = [[BorrowSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,self.searchController.searchBar.frame.origin.y,self.searchController.searchBar.frame.size.width,44);
    self.searchController.searchBar.placeholder = @"搜索姓名";
    /** 将SearchBar背景色移除 */
    for(UIView* view in [[[self.searchController.searchBar subviews]lastObject]subviews] ) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        }
    }
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [self.searchController.searchBar text];
    //过滤搜索文字中的前后空格
    NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *searchStr = [searchString stringByTrimmingCharactersInSet:set];
    self.searchText = searchStr;
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c]%@ ",self.searchText];
    self.resultArray = [self.allDataArr filteredArrayUsingPredicate:namePredicate];
    [self.tableView reloadData];
}

@end
