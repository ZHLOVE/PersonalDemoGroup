//
//  TableViewController.m
//  WeiBoTableView
//
//  Created by student on 16/3/8.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewController.h"

#import "StatusCell.h"
#import "StatusModel.h"
@interface TableViewController ()

@property(nonatomic,strong)NSArray *list;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = [StatusModel statusArr];
    
    // 注册单元格模板
    UINib *nib = [UINib nibWithNibName:@"StatusCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    // 固定单元格高度
    self.tableView.rowHeight = 250;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //数据
    StatusModel *status = self.list[indexPath.row];
    //cell
    cell.status = status;
    
    return cell;
}

@end
