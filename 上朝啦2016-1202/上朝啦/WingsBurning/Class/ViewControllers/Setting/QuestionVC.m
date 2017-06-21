//
//  QuestionVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/25.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "QuestionVC.h"

@interface QuestionVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *phoneBtn;
@property(nonatomic,strong) UILabel *phoneCallLabel;
@property(nonatomic,strong) UIWebView *questionView;

@end

@implementation QuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
    self.navigationItem.title = @"常见问题";
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.questionView];
    [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-46 * ratio);
    }];
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.view);
//        make.left.right.mas_equalTo(weakSelf.view);
//        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-46 * ratio);
//    }];
    [self.view addSubview:self.phoneCallLabel];
    [self.phoneCallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(46 * ratio);
    }];
    [self.view addSubview:self.phoneBtn];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-15 * ratio);
        make.width.mas_equalTo(100 * ratio);
        make.height.mas_equalTo(46 * ratio);
        make.centerY.mas_equalTo(weakSelf.phoneCallLabel.mas_centerY);
    }];
}

- (void)phoneBtnPressed{
    NSString *phoneNum = @"0510-81819939";// 电话号码
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

#pragma mark-tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 17;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46 * ratio;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20 * ratio;
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 0: cell.textLabel.text = @"打卡无法定位成功，怎么办？";break;
                case 1: cell.textLabel.text = @"如何使用打卡?";break;
                case 2: cell.textLabel.text = @"打卡可以更好手机设备么?";break;
                case 3: cell.textLabel.text = @"外勤人员如何打卡?";break;
                case 4: cell.textLabel.text = @"打卡无法定位成功，怎么解决?";break;
                case 5: cell.textLabel.text = @"打卡未成功，怎么办?";break;
                case 6: cell.textLabel.text = @"打卡头像总是识别识别，怎么办?";break;
                case 7: cell.textLabel.text = @"打卡记录未显示，怎么解决?";break;
                default:cell.textLabel.text = @"打卡记录未显示，怎么解决?";break;
            }
            break;
        default:
            break;
    }
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma MARK-控件设置
- (UITableView *)tableView{
    if (_tableView == nil) {
        CGRect tableFrame = self.view.frame;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height - 46 * ratio) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.scrollEnabled = YES;
        _tableView.layer.borderWidth = 0;
    }
    return _tableView;
}

- (UIWebView *)questionView{
    if (_questionView == nil) {
        CGRect tableFrame = self.view.frame;
        _questionView = [[UIWebView alloc]initWithFrame:CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height - 46 * ratio)];
        NSURL* url = [NSURL URLWithString:@"http://www.shangchao.la/questions.html"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [_questionView loadRequest:request];
    }
    return _questionView;
}

- (UIButton *)phoneBtn{
    if (_phoneBtn == nil) {
        _phoneBtn = [[UIButton alloc]init];
        [_phoneBtn setTitle:@"服务热线" forState:UIWindowLevelNormal];
        _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_phoneBtn setTitleColor:[UIColor colorWithHexString:@"#03c873"] forState:UIWindowLevelNormal];
        [_phoneBtn setImage:[UIImage imageNamed:@"icon_hotline"] forState:UIWindowLevelNormal];
        _phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _phoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _phoneBtn.backgroundColor = [UIColor clearColor];
        [_phoneBtn addTarget:self action:@selector(phoneBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (UILabel *)phoneCallLabel{
    if (_phoneCallLabel == nil) {
        _phoneCallLabel = [[UILabel alloc]init];
        _phoneCallLabel.backgroundColor = [UIColor whiteColor];
        _phoneCallLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _phoneCallLabel.font = [UIFont systemFontOfSize:14];
        _phoneCallLabel.text = @"   还没解决您的问题？";
    }
    return _phoneCallLabel;
}














@end
