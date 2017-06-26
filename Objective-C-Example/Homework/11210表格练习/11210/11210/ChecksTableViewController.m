//
//  CheckTableViewController.m
//  11210
//
//  Created by student on 16/3/4.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ChecksTableViewController.h"

// 练习:
// 实现多选:
// 1. 可以选中多个
// 2. 某行再次点击取消选中
// *3. 使用已学的NSUserDefault保存选中信息。再次打开本页面时恢复。

@interface ChecksTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *list;


//保存所有单元格tag
@property (nonatomic,strong) NSMutableArray *allCell;

// 定义一个数组存放选中了哪些行
@property (nonatomic,strong) NSMutableArray *checkedList;

@end

@implementation ChecksTableViewController

//懒加载,重写get方法
- (NSMutableArray *)checkedList{
    if (_checkedList == nil) {
        _checkedList = [NSMutableArray array];
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        NSArray *l = [d objectForKey:@"CheckedList"];
        [_checkedList addObjectsFromArray:l];
    }
    return _checkedList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.allCell = [[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.list = @[@"Who Hash",
                  @"Bubba Gump Shrimp Étouffée", @"Who Pudding", @"Scooby Snacks",
                  @"Everlasting Gobstopper", @"Green Eggs and Ham", @"Soylent Green",
                  @"Hard Tack", @"Lembas Bread", @"Roast Beast", @"Blancmange",@"Who Hash",
                  @"Bubba Gump Shrimp Étouffée", @"Who Pudding", @"Scooby Snacks",
                  @"Everlasting Gobstopper", @"Green Eggs and Ham", @"Soylent Green",
                  @"Hard Tack", @"Lembas Bread", @"Roast Beast", @"Blancmange"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.list[indexPath.row];
    
//    if (self.lastIndexPath == indexPath) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    

    //只获取当前的indexPath
//    for (NSIndexPath *tmpIndexPath in self.allCell) {
//   
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:tmpIndexPath];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//
//    }
    if ([self.checkedList containsObject:@(indexPath.row)])
        {
            cell.accessoryType  = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    

//    NSLog(@"%ld",self.allCell.count);

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%s",__func__);
    //单选
//    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
//    lastCell.accessoryType = UITableViewCellAccessoryNone;
    //多选-自己写的
//    for (NSIndexPath *tmpIndexPath in self.allCell) {
//        if (tmpIndexPath == indexPath) {
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:tmpIndexPath];
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            [self.allCell removeObject:tmpIndexPath];
//            return;
//        }
//    }
    //判断之前有无选过
    if ([self.checkedList containsObject:@(indexPath.row)]) {
        //之前选中过，移除
        [self.checkedList removeObject:@(indexPath.row)];
        //视图上改变
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        //添加
        [self.checkedList addObject:@(indexPath.row)];
        //视图改变
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
      [self saveCheched];
    // 得到当前选中的单元格,设置对勾
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
   
    //添加选中单元格的indexPath
//    [self.allCell addObject:indexPath];
//    NSLog(@"tag:%@",row);
       // 保存当前选中项
//    self.lastIndexPath = indexPath;
    
    // 取消表格本身的选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)saveCheched
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:self.checkedList forKey:@"CheckedList"];
    [d synchronize];
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
