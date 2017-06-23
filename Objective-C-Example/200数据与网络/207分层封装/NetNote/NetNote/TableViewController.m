//
//  TableViewController.m
//  NetNote
//
//  Created by niit on 16/4/5.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController.h"

#import "NoteModel.h"
#import "NetManager.h"

#import "SVProgressHUD.h"

@interface TableViewController ()

@property (nonatomic,strong) NSMutableArray *mList;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
//    rc.attributedTitle = [NSAttributedString alloc] initWithString:@"正在刷新" attributes:<#(nullable NSDictionary<NSString *,id> *)#>
    [rc addTarget:self  action:@selector(updateInfo) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = rc;
}

- (void)updateInfo
{
    // 开始刷新
    [self.refreshControl beginRefreshing];
    
    // 请求数据
    [NetManager requestNoteListSuccessBlock:^(NSMutableArray *mList) {
            self.mList = mList;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
    } failBlock:^(NSError *error) {
        NSLog(@"查询失败");
        [self.refreshControl endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)editBtnPressed:(id)sender {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NoteModel *note = self.mList[indexPath.row];
    cell.textLabel.text = note.Content;
    cell.detailTextLabel.text = note.CDate;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle ==  UITableViewCellEditingStyleDelete)
    {
        NoteModel *note = self.mList[indexPath.row];
        // 显示HUD
        [SVProgressHUD showWithStatus:@"正在删除"];
        [NetManager removeNoteById:note.ID SuccessBlock:^{
            [self.mList removeObject:note];
            [self.tableView reloadData];
            // 隐藏HUD
            [SVProgressHUD dismiss];
            
        } failBlock:^(NSError *error) {
            NSLog(@"删除失败");
            // 隐藏HUD
            [SVProgressHUD dismiss];
            
            
        }];
        // 转动
    }
}

@end
