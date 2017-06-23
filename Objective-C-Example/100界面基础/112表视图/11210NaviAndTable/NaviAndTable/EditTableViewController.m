//
//  EditTableViewController.m
//  NaviAndTable
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "EditTableViewController.h"

#import "BIDPresident.h"

#import "PresidentDetailTableViewController.h"
@interface EditTableViewController ()<PresidentDetailTableViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *presidents;

// 用于记录当前用户选中项
@property (nonatomic,strong) NSIndexPath *curSel;

@end

@implementation EditTableViewController

- (NSMutableArray *)presidents
{
    if(_presidents == nil)
    {
        _presidents = [NSMutableArray array];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Presidents" ofType:@"plist"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *arr = [unArch decodeObjectForKey:@"Presidents"];
//        [_list addObject:arr]; // 错误,这是将arr数组作为一个对象，加入到list中
        [_presidents addObjectsFromArray:arr];// 将arr数组中的每个元素，加入到list中
    }
    return _presidents;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 当沿着连线跳转的时候触发的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s",__func__);
    
    // 得到下一个页面
    PresidentDetailTableViewController *nextVC = segue.destinationViewController;
    // 告诉下一个页面，我是你的代理人
    nextVC.delegate = self;
    // 将总统对象传递过去
    nextVC.pre = self.presidents[self.curSel.row];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presidents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    BIDPresident *pre = self.presidents[indexPath.row];
    
    cell.textLabel.text = pre.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",pre.fromYear,pre.toYear];
    
    return cell;
}


// 将要选中,该方法在prepareForSegue之前运行
// 注意!在此方法里记录你选中的行
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    self.curSel = indexPath;// 记录当前选中的
    return indexPath;
}

// 已经选中
// 注意:此方法是在prepareForsegue之后运行的,如果要通过prepareForsegue传递数据，不要使用该方法继续选中行。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
}

#pragma mark PresidentDetailVC Delegate Method
// 下一个页面的代理方法,下一个页面关闭时调用执行。
- (void)refresh
{
    [self.tableView reloadData];
}

// reloadData 方法
// 刷新表格显示
// 会重新运行一遍
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; 
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 



@end
