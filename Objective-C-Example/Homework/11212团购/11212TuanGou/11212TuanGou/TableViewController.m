//
//  TableViewController.m
//  11212TuanGou
//
//  Created by 马千里 on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewController.h"

#import "TgModell.h"
#import "TgViewCell.h"


@interface TableViewController ()

@property (nonatomic,strong) NSMutableArray *list;

@end



@implementation TableViewController

- (NSMutableArray *)list{
    if (_list == nil) {
        _list = [[TgModell tgList]mutableCopy];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //???///
    TgModell *m = self.list[indexPath.row];
    cell.tg = m;

    return cell;
}



@end
