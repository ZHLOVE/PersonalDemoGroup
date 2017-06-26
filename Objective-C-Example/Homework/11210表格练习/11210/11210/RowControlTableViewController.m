//
//  RowControlTableViewController.m
//  11210
//
//  Created by 马千里 on 16/3/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "RowControlTableViewController.h"

@interface RowControlTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *list;

@end

@implementation RowControlTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@"C3PO", @"Tik-Tok", @"Robby", @"Rosie", @"Uniblab",
                  @"Bender", @"Marvin", @"Lt. Commander Data",
                  @"Evil Brother Lore", @"Optimus Prime", @"Tobor", @"HAL",
                  @"Orgasmatron",@"C3PO", @"Tik-Tok", @"Robby", @"Rosie", @"Uniblab",
                  @"Bender", @"Marvin", @"Lt. Commander Data",
                  @"Evil Brother Lore", @"Optimus Prime", @"Tobor", @"HAL",
                  @"Orgasmatron"];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = self.list[indexPath.row];
    
    if (cell.accessoryView == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 50, 27);
        [btn setBackgroundImage:[UIImage imageNamed:@"button_up"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"button_down"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
    }
    UIButton *btn = cell.accessoryView;
    btn.tag = indexPath.row;
    return cell;
}


- (IBAction)btnPressed:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
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
