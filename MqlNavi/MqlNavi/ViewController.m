//
//  ViewController.m
//  MqlNavi
//
//  Created by MBP on 2017/4/14.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "ViewController.h"
#import "NextVC.h"
#import "UIViewController+NaviGradient.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *mainTableView;

@end

@implementation ViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
    self.automaticallyAdjustsScrollViewInsets = false;
    self.title = @"某乎日报";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"0.0";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 200;
    }else{
        return 46;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = [NSString stringWithFormat:@"cell%lu%lu",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    cell.textLabel.text = @"滑动tableView导航条渐变";
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor blueColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NextVC *next = [[NextVC alloc]init];
    [self.navigationController pushViewController:next animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSString *alpha = [NSString stringWithFormat:@"%0.1f",(scrollView.contentOffset.y - 64)/64];
    NSLog(@"%f>>>>>>>>%@",scrollView.contentOffset.y,alpha);
    self.navBarBgAlpha = alpha;
}

- (void)toNextView {
    NextVC *nextVC = [[NextVC alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}



- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    if ([subviews count] == 0) return;
    for (UIView *subview in subviews) {
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        NSLog(@"%@%d: %@", blank, level, subview.class);
        [self getSub:subview andLevel:(level+1)];
    }
}

- (UITableView *)mainTableView{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]init];
        _mainTableView.frame = self.view.frame;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}


@end
