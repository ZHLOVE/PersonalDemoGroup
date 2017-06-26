//
//  TableTableViewController.m
//  CustomCell
//
//  Created by student on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableTableViewController.h"
#import "TableViewCell.h"

@interface TableTableViewController ()

@property (nonatomic,strong) NSArray *list;

@end

@implementation TableTableViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSDictionary *d = self.list[indexPath.row];
    // 方式1: 使用Tag找到原型单元格上的对象
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //    UIImageView *icon = [cell.contentView viewWithTag:101];
    //    UILabel *nameLabel = [cell.contentView viewWithTag:102];
    //    UILabel *colorLabel = [cell.contentView viewWithTag:103];
    //
    //    icon.image = [UIImage imageNamed:d[@"Icon"]];
    //    nameLabel.text = d[@"Name"];
    //    colorLabel.text = d[@"Color"];
    
    // 方式2: 自定义UITableViewCell
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:d[@"Icon"]];
    cell.nameLabel.text = d[@"Name"];
    cell.colorLabel.text = d[@"Color"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
