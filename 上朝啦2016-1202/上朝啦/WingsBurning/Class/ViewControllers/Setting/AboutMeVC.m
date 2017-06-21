//
//  AboutMeVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "AboutMeVC.h"
#import "GuideVC.h"
#import "WebVC.h"
@interface AboutMeVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UIImageView *logoImgView;
@property(nonatomic,strong) UILabel *versionLabel;
@property(nonatomic,strong) UILabel *crLabel;
@property(nonatomic,strong) UILabel *appNameLabel;

@end

@implementation AboutMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)gotoAppScore{
    NSString *appID = @"1094650351";
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",appID]; //appID 解释如下
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)gotoNewFeature{
    GuideVC *guide = [[GuideVC alloc]init];
    [self presentViewController:guide animated:NO completion:^{

    }];
}

- (void)showServiceAgreement{
    WebVC *webVC = [[WebVC alloc]initWithTitleString:@"服务协议"];
    [self.navigationController pushViewController:webVC animated:YES];

}

- (void)showPrivacyPolicy{
    WebVC *webVC = [[WebVC alloc]initWithTitleString:@"隐私协议"];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark-TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46 * ratio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = [NSString stringWithFormat:@"cell%lu%lu",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14 * ratio];
    switch (indexPath.row) {
        case 0:cell.textLabel.text = @"欢迎页";break;
        case 1:cell.textLabel.text = @"去评分";break;
        case 2:cell.textLabel.text = @"服务协议";break;
        case 3:cell.textLabel.text = @"隐私协议";break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:NSLog(@"欢迎页");
            [self gotoNewFeature];
            break;
        case 1:NSLog(@"去评分");
            [self gotoAppScore];
            break;
        case 2:[self showServiceAgreement];break;
        case 3:[self showPrivacyPolicy];break;
        default:
            break;
    }

}


#pragma mark-控件布局
- (void)setUpUI{
    self.navigationItem.title = @"关于上朝啦";
    __weak typeof (self) weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(404 * ratio);
    }];
    [self.headView addSubview:self.logoImgView];
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.headView).offset(60 * ratio);
        make.centerX.mas_equalTo(weakSelf.headView.mas_centerX);
        make.height.width.mas_equalTo(90 * ratio);
    }];
    [self.headView addSubview:self.versionLabel];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.logoImgView.mas_bottom).offset(17 * ratio);
        make.centerX.mas_equalTo(weakSelf.headView.mas_centerX);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(weakSelf.headView.mas_bottom).offset(-40 * ratio);
    }];
    [self.view addSubview:self.appNameLabel];
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-14 * ratio);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(10);
    }];
    [self.view addSubview:self.crLabel];
    [self.crLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.appNameLabel.mas_top).offset(-8 * ratio);
    }];
    self.tableView.tableHeaderView = self.headView;
}

#pragma mark-控件设置
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.layer.borderWidth = 0;
    }
    return _tableView;
}

- (UIImageView *)logoImgView{
    if (_logoImgView == nil) {
        _logoImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_logo"]];
    }
    return _logoImgView;
}

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc]init];
        _headView.frame = CGRectMake(0, 0, screenWidth, 220 * ratio);
        _headView.backgroundColor = [UIColor colorWithHexString:@"#F0EFF4"];
    }
    return _headView;
}

- (UILabel *)versionLabel{
    if (_versionLabel == nil) {
        _versionLabel = [[UILabel alloc]init];
        NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        _versionLabel.text = [NSString stringWithFormat:@"版本 %@",version];
        _versionLabel.font = [UIFont systemFontOfSize:14 * ratio];
        _versionLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLabel;
}

- (UILabel *)crLabel{
    if (_crLabel == nil) {
        _crLabel = [[UILabel alloc]init];
        _crLabel.text = @"copyright 2016 all rights reserved";
        _crLabel.font = [UIFont systemFontOfSize:10];
        _crLabel.textColor = [UIColor colorWithHexString:@"#b7b7b7"];
        _crLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _crLabel;
}

- (UILabel *)appNameLabel{
    if (_appNameLabel == nil) {
        _appNameLabel = [[UILabel alloc]init];
        _appNameLabel.text = @"上朝啦";
        _appNameLabel.font = [UIFont systemFontOfSize:10];
        _appNameLabel.textColor = [UIColor colorWithHexString:@"#b7b7b7"];
        _appNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return  _appNameLabel;
}
@end


















