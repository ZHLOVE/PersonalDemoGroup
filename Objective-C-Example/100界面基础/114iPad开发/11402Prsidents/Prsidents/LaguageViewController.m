//
//  LaguageViewController.m
//  Prsidents
//
//  Created by niit on 16/3/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "LaguageViewController.h"

#import "DetailViewController.h"

@interface LaguageViewController ()

@property (nonatomic,strong) NSArray *list;
@property (nonatomic,strong) NSArray *codeList;
@end

@implementation LaguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@"English",@"French",@"German",@"Spanish"];
    self.codeList = @[@"en",@"fr",@"de",@"es"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.list[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailVC.language = self.codeList[indexPath.row];
}

@end
