//
//  TableViewController.m
//  SimpleTableViewStoryBoard
//
//  Created by student on 16/3/4.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property (nonatomic,strong) NSArray *list;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@"起床",@"刷牙",@"吃早饭",@"重要:到学校",@"上课",@"重要:吃午饭",@"起床",@"刷牙",@"重要:打电话回家",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭"];
    
    // 1 模板类
    // 2 storyborad里的原型单元格
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //查找带有“重要”的字符串位置
    NSString *toDoStr = self.list[indexPath.row];
    NSRange range = [toDoStr rangeOfString:@"重要:"];
    
    UITableViewCell *cell;
    if(range.location != NSNotFound)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ICell" forIndexPath:indexPath];
    
    
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    }
    
    cell.textLabel.text = self.list[indexPath.row];

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
