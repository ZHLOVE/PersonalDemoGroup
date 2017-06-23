//
//  TableViewController2.m
//  CustomCell
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController2.h"

#import "TableViewCell2.h"

// 流程:
// 1. 新建一个UITableViewCell的子类，勾上xib
// 2. 在xib上设计界面，将界面对象拉出输出口
// 3. 表格视图控制器中注册单元格模板
    //UINib *nib = [UINib nibWithNibName:@"TableViewCell2" bundle:nil];
    //[self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];


@interface TableViewController2 ()

@property (nonatomic,strong) NSArray *list;

@end

@implementation TableViewController2

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
    
    // 1.创建一个nib对象
    UINib *nib = [UINib nibWithNibName:@"TableViewCell2" bundle:nil];
    // 2.注册表格单元格的模板,(dequeueReusableCellWithIdentifier查找可复用单元格查找不到，则自动用单元格模板创建新单元格)
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
        
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *d = self.list[indexPath.row];
    
    TableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:d[@"Icon"]];
    cell.nameLabel.text = d[@"Name"];
    cell.colorLabel.text = d[@"Color"];
    
    
    return cell;
}


@end
