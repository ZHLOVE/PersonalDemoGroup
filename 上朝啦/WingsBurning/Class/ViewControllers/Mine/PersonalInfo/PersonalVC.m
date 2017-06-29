//
//  PersonalVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "PersonalVC.h"
#import "CompanyListTableView.h"
#import "AuditingVC.h"
#import "RegisterCameraVC.h"
#import "ChangePhoneNum.h"
#import "PersonInfoCell.h"


@interface PersonalVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIBarButtonItem *leftBtn;
@property(nonatomic,strong) UITableView *tableView;
@end

@implementation PersonalVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.employee = [[EmployeeM alloc]init];
        self.employer = [[EmployerM alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self getContractInfoForCompanyName];
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)setEmployee:(EmployeeM *)employee{
    _employee = employee;
}

- (void)setEmployer:(EmployerM *)employer{
    _employer = employer;
}

- (void)leftBtnPressed{

}

/**
 *  获取合约信息
 */
- (void)getContractInfoForCompanyName{
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking huoQuDQHY:employee.ID token:tokens successBlock:^(ContractM *contract, EmployerM *employer) {
        self.employer = employer;
        self.contract = contract;
        [Verify saveEmployerToSH:employer];
        [self.tableView reloadData];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        self.contract.state = @" ";
        DLog(@"%@%ld",errStr,(long)statusCode);
        EmployerM *employerNone = [[EmployerM alloc]init];
        employerNone.name = @" ";
        self.employer = employerNone;
        [self.tableView reloadData];
    }];
}

- (void)gotoChangeFaceImage{
    RegisterCameraVC *cam = [[RegisterCameraVC alloc]init];
    cam.changeFace = YES;
    cam.firstPunch = NO;
    [self.navigationController pushViewController:cam animated:YES];
}



- (void)gotoCompanyList{
     __weak typeof (self) weakSelf = self;
    [self getContractInfo:^{
        CompanyListTableView *com = [[CompanyListTableView alloc]init];
        com.employee = self.employee;
        [weakSelf.navigationController pushViewController:com animated:YES];
    } AuditingBlock:^(ContractM *contract) {
        DLog(@"%@",contract.state);
        AuditingVC *au = [[AuditingVC alloc]init];
        au.contract = contract;
        au.employee = self.employee;
        [self.navigationController pushViewController:au animated:YES];
    }];
}


- (void)gotoChangePhoneNum{
    ChangePhoneNum *changePN = [[ChangePhoneNum alloc]init];
    [self.navigationController pushViewController:changePN animated:YES];
}


- (void)getContractInfo:(void (^)())goToCompanyListBlock
          AuditingBlock:(void (^)(ContractM *contract))goToAuditingBlock
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak typeof(self) weakSelf = self;
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking huoQuDQHY:self.employee.ID token:tokens successBlock:^(ContractM *contract, EmployerM *employer) {
        [hud hideAnimated:YES];
        weakSelf.contract = contract;
        BOOL flag1 = [contract.state isEqualToString:@"terminated"];
        BOOL flag2 = [contract.state isEqualToString:@"rejected"];
        [Verify saveContractIDToSandBox:contract.ID];
        if (flag1 || flag2) {
            goToCompanyListBlock();
        }else{
            goToAuditingBlock(contract);
        }
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        [hud setMode:MBProgressHUDModeText];
        if (statusCode == 404) {
            [hud hideAnimated:YES];
            goToCompanyListBlock();
        }else{
            NSString *str = [NSString stringWithFormat:@"请检查网络"];
            DLog(@"%ld",(long)statusCode);
            hud.label.text = str;
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];
}



#pragma mark-tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:return 1;break;
        case 1:return 3;break;
        default:return 0;break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:return 60 * ratio;break;
        case 1:return 46 * ratio;break;
        default:return 46 * ratio;break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * ratio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *cusCellID = [NSString stringWithFormat:@"cell%lu%lu",(long)indexPath.row,(long)indexPath.section];
        PersonInfoCell *cusCell = [tableView dequeueReusableCellWithIdentifier:cusCellID];
        if (!cusCell) {
            cusCell =[[PersonInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cusCellID];
        }
        cusCell.textLabel.text = @"人脸信息";
        cusCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cusCell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        cusCell.textLabel.font = [UIFont systemFontOfSize:14 * ratio];
        cusCell.detailTextLabel.font = [UIFont systemFontOfSize:14 * ratio];
        cusCell.employee = self.employee;
        return cusCell;
    }else{
        NSString *cellID = [NSString stringWithFormat:@"cell%lu%lu",(long)indexPath.row,(long)indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        switch (indexPath.section) {
            case 0:
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"真实姓名";
                        cell.detailTextLabel.text = self.employee.name;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        break;
                    case 1:
                        cell.textLabel.text = @"公司名称";
                        if ([self.contract.state isEqualToString:@"等待合约审核"]) {
                            cell.detailTextLabel.text = @"等待合约审核";
                        }else{
                            cell.detailTextLabel.text = self.employer.name;
                        }
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        break;
                    case 2:
                        cell.textLabel.text = @"手机号码";
                        cell.detailTextLabel.text = self.employee.phone_number;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        break;
                    default:
                        break;
                }
                default:
                break;
        }
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        cell.textLabel.font = [UIFont systemFontOfSize:14 * ratio];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14 * ratio];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            [self gotoChangeFaceImage];
            break;
        default:
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                    [self gotoCompanyList];
                    break;
                case 2:
                    [self gotoChangePhoneNum];
                    break;
                default:break;
            }
            break;
    }
}

#pragma MARK-控件布局
- (void)setUpUI{
    self.navigationItem.title = @"个人信息";
     __weak typeof (self) weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(300 * ratio);
        make.left.right.mas_equalTo(weakSelf.view);
    }];
}

#pragma mark-控件设置
- (UIBarButtonItem *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnPressed)];
    }
    return _leftBtn;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.scrollEnabled = NO;
    }
    return  _tableView;
}



@end

