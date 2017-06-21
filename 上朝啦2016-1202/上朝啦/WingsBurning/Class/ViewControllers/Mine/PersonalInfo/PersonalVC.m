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
@interface PersonalVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIImageView *porImgView;
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
        UINavigationController *naviAu = [[UINavigationController alloc]initWithRootViewController:au];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.2];
        [animation setType:kCATransitionReveal];
        [animation setSubtype:kCATransitionFromRight];
        [[[[UIApplication sharedApplication]keyWindow]layer]addAnimation:animation forKey:nil];
        [weakSelf presentViewController:naviAu animated:NO completion:nil];
    }];
}


- (void)gotoChangePhoneNum{
    ChangePhoneNum *changePN = [[ChangePhoneNum alloc]init];
    [self.navigationController pushViewController:changePN animated:YES];
}


- (void)getContractInfo:(void (^)())goToCompanyListBlock
          AuditingBlock:(void (^)(ContractM *contract))goToAuditingBlock
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    __weak typeof(self) weakSelf = self;
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking huoQuDQHY:self.employee.ID token:tokens successBlock:^(ContractM *contract, EmployerM *employer) {
        [hud hide:YES];
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
        [hud setCenter:self.view.center];
        if (statusCode == 404) {
            [hud hide:YES];
            goToCompanyListBlock();
        }else{
            NSString *str = [NSString stringWithFormat:@"请检查网络"];
            DLog(@"%ld",(long)statusCode);
            [hud setLabelText:str];
            [hud hide:YES afterDelay:2.0];
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
    NSString *reuseID = [NSString stringWithFormat:@"cell%lu%lu",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"人脸信息";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = self.porImgView;
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"真实姓名";
                    cell.detailTextLabel.text = self.employee.name;
                    break;
                case 1:
                    cell.textLabel.text = @"公司名称";
                    cell.detailTextLabel.text = self.employer.name;
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
- (UIImageView *)porImgView{
    if (_porImgView == nil) {
        _porImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 37, 46)];
        _porImgView.layer.cornerRadius = 4;
        _porImgView.contentMode = UIViewContentModeScaleAspectFill;
        NSData *imgData = [Verify getImage];
        UIImage *img = [[UIImage alloc]initWithData:imgData];
        if (img) {
            [_porImgView setImage:img];
        }else{
            [_porImgView sd_setImageWithURL:[NSURL URLWithString:self.employee.avatar_url] placeholderImage:[UIImage imageNamed:@"default_touxiang"]];
        }
        _porImgView.layer.masksToBounds = YES;
        _porImgView.userInteractionEnabled = YES;
    }
    return _porImgView;
}

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

