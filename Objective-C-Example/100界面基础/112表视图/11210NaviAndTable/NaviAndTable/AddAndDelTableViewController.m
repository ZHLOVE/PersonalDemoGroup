//
//  AddAndDelTableViewController.m
//  NaviAndTable
//
//  Created by niit on 16/3/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AddAndDelTableViewController.h"

@interface AddAndDelTableViewController ()
{
    BOOL bAdded;// 保存当前时候有添加一行"添加新同学“的格子
}
@property (nonatomic,strong) NSMutableArray *mList;


@end

@implementation AddAndDelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mList = [@[@"张三",@"李四",@"王五"] mutableCopy];
    
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

    if(self.tableView.editing && !bAdded)
    {
        bAdded = YES;// (注意:此行需写在insert操作之前,因为执行insertRowsAtIndexPaths时，会立即刷新tableView，会立即调用获取数据的方法。)
        // 如果进入编辑状态,我们就为表格添加一行（添加新同学的按钮）
        NSIndexPath *tmpPath = [NSIndexPath indexPathForRow:self.mList.count inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[tmpPath] withRowAnimation:UITableViewRowAnimationLeft];
    }

    if(!self.tableView.editing && bAdded)
    {
        bAdded = NO;
        // 取消编辑状态，删除最后一行添加新同学的按钮
        NSIndexPath *tmpPath = [NSIndexPath indexPathForRow:self.mList.count inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[tmpPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(bAdded)
    {
        return self.mList.count+1;
    }
    return self.mList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(indexPath.row == self.mList.count)
    {
        cell.textLabel.text = @"添加新同学";// 如果是最后一行
    }
    else
    {
        cell.textLabel.text = self.mList[indexPath.row];
    }
    
    return cell;
}

// 当表格处于编辑状态时，单元格的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.mList.count)
    {
        return UITableViewCellEditingStyleInsert;// 如果是最后一行，显示添加按钮
    }
    else
    {
        return UITableViewCellEditingStyleDelete;// 如果是最后一行，显示删除按钮
    }
}

// 编辑(删除和添加)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 1. 从数据中删除
        [self.mList removeObjectAtIndex:indexPath.row];
        // 2. 表格视图中单元格也要删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    // 添加触发的方法
    if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        // 1. 数据要添加
        [self.mList addObject:[NSString stringWithFormat:@"新同学%i",self.mList.count]];
        // 2. 新的一行
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

@end
