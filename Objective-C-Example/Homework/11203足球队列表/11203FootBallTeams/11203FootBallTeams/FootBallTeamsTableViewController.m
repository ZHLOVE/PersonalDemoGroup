//
//  FootBallTeamsTableViewController.m
//  11203FootBallTeams
//
//  Created by 马千里 on 16/3/6.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "FootBallTeamsTableViewController.h"

@interface FootBallTeamsTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *FBNamesArray;
@property(nonatomic,strong) NSArray *FBImageNamesArray;

@end

@implementation FootBallTeamsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.FBNamesArray = [[NSArray alloc] initWithObjects:@"A1-南非",@"A2-墨西哥",
                         @"B1-阿根廷",@"B2-尼日利亚",@"C1-英格兰",@"C2-美国",
                         @"D1-德国",@"D2-澳大利亚",@"E1-荷兰",@"E2-丹麦",
                         @"G1-巴西",@"G2-朝鲜",@"H1-西班牙",@"H2-瑞士",nil];
    self.FBImageNamesArray = [[NSArray alloc] initWithObjects:@"SouthAfrica.png",@"Mexico.png",
                              @"Argentina.png",@"Nigeria.png",@"England.png",@"USA.png",@"Germany.png",@"Australia.png",@"Holland.png",@"Denmark.png",@"Brazil.png",
                              @"NorthKorea.png",@"Spain.png",@"Switzerland.png",nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.FBImageNamesArray.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FBCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.FBNamesArray[indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:self.FBImageNamesArray[indexPath.row]]];
    
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
