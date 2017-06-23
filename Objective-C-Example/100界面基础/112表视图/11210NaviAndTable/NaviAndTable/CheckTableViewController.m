//
//  CheckTableViewController.m
//  NaviAndTable
//
//  Created by niit on 16/3/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "CheckTableViewController.h"

// 练习:
// 实现多选:
// 1. 可以选中多个(提示:使用一个可变容器存放一下)
// 2. 某行再次点击取消选中
// *3. 使用已学的NSUserDefault保存选中信息。再次打开本页面时恢复。

@interface CheckTableViewController ()

@property (nonatomic,strong) NSArray *list;

// 记录你选中了那一项
@property (nonatomic,strong) NSIndexPath *lastIndexPath;

@end

@implementation CheckTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@"Who Hash",
                  @"Bubba Gump Shrimp Étouffée", @"Who Pudding", @"Scooby Snacks",
                  @"Everlasting Gobstopper", @"Green Eggs and Ham", @"Soylent Green",
                  @"Hard Tack", @"Lembas Bread", @"Roast Beast", @"Blancmange",@"Who Hash",
                  @"Bubba Gump Shrimp Étouffée", @"Who Pudding", @"Scooby Snacks",
                  @"Everlasting Gobstopper", @"Green Eggs and Ham", @"Soylent Green",
                  @"Hard Tack", @"Lembas Bread", @"Roast Beast", @"Blancmange",
                  @"Toy Story",@"A Bug's Life", @"Toy Story 2", @"Monsters, Inc.",
                  @"Finding Nemo", @"The Incredibles", @"Cars",
                  @"Ratatouille", @"WALL-E", @"Up", @"Toy Story 3",
                  @"Cars 2", @"Brave",@"Toy Story",
                  @"A Bug's Life", @"Toy Story 2", @"Monsters, Inc.",
                  @"Finding Nemo", @"The Incredibles", @"Cars",
                  @"Ratatouille", @"WALL-E", @"Up", @"Toy Story 3",
                  @"Cars 2", @"Brave",
                  @"Toy Story",
                  @"A Bug's Life", @"Toy Story 2", @"Monsters, Inc.",
                  @"Finding Nemo", @"The Incredibles", @"Cars",
                  @"Ratatouille", @"WALL-E", @"Up", @"Toy Story 3",
                  @"Cars 2", @"Brave"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.list[indexPath.row];
    
    if(self.lastIndexPath != nil && self.lastIndexPath.row == indexPath.row)// 如果是选中的行,设置为对勾
    {
        cell.accessoryType  = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 得到上次选中的单元格,取消对勾
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    
    // 得到当前选中的单元格,设置对勾
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // 保存当前选中项
    self.lastIndexPath = indexPath;
    
    // 取消表格本身的选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
