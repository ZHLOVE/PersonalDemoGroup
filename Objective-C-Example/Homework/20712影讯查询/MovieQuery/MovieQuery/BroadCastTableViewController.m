//
//  BroadCastTableViewController.m
//  MovieQuery
//
//  Created by student on 16/4/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "BroadCastTableViewController.h"

#import "BroadCastTableViewCell.h"
@interface BroadCastTableViewController ()

//@property (nonatomic,strong) NSArray *array;

@end

@implementation BroadCastTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"%@",self.hellArray);
//    NSLog(@"***");
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"BroadCastTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"hellCell"];
    self.tableView.rowHeight = 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%@",self.hellArray);
    return self.hellArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BroadCastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hellCell" forIndexPath:indexPath];
    cell.movieHell = self.hellArray[indexPath.row];
    return cell;
}




@end
