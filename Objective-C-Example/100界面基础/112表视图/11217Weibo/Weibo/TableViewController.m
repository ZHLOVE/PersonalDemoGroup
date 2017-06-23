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
    UINib *nib = [UINib nibWithNibName:@"StatusCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

// 预估单元格高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    StatusModel *status = self.list[indexPath.row];
    cell.status = status;
    
    return cell;
}

// 实际单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusModel *m = self.list[indexPath.row];
    return m.cellHeight;
}

@end
