//
//  TableViewController.m
//  TuanGou
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController.h"


#import "TgModel.h"
#import "TgViewCell.h"

@interface TableViewController ()

@property (nonatomic,strong) NSMutableArray *list;

@end

@implementation TableViewController

- (NSArray *)list
{
    if(_list == nil)
    {
        _list = [TgModel tgList];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    TgModel *m = self.list[indexPath.row];
    cell.tg = m;
    
    return cell;
}

@end
