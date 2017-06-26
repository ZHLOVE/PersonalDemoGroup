//
//  EdTableViewController.m
//  11210
//
//  Created by student on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "EdTableViewController.h"
#import "BIDPresident.h"
#import "PresidentDetailTableViewController.h"
@interface EdTableViewController ()<PresidentDetailTableViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) NSIndexPath *curSel;

@end

@implementation EdTableViewController

- (NSMutableArray *)list{
    if (_list == nil) {
        _list = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Presidents" ofType:@"plist"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        //归档
        NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *arr = [unArch decodeObjectForKey:@"Presidents"];
        //将arr元素添加到list
        [_list addObjectsFromArray:arr];
    }
    return _list;
}

// 当沿着连线跳转的时候触发的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //    segue.identifier
    //    segue.destinationViewController
    PresidentDetailTableViewController *nextVC = segue.destinationViewController;
    nextVC.delegate = self;
    nextVC.pre = self.list[self.curSel.row];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    BIDPresident *pre = self.list[indexPath.row];
    cell.textLabel.text = pre.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",pre.fromYear,pre.toYear];
    return cell;
}

// 将要选中
// 注意！ 在此方法里记录你选中的行
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.curSel = indexPath;//记录当前选中的行
    return indexPath;
}

// 已经选中
// 此方法在prepareForsegue之后运行的
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s",__func__);
}


- (void)refresh
{
    [self.tableView reloadData];
}


@end
