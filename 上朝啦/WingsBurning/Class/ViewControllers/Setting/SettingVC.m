//
//  SettingVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "SettingVC.h"
#import "QuestionVC.h"
#import "FeedbackVC.h"
#import "AboutMeVC.h"
#import "JPUSHService.h"
#import "Login.h"
@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource,CustomIOSAlertViewDelegate>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}



- (void)setUpUI{
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.tableView];
}



#pragma mark-tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:return 2;break;
        case 1:return 1;break;
        default:return 0;break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46 * ratio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10 * ratio;
            break;
        case 1:
            return 20 * ratio;
            break;
        default:
            return 10 * ratio;
            break;
    }
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
        case 1:
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"退出登录";
            break;
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"icon_question"];
                    cell.textLabel.text = @"常见问题";
                    break;
                case 1:
                    cell.textLabel.text = @"关于上朝啦";
                    cell.imageView.image = [UIImage imageNamed:@"icon_about"];
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)goToQuestion{
    QuestionVC *qu = [[QuestionVC alloc]init];
    [self.navigationController pushViewController:qu animated:YES];
}

- (void)goToFeedback{
    FeedbackVC *fe = [[FeedbackVC alloc]init];
    [self.navigationController pushViewController:fe animated:YES];
}
- (void)goToAboutMe{
    AboutMeVC *ab = [[AboutMeVC alloc]init];
    [self.navigationController pushViewController:ab animated:YES];
}

- (void)goToLogout{
    [self showAlert];
}

- (void)showAlert{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    CustomView *customView = [[CustomView alloc]initWithTitle:@"退出上朝啦" andDetail:@"退出后不会删除历史数据，下次登录依然可以使用本账号。"];
    [alertView setContainerView:customView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确认退出", nil]];
    [alertView setDelegate:self];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {}];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

//AlertDelegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [alertView close];
        EmployeeM *employee = [Verify getEmployeeFromSandBox];
        [Verify removeToken]; 
        [JPUSHService setAlias:@"0" callbackSelector:nil object:self];
        Login *outVC = [[Login alloc]initWithEmployee:employee];
        [self.navigationController pushViewController:outVC animated:YES];
    }
    [alertView close];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self goToQuestion];
                break;
            case 1:
                [self goToAboutMe];
                break;
            default:
                break;
        }

    }else{
        [self goToLogout];
    }
}




#pragma mark-控件设置
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


@end
