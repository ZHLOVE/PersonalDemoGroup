//
//  HomeViewController.m
//  Weibo
//
//  Created by qiang on 4/21/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "HomeViewController.h"

#import "VisitorView.h"
#import "UIBarButtonItem+Create.h"
#import "TitleButton.h"

#import "PopoverViewController.h"
#import "QRCodeViewController.h"

#import "Status.h"
#import "StatusCell.h"


@interface HomeViewController ()

@property (nonatomic,strong) PopoverViewController *popVC;

@property (nonatomic,strong) NSArray *statusArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![[UserAccount sharedUserAccount] isLogined])
    {
        [self.vistorView setupVisitorInfo:YES imageName:@"visitordiscover_feed_image_house" message:@"关注一些人，回这里看看有什么惊喜"];
        
        return;
    }
    
    // 设置导航浪上的按钮
    [self setupNavi];
    
    // 监听菜单打开关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:kNontificationPopoverWillShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:kNontificationPopoverWillDismiss object:nil];
    
    // 获取微博数据
    [Status requestStatusWithSuccessBlock:^(NSArray *status) {
        self.statusArr = status;
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    // 单元格模板
    [self.tableView registerClass:[StatusCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)change
{
    TitleButton *titleBtn = self.navigationItem.titleView;
    titleBtn.selected = !titleBtn.selected;
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavi
{
    // 1. 添加左右的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItem:@"navigationbar_friendattention" target:self action:@selector(leftItemPressed:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItem:@"navigationbar_pop" target:self action:@selector(rightItemPressed:)];
    
    
    // 2. 创建标题按钮
    TitleButton *titleBtn = [[TitleButton alloc] init];
    [titleBtn setTitle:@"Qiang" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn sizeToFit];
    self.navigationItem.titleView = titleBtn;
}

- (void)leftItemPressed:(id)sender
{
    NSLog(@"%s",__func__);
}

- (void)rightItemPressed:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"QRCodeViewController" bundle:nil];
    
    UINavigationController *navi = sb.instantiateInitialViewController;
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)titleBtnPressed:(UIButton *)sender
{
    NSLog(@"%s",__func__);

    // 弹出菜单
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PopoverViewController" bundle:nil];
    PopoverViewController *popVC = sb.instantiateInitialViewController;
    self.popVC = popVC;
//    popVC.view.frame = CGRectMake(55, 56, 200, 350);
    popVC.view.frame = CGRectMake(55, 56-350/2, 200, 350);
    
    // 2. 在容器视图上添加一个蒙版
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    bgView.frame = [UIScreen mainScreen].bounds;
    [bgView addSubview:popVC.view];
    
//    [self.view addSubview:bgView]
//    [self.navigationController.view addSubview:bgView];
//    [self.tabBarController.view addSubview:bgView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    
    // 动画
    popVC.view.transform = CGAffineTransformMakeScale(1.0,0.0);
    popVC.view.layer.anchorPoint = CGPointMake(0.5, 0);
    [UIView animateWithDuration:1 animations:^{
//        popVC.view.alpha = 1.0;
        popVC.view.transform = CGAffineTransformMakeScale(1.0,1.0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDo:)];
    [bgView addGestureRecognizer:tap];
}

- (void)tapDo:(UITapGestureRecognizer *)g
{

    [UIView animateWithDuration:1 animations:^{
        self.popVC.view.transform = CGAffineTransformMakeScale(1.0,0.01);
    } completion:^(BOOL finished) {
        [self.popVC.view.superview removeFromSuperview];
    }];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Status *status = self.statusArr[indexPath.row];
    cell.status = status;
    return cell;
}

// 先给出预估的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

// 给出实际的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Status *status = self.statusArr[indexPath.row];
    return status.cellHeight;
}

@end
