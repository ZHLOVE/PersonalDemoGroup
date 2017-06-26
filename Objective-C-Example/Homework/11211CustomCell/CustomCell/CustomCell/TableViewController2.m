//
//  TableViewController2.m
//  CustomCell
//
//  Created by student on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewController2.h"
#import "TableViewCell2.h"

@interface TableViewController2 ()<UITableViewDataSource,UITableViewDelegate>
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
    //1创建一个Nib对象
    UINib *nib = [UINib nibWithNibName:@"TableViewCell2" bundle:nil];
    // 2.注册表格单元格的模板,(dequeueReusableCellWithIdentifier查找可复用单元格查找不到，则自动用单元格模板创建新单元格)
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *d = self.list[indexPath.row];
    
    TableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:d[@"Icon"]];
    cell.nameLabel.text = d[@"Name"];
    cell.colorLabel.text = d[@"Color"];
    
    
    return cell;

}

@end
