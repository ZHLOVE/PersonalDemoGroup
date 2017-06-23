//
//  TableViewController.m
//  Contacts
//
//  Created by niit on 16/4/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController.h"

#import "ABContactsHelper.h"

@interface TableViewController ()

@property (nonatomic,strong) NSArray *list;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.list = [ABContactsHelper contacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    ABContact *friend = self.list[indexPath.row];
    
    cell.textLabel.text = friend.contactName;
    cell.detailTextLabel.text = friend.phoneArray[0];
    cell.imageView.image = friend.image;
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.layer.masksToBounds = YES;
    
    return cell;
}



@end
