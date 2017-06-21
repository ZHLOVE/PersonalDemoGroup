//
//  MainLeftVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "MainLeftVC.h"
#import "HeadView.h"


@interface MainLeftVC ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UITableView *leftTableView;

@end

static NSArray *iconNameArr;
static NSArray *titleStrArr;

@implementation MainLeftVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        iconNameArr = @[@"sidebar_icon_clockin",@"sidebar_icon_record",@"sidebar_icon_lend",@"sidebar_icon_setting"];
        titleStrArr = @[@"打卡",@"打卡记录",@"借他打卡",@"设置"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    [self setUpUI];
}


- (void)setUpUI{
    [self.view addSubview:self.leftTableView];
}

- (void)setTableView{
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoPersonalInfo)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    HeadView *headV = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, screenWidth - 100*ratio, 162 * ratio)];
    self.leftTableView.tableHeaderView = headV;
    [self.leftTableView.tableHeaderView addGestureRecognizer:tapGesture];
}
- (void)gotoPersonalInfo{

}

#pragma mark-TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"cell%lu %lu",indexPath.row,indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = titleStrArr[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    NSString *str = iconNameArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:str];
    return cell;
}

- (UITableView *)leftTableView{
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth , screenHeight) style:UITableViewStylePlain];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _leftTableView;
}

@end




