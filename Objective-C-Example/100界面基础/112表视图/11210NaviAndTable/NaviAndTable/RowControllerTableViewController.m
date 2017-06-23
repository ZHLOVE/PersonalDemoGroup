//
//  RowControllerTableViewController.m
//  NaviAndTable
//
//  Created by niit on 16/3/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "RowControllerTableViewController.h"

@interface RowControllerTableViewController ()

@property (nonatomic,strong) NSArray *list;

@end

@implementation RowControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@"C3PO", @"Tik-Tok", @"Robby", @"Rosie", @"Uniblab",
                  @"Bender", @"Marvin", @"Lt. Commander Data",
                  @"Evil Brother Lore", @"Optimus Prime", @"Tobor", @"HAL",
                  @"Orgasmatron",@"C3PO", @"Tik-Tok", @"Robby", @"Rosie", @"Uniblab",
                  @"Bender", @"Marvin", @"Lt. Commander Data",
                  @"Evil Brother Lore", @"Optimus Prime", @"Tobor", @"HAL",
                  @"Orgasmatron"];
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
    
    // 创建按钮
    if(cell.accessoryView == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 50, 27);
        [btn setBackgroundImage:[UIImage imageNamed:@"button_up"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"button_down"] forState:UIControlStateHighlighted];
        [btn setTitle:@"按我!" forState:UIControlStateNormal];
        ;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
    }
    
    UIButton *btn = cell.accessoryView;
    btn.tag = indexPath.row;
    
    return cell;
}

- (void)btnPressed:(UIButton *)btn
{
    NSLog(@"选中了%@",self.list[btn.tag]);
}




@end
