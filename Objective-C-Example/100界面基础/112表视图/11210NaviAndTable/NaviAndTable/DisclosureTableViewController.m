//
//  DisclosureTableViewController.m
//  NaviAndTable
//
//  Created by niit on 16/3/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DisclosureTableViewController.h"

@interface DisclosureTableViewController ()

@property (nonatomic,strong) NSArray *list;
@end

@implementation DisclosureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@"Toy Story",@"A Bug's Life", @"Toy Story 2", @"Monsters, Inc.",
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.list[indexPath.row];
    // 右侧按钮的样式
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

#pragma mark - 选中时的高亮 设置与事件
// 选中的时候是否要高亮
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0)
{
    if(indexPath.row<3)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSLog(@"%s:%li行已经高亮",__func__,(long)indexPath.row);
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSLog(@"%s:%li行已经取消高亮",__func__,(long)indexPath.row);
}

#pragma mark - 选中时触发的方法
// 将要取消选中某行的方法
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s:%li行将要被取消选中",__func__,(long)indexPath.row);
    
    return indexPath;
}

// 某行已经被取消选中时触发
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s:%li行已经被取消选中",__func__,indexPath.row);
}

// 将要选中的时触发的方法(在这里可以禁止用户选择某些行)
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s:%li行将要被选中",__func__,(long)indexPath.row);
    if(indexPath.row<3)
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}

// 已经选中某行触发的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s:%li行已经被选中",__func__,indexPath.row);
    // UIAlertController 替代 UIAlertView
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"去按右侧的按钮,别按我!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - accessory相关
// 点了右侧accessoryButton触发的方法
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你的选择电影是" message:self.list[indexPath.row] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

// 根据不同行，显示不同accessory,
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<3)
    {
        return 0;
    }
    else
    {
        return UITableViewCellAccessoryDetailButton;
    }
}
//WARNING: Using legacy cell layout due to delegate implementation of tableView:accessoryTypeForRowWithIndexPath: in <DisclosureTableViewController: 0x7fdbeaebd470>.  Please remove your implementation of this method and set the cell properties accessoryType and/or editingAccessoryType to move to the new cell layout behavior.  This method will no longer be called in a future release.
//(提示:Xcode不建议使用,说以后该方法会完全弃用,不起作用。建议通过修改单元格的cell.accessoryType方式)


@end
