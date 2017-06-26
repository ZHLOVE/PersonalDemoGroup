//
//  DisclosureTableViewController.m
//  11210
//
//  Created by student on 16/3/4.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DisclosureTableViewController.h"

@interface DisclosureTableViewController ()

@property(nonatomic,strong) NSArray *list;

@end

@implementation DisclosureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
//    NSLog(@"%s ***************",__func__);
    
    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.list[indexPath.row];
    //右侧列按钮样式
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
}

#pragma mark 选中时高亮开关
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<5) {
        return NO;
    }else{
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

// 某行已经被取消选中时触发
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s:%li行已经被取消选中",__func__,indexPath.row);
}

#pragma mark - accessory触发
// 点了右侧accessoryButton触发的方法
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你的选择电影是" message:self.list[indexPath.row] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
