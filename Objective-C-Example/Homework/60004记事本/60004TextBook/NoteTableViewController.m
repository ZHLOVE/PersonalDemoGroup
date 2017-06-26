//
//  NoteTableViewController.m
//  60004TextBook
//
//  Created by student on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NoteTableViewController.h"


#import "Data.h"
#import "AddViewController.h"
#import "DetailController.h"
#import "TableViewCell.h"
@interface NoteTableViewController ()<UITableViewDataSource,UITableViewDelegate,AddViewControllerDelegate>

@property(nonatomic,strong)NSMutableArray *noteArray;

//@property(nonatomic,strong) NSMutableArray *NoteTitleList;
//@property(nonatomic,strong) NSMutableArray *noteTime;
@property (nonatomic,strong) NSIndexPath *curSel;
@end

@implementation NoteTableViewController

- (NSArray *)noteArray{
  
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSArray *array = [NSMutableArray array];
        array = [[userDefault objectForKey:@"NoteBook"] copy];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            Data *noteDate = [Data dataWithDict:dict];
            [mArray addObject:noteDate];
        }
        _noteArray = [mArray mutableCopy];
        return _noteArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
}



- (void)viewWillAppear:(BOOL)animated{
    [self noteArray];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noteArray.count;
}

//生成表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.data = self.noteArray[indexPath.row];
    return cell;
}

//添加按钮
- (IBAction)addBtnPressed:(UIButton *)sender {
    AddViewController *addVC = [[AddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 删除
   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //从视图中删除,不用再去self.noteArray中删一次
        [Data deleteNote:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailController *detailVC =  [[DetailController alloc]init];
//  为何这行代码不能传值   detailVC.data =  self.noteArray[indexPath.row];
    detailVC.row = indexPath.row;
    [self.navigationController pushViewController:detailVC animated:YES];
}





@end
