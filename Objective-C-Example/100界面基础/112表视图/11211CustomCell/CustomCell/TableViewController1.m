//
//  TableViewController1.m
//  CustomCell
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController1.h"

#import "TableViewCell.h"

@interface TableViewController1 ()

@property (nonatomic,strong) NSArray *list;

@end

@implementation TableViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@{@"Name":@"MacPro",
                    @"Icon":@"macpro.jpg",
                    @"Color":@"White"},
                  @{@"Name":@"iMac",
                    @"Icon":@"imac.jpg",
                    @"Color":@"Black"},
                  @{@"Name":@"MacBook Air",
                    @"Icon":@"macbookair.jpg",
                    @"Color":@"Sliver"},
                  @{@"Name":@"Mac mini",
                    @"Icon":@"macmini.jpg",
                    @"Color":@"Sliver"},
                  @{@"Name":@"MacBookpro",
                    @"Icon":@"macbookpro.jpg",
                    @"Color":@"Sliver"}];
    
    self.tableView.rowHeight = 140;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    // Configure the cell...
    NSDictionary *d = self.list[indexPath.row];
    
    // 方式1: 不自定义UITableViewCell,通过Tag找到原型单元格上的对象
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];    
//    UIImageView *iconImageView = [cell.contentView viewWithTag:101];
//    UILabel *nameLabel = [cell.contentView viewWithTag:102];
//    UILabel *colorLabel = [cell.contentView viewWithTag:103];
//    iconImageView.image = [UIImage imageNamed:d[@"Icon"]];
//    nameLabel.text = d[@"Name"];
//    colorLabel.text = d[@"Color"];
    
    // 方式2: 自定义UITableViewCell，将原型单元格上的对象拉出来属性来，以便访问
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:d[@"Icon"]];
    cell.nameLabel.text = d[@"Name"];
    cell.colorLabel.text = d[@"Color"];
    
    
    return cell;
}


@end
