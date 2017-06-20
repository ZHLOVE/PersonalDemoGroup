//
//  CookTableViewController.m
//  LGJ
//
//  Created by student on 16/5/12.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "CookTableViewController.h"
#import "UIBarButtonItem+Create.h"
#import "AddFoodViewController.h"
#import "TableViewCell.h"
#import "DataBase.h"
#import "DataModel.h"
@interface CookTableViewController ()

@property (nonatomic,strong) NSMutableArray *foodArray;

@end

@implementation CookTableViewController



- (NSArray *)foodArray{
    if (_foodArray == nil) {
        _foodArray = [[DataBase quaryAllData] mutableCopy];
    }
    return _foodArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNaivUI];
    // 单元格模板
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"Cell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.foodArray = [[DataBase quaryAllData] mutableCopy];
    DLog(@"测试数据数量:%lu",self.foodArray.count);
    [self.tableView reloadData];
}

#pragma mark UI设置
- (void)setUpNaivUI{
    // 1. 添加左右的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItem:@"tabbar_compose_icon_add" target:self action:@selector(rightItemPressed:)];
  
}

- (void)leftItemPressed:(id)sender
{

}

- (void)rightItemPressed:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AddFoodViewController" bundle:nil];
    UINavigationController *navi = sb.instantiateInitialViewController;
    [self presentViewController:navi animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.foodArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.model = self.foodArray[indexPath.row];
    return cell;
}

// 先给出预估的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

// 给出实际的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark 左滑删除
//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DataModel *model = self.foodArray[indexPath.row];
        int gid = model.gid;
        [DataBase deleteWithGid:gid];
        [self.foodArray removeObject:model];
        //先删数组，再删界面上单元格
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   DataModel *dataModel = self.foodArray[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AddFoodViewController" bundle:nil];
    
    UINavigationController *navi = sb.instantiateInitialViewController;
    AddFoodViewController *vc = navi.viewControllers[0];
    vc.model = dataModel;
    
    [self presentViewController:navi animated:YES completion:nil];
    
}



@end
