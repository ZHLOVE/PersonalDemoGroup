//
//  BorrowSearchResultVC.m
//  WingsBurning
//
//  Created by MBP on 2016/12/8.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BorrowSearchResultVC.h"
#import "BorrowTableViewCell.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
#import "PunchCameraVC.h"
#import "CustomPopView.h"

@interface BorrowSearchResultVC()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UIView *searchView;
@property(nonatomic,strong) UITextField *searchTF;
@property(nonatomic,strong) UIButton *searchCancelBtn;
@property(nonatomic,strong) UIView *noneView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *resultArray;
@property(nonatomic,copy) NSString *searchText;
@property(nonatomic,strong) PageM *pageM;
@property(nonatomic,strong) CustomPopView *popView;
@property(nonatomic,strong) UIButton *popViewCloseBtn;
@property(nonatomic,strong) EmployerM *employer;
@property(nonatomic,strong) TokensM *tokens;
@property(nonatomic,strong) UIView *blackView;

@end

@implementation BorrowSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.searchView];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.noneView removeFromSuperview];
}

- (void)popToLastNavi{
    [self.searchView removeFromSuperview];
    NSArray *array =  self.navigationController.viewControllers;
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: (array.count - 2)] animated:NO];
}

- (void)setUpUI{
    self.navigationItem.title = @"借他打卡";
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(weakSelf.view);
    }];
    [self.view addSubview:self.noneView];
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
    __weak typeof(self) weakSelf = self;
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    self.blackView.alpha = 0.6;
    [window addSubview:self.blackView];
    NSString *changeTime = [NSString stringWithFormat:@"%@-%@",[period.begin_at substringWithRange:NSMakeRange(0, 5)],[period.end_at substringWithRange:NSMakeRange(0, 5)]];
    self.popView.waringTime = changeTime;
    [window addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(315 * ratio);
        make.height.mas_equalTo(280 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY);
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
        make.centerX.mas_equalTo(window.mas_centerX);
        make.centerY.mas_equalTo(window.mas_centerY);
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
        _tableView.backgroundView = [UIView new];
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
        _searchTF.placeholder = @"请输入姓名";
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

- (UIView *)noneView{
    if (_noneView == nil) {
        _noneView = [[UIView alloc]initWithFrame:self.view.frame];
        _noneView.backgroundColor = [UIColor clearColor];
    }
    return _noneView;
}

- (NSMutableArray *)sectionArr{
    if (_sectionArr == nil) {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchView removeFromSuperview];
    self.employee = self.resultArray[indexPath.row];
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
    EmployeeM *employee = self.resultArray[indexPath.row];
    cell.employee = employee;
    return cell;
}

#pragma mark-TextFieldDelegate
//响应搜索动作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (_searchTF.text.length < 1) {
        [self.searchTF resignFirstResponder];
    }else{
        [self searchName];
    }
    return YES;
}

//删除按钮清空TextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    DLog(@"%lu",(unsigned long)newLength);
    if (newLength == 0) {
        [self.resultArray removeAllObjects];
        [self.tableView reloadData];
    }
    return YES;
}
//清空按钮清空TextField
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.resultArray removeAllObjects];
    [self.tableView reloadData];
    return YES;
}

- (void)searchName{
    __weak typeof (self) weakSelf = self;
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    TokensM *tokens = [Verify getTokenFromSanBox];
    PageM *tempPage = [[PageM alloc]init];
    tempPage.page = @1;
    tempPage.per_page = @35;
    self.pageM = tempPage;
    [Networking souSuoGYLB:employee.ID name:self.searchTF.text token:tokens page:tempPage successBlock:^(NSArray *colleagues, PageM *page) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (ColleaguesContractM *coll in colleagues) {
            if (coll != nil) {
                EmployeeM *ee = coll.employee;
                [mArr addObject:ee];
            }
        }
        weakSelf.resultArray = [mArr mutableCopy];
        if (self.resultArray.count == 0) {
            [self.view addSubview:self.noneView];
            UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            [hud setMode:MBProgressHUDModeText];
            NSString *str = [NSString stringWithFormat:@"您的公司暂无此人"];
            hud.label.text = str;
            [hud hideAnimated:YES afterDelay:1.5];
            [weakSelf.tableView reloadData];
            [weakSelf.searchTF becomeFirstResponder];
        }else{
            [self.noneView removeFromSuperview];
            [self.searchTF resignFirstResponder];
            [weakSelf.tableView reloadData];
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        DLog(@"%@",errStr);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchTF resignFirstResponder];
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
