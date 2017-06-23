//
//  TableViewController3.m
//  CustomCell
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController3.h"

#import "TableViewCell3.h"

@interface TableViewController3 ()
@property (nonatomic,strong) NSArray *list;
@end

@implementation TableViewController3

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
    
    [self.tableView registerClass:[TableViewCell3 class] forCellReuseIdentifier:@"Cell"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *d = self.list[indexPath.row];
    
    TableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:d[@"Icon"]];
    cell.nameLabel.text = d[@"Name"];
    cell.colorLabel.text = d[@"Color"];
    
    
    return cell;
}



@end
