//
//  CheckTableViewController.m
//  NaviAndTable
//
//  Created by niit on 16/3/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "MultiCheckTableViewController.h"

// 练习:
// 实现多选:
// 1. 可以选中多个(提示:使用一个可变容器存放一下)
// 2. 某行再次点击取消选中
// *3. 使用已学的NSUserDefault保存选中信息。再次打开本页面时恢复。

@interface MultiCheckTableViewController ()

@property (nonatomic,strong) NSArray *list;

// 定义一个数组存放选中了哪些行
@property (nonatomic,strong) NSMutableArray *checkedList;


@end

@implementation MultiCheckTableViewController

- (NSMutableArray *)checkedList
{
    if(_checkedList == nil)
    {
        _checkedList = [NSMutableArray array];
        
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        NSArray *l = [d objectForKey:@"CheckedList"];
        [_checkedList addObjectsFromArray:l];
    }
    return _checkedList;
}

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
    
    if([self.checkedList containsObject:@(indexPath.row)])
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断之前有没有选中过
    if([self.checkedList containsObject:@(indexPath.row)])
    {
        // 之前选中过,移除
        [self.checkedList removeObject:@(indexPath.row)];
        // 视图上改变
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        // 添加
        [self.checkedList addObject:@(indexPath.row)];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [self saveCheched];
    
    // 取消表格本身的选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)saveCheched
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:self.checkedList forKey:@"CheckedList"];
    [d synchronize];
}

@end
