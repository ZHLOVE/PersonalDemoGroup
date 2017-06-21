//
//  SearchResultVC.m
//  WingsBurning
//
//  Created by MBP on 16/9/1.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "SearchResultVC.h"
#import "SKSTableView.h"
#import "CompanyCell.h"
#import "CompnySubCell.h"
#import "AuditingVC.h"
#import "SearchResultVC.h"
#import "MySearchBar.h"
#import "MySearchController.h"

@interface SearchResultVC()<SKSTableViewDelegate>

@property(nonatomic,strong) UIImageView *topNavigation;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) NSMutableArray *companyArray;
@property(nonatomic,strong) SKSTableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *resultArray;

@property(nonatomic,strong) Employers *employers;

@end

@implementation SearchResultVC


- (void)setSearchResultArr:(NSMutableArray *)searchResultArr{
    self.companyArray = [NSMutableArray arrayWithArray:searchResultArr];
    [self.tableView refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)setUpUI{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (void)joinTheCompany:(id)sender{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    UIButton *btn = (UIButton *)sender;
    NSInteger row = btn.tag -1000;
    NSLog(@"加入第%ld个公司",(long)row);
    EmployerM *emp = self.companyArray[row];
    TokensM *tokens = [Verify getTokenFromSanBox];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [Networking chuangJianHeYue:emp.ID token:tokens successBlock:^(ContractM *contract) {
        NSLog(@"申请加入公司成功");
        NSLog(@"%@",contract.employer);
        [ud setObject:contract.ID forKey:@"contractID"];
        [hud hide:YES];
        AuditingVC *au = [[AuditingVC alloc]init];
        au.contract = contract;
        au.employee = self.employee;
        EmployerM *employer = contract.employer;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"joinCompany" object:@[contract,employer]];
        }];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        NSString *str = [NSString stringWithFormat:@"Error%ld,%@",(long)statusCode,errStr];
        [hud setMode:MBProgressHUDModeText];
        [hud setLabelText:str];
        [hud hide:YES afterDelay:2.0];
    }];
}

#pragma mark-懒加载
- (NSMutableArray *)companyArray{
    if (_companyArray == nil) {
        _companyArray = [NSMutableArray array];
    }
    return _companyArray;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"选择公司";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}



- (SKSTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[SKSTableView alloc]initWithFrame:CGRectMake(0, 5*ratio + 64, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.SKSTableViewDelegate = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIImageView *)topNavigation{
    if (_topNavigation == nil) {
        _topNavigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
        [_topNavigation setImage:[UIImage imageNamed:@"top_bg"]];
    }
    return _topNavigation;
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
    NSString *comCellID = [NSString stringWithFormat:@"searchCompCell%ld%ld",(long)indexPath.row,(long)indexPath.section];
    CompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:comCellID];
    if (!cell) {
        cell = [[CompanyCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:comCellID];
        cell.joinComBtn.tag = indexPath.row + 1000;
        [cell.joinComBtn addTarget:self action:@selector(joinTheCompany:) forControlEvents:UIControlEventTouchUpInside];
        EmployerM *employer = self.companyArray[indexPath.row];
        cell.employer = employer;
    }
    EmployerM *employer = self.companyArray[indexPath.row];
    cell.employer = employer;
    return cell;
}

- (UITableViewCell *)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *subCellID = [NSString stringWithFormat:@"searchCompCell%ld%ld",(long)indexPath.row,(long)indexPath.section];
    CompnySubCell *cell = [tableView dequeueReusableCellWithIdentifier:subCellID];
    if (cell == nil) {
        cell = [[CompnySubCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:subCellID];
        EmployerM *employer = self.companyArray[indexPath.row];
        cell.employer = employer;
    }
    EmployerM *employer = self.companyArray[indexPath.row];
    cell.employer = employer;
    return cell;
}



@end

























