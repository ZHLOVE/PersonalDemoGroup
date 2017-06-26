//
//  TableTableViewController.m
//  NotePad
//
//  Created by 马千里 on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableTableViewController.h"

#import "AddViewController.h"
#import "NoteViewController.h"
#import "NetManager.h"
#import "NoteData.h"

#import <UIImageView+WebCache.h>
@interface TableTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *noteArray;

@end

@implementation TableTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //下拉刷新控件
    UIRefreshControl *freshControl = [[UIRefreshControl alloc]init];
    freshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    [freshControl addTarget:self action:@selector(requestNoteList) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = freshControl;
    [self requestNoteList];
}

- (void)viewWillAppear:(BOOL)animated{
    [self requestNoteList];
    [self.tableView reloadData];
}

#pragma mark 下拉刷新
- (void)requestNoteList{
    NSString *urlStr = @"http://www.51work6.com/service/mynotes/WebService.php?email=301063915@qq.com&type=JSON&action=query";
    [NetManager queryFromNet:urlStr successBlock:^(NSArray *array) {
        self.noteArray = [array copy];
        if (self.noteArray) {
              //关闭下拉
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }else{
            [self.refreshControl endRefreshing];
        }
    } failBlock:^(NSError *error) {
//        NSLog(@"%@",[error localizedDescription]);  //这里打印错误信息
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noteArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NoteData *data  = self.noteArray[indexPath.row];
//    网络请求下来的不一定是NSString，虽然指针是NSString cell.textLabel.text = data.ID;
    cell.textLabel.text = [NSString stringWithFormat:@"编号%@",data.ID];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"日期%@",data.CDate];
    return cell;
}


#pragma mark 添加Note
- (IBAction)addNote:(UIBarButtonItem *)sender {
    AddViewController *addVC = [[AddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark 左滑删除
//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NoteData *note = self.noteArray[indexPath.row];
        NSString *idStr = note.ID;
        NSMutableArray *mStr = [self.noteArray mutableCopy];
        [mStr removeObjectAtIndex:indexPath.row];
        self.noteArray = [mStr copy];
        //先删数组，再删界面上单元格
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [NetManager deleteFromNet:idStr];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteViewController *noteVC =  [[NoteViewController alloc]init];
    NoteData *note = self.noteArray[indexPath.row];
    //可以修改属性，但是界面上的东西不能直接修改，因为界面还没显示出来
//    noteVC.date.text = note.CDate;
//    noteVC.textView.text = note.Content;
    noteVC.noteData = note;
    [self.navigationController pushViewController:noteVC animated:YES];
}
@end
