//
//  TableListViewController.m
//  11402PresidentList
//
//  Created by student on 16/3/10.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableListViewController.h"


#import "TableViewCell.h"
#import "President.h"
@interface TableListViewController ()<UITableViewDataSource,UITableViewDelegate>



@end

@implementation TableListViewController

- (NSArray *)presidentsArray{
    if (_presidentsArray == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PresidentList" ofType:@"plist"];
        NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *array = d[@"presidents"];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            President *president = [President PresidentWithDict:dict];
            [mArray addObject:president];
        }
        _presidentsArray = [mArray copy];
    }
    return _presidentsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.presidentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.president = self.presidentsArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

     President *president = self.presidentsArray[indexPath.row];
     self.preDetail.webUrl = president.url;

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
