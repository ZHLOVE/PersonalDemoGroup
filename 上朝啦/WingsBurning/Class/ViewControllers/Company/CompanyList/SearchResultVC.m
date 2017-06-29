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
#import "NoneCompanyView.h"
#import "CreateCompanyVC.h"
@interface SearchResultVC()<SKSTableViewDelegate,UITextFieldDelegate>


@property(nonatomic,strong) UIView *searchView;
@property(nonatomic,strong) UITextField *searchTF;
@property(nonatomic,strong) UIButton *searchCancelBtn;
@property(nonatomic,strong) NoneCompanyView *noneView;
@property(nonatomic,strong) NSMutableArray *companyArray;
@property(nonatomic,strong) SKSTableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;


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
    [self.navigationController.navigationBar addSubview:self.searchView];
    [self.searchTF becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchView removeFromSuperview];
}

- (void)popToLastNavi{
    NSArray *array =  self.navigationController.viewControllers;
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: (array.count - 2)] animated:NO];
}

- (void)gotoCreateCompany{
    [self.searchTF resignFirstResponder];
    CreateCompanyVC *ccvc = [[CreateCompanyVC alloc]init];
    [self.navigationController pushViewController:ccvc animated:YES];
}

- (void)setUpUI{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self.navigationController.navigationBar addSubview:self.searchView];
}

- (void)loadCompanysList{
    __weak typeof (self) weakSelf = self;
    self.employers = [[Employers alloc]init];
    self.employers.per_page = @(35);
    self.employers.name = self.searchTF.text;
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking huoQuGSLB:self.employers token:tokens successBlock:^(NSArray *arr) {
        self.companyArray = [arr mutableCopy];
        if (self.companyArray.count == 0) {
            [self.view addSubview:self.noneView];
            [weakSelf.tableView refreshData];
        }else{
            [self.noneView removeFromSuperview];
            [self.searchTF resignFirstResponder];
            [weakSelf.tableView refreshData];
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        DLog(@"%ld,%@",(long)statusCode,errStr);
    }];
}

- (void)joinTheCompany:(id)sender{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
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
        [hud hideAnimated:YES];
        AuditingVC *au = [[AuditingVC alloc]init];
        au.contract = contract;
        au.employee = self.employee;
        EmployerM *employer = contract.employer;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"joinCompany" object:@[contract,employer]];
        }];
        if (self.firstRegister) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else{
            [self.navigationController pushViewController:au animated:YES];
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        NSString *str = [NSString stringWithFormat:@"Error%ld,%@",(long)statusCode,errStr];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = str;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
}

#pragma mark-懒加载
- (NSMutableArray *)companyArray{
    if (_companyArray == nil) {
        _companyArray = [NSMutableArray array];
    }
    return _companyArray;
}


- (SKSTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[SKSTableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.SKSTableViewDelegate = self;
        _tableView.scrollEnabled = YES;
        _tableView.tableHeaderView = [[UIView alloc]init];
        CGRect frame=CGRectMake(0, 0, 0, 10);
        _tableView.tableHeaderView=[[UIView alloc]initWithFrame:frame];
    }
    return _tableView;
}

- (UIView *)searchView{
    if (_searchView == nil) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
        _searchView.backgroundColor = [UIColor clearColor];
        [_searchView addSubview:self.searchTF];
        [_searchView addSubview:self.searchCancelBtn];
    }
    return _searchView;
}

- (UITextField *)searchTF{
    if (_searchTF == nil) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, screenWidth-80, 34)];
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 30, 12)];
        UIImageView *leftView     = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 12, 12)];
        leftView.image = [UIImage imageNamed:@"icon_search"];
        leftView.contentMode      = UIViewContentModeCenter;
        [paddingView addSubview:leftView];
        _searchTF.backgroundColor = [UIColor whiteColor];
        _searchTF.layer.cornerRadius = 4;
        _searchTF.layer.borderWidth = 0;
        _searchTF.leftView        = paddingView;
        _searchTF.leftViewMode    = UITextFieldViewModeAlways;
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入公司名字";
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.textColor = [UIColor colorWithHexString:@"#999999"];
        _searchTF.tintColor = [UIColor colorWithHexString:@"#999999"];
        [_searchTF setReturnKeyType:UIReturnKeySearch];
        [_searchTF becomeFirstResponder];
        _searchTF.delegate = self;
    }
    return _searchTF;
}

- (UIButton *)searchCancelBtn{
    if (_searchCancelBtn == nil) {
        _searchCancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth-65, 5, 60, 34)];
        [_searchCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_searchCancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _searchCancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_searchCancelBtn addTarget:self action:@selector(popToLastNavi) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchCancelBtn;
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

- (NoneCompanyView *)noneView{
    if (_noneView == nil) {
        _noneView = [[NoneCompanyView alloc]initWithFrame:CGRectMake(0, 10, screenWidth, screenHeight-74)];
        [_noneView.createCompanyBtn addTarget:self action:@selector(gotoCreateCompany) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noneView;
}

#pragma mark-TextFieldDelegate


//删除按钮清空TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    DLog(@"%lu",newLength);
    if (newLength == 0) {
        [self.companyArray removeAllObjects];
        [self.tableView refreshData];
    }
    return YES;
}
//清空按钮清空TextField
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.companyArray removeAllObjects];
    [self.tableView refreshData];
    return YES;
}

//响应搜索动作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        [self loadCompanysList];
    }else{
        [self.searchTF resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchTF resignFirstResponder];
}

@end

























