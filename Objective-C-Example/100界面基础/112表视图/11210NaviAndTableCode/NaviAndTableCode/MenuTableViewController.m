//
//  MenuTableViewController.m
//  NaviAndTableCode
//
//  Created by niit on 16/3/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "MenuTableViewController.h"

#import "DisclosureTableViewController.h"

@interface MenuTableViewController ()

@property (nonatomic,strong) NSArray *list;
@property (nonatomic,strong) NSArray *imageNameList;

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"目录";
    
    self.list =   @[@"箭头",@"选择",@"行控制",@"移动",@"删除",@"添加",@"编辑"];
    
    self.imageNameList = @[@"disclosureButtonControllerIcon.png",@"checkmarkControllerIcon.png",@"rowControlsIcon.png",@"moveMeIcon.png",@"deleteMeIcon.png",@"deleteMeIcon.png",@"detailEditIcon.png"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
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
    cell.imageView.image = [UIImage imageNamed:self.imageNameList[indexPath.row]];
    
    return cell;
}

// 点击菜单项的时候，创建新的控制器，push到导航栏控制器
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            DisclosureTableViewController *dVC = [[DisclosureTableViewController alloc] init];
            [self.navigationController pushViewController:dVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
