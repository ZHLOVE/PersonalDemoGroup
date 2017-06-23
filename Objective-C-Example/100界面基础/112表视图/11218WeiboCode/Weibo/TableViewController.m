//
//  TableViewController.m
//  Weibo
//
//  Created by niit on 16/3/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController.h"

#import "StatusModel.h"

#import "StatusCell.h"

@interface TableViewController ()

@property (nonatomic,strong) NSArray *list;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.list = [StatusModel statusArr];
    
    // 注册单元格模板
    [self.tableView registerClass:[StatusCell class] forCellReuseIdentifier:@"Cell"];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

// 预估单元格高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s 第%i行 单元格预估高度",__func__,indexPath.row);
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s 第%i行 单元格内容设置",__func__,indexPath.row);
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    StatusModel *status = self.list[indexPath.row];
    cell.status = status;
    
    return cell;
}

// 实际单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusModel *m = self.list[indexPath.row];
    NSLog(@"%s 第%i行 单元格高度 = %g",__func__,indexPath.row,m.cellHeight);
    return m.cellHeight;
}

@end
