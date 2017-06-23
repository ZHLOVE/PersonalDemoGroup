//
//  MoveTableViewController.m
//  NaviAndTable
//
//  Created by niit on 16/3/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "MoveTableViewController.h"

@interface MoveTableViewController ()

@property (nonatomic,strong) NSMutableArray *list;

@end

@implementation MoveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = [@[@"Eeny", @"Meeny", @"Miney", @"Moe", @"Catch", @"A",
                  @"Tiger", @"By", @"The", @"Toe"] mutableCopy];
    
    // 导航栏右侧添加按钮
    UIBarButtonItem *moveBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMove)];
    self.navigationItem.rightBarButtonItem = moveBtn;
}

// 切换表格的状态
- (void)toggleMove
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    // 根据表格的编辑状态，切换按钮文字
    [self.navigationItem.rightBarButtonItem setTitle:self.tableView.editing?@"完成":@"编辑"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.list[indexPath.row];
    
    return cell;
}

// 当表格处于编辑状态时，单元格的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

// 移动单元格的处理代码 (只需要处理数据)
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 得到正在移动的对象
    NSString *obj = self.list[sourceIndexPath.row];
    // 从原来的位置删除
    [self.list removeObject:obj];
    // 插入到新位置
    [self.list insertObject:obj atIndex:destinationIndexPath.row];
}


@end
