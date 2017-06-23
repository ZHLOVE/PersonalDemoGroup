//
//  MasterViewController.m
//  UISplitViewControllerDemo
//
//  Created by niit on 16/3/10.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@property (nonatomic,strong) NSArray *list;

@property (nonatomic,assign) int stuAge;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Master";
    self.list = @[@"张三",@"李四",@"王五"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    
//    self.stuAge = 13;// 赋值的时候调用的是setter方法 ==> [self setStuAge:13];
//    NSLog(@"年龄 = %i",self.stuAge);// 取值得时候调用的是getter方法 ==> NSLog(@"年龄 = %i",[self stuAge]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.list[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中的是谁:%@",self.list[indexPath.row]);
    
    NSString *stuName = self.list[indexPath.row];
    
    // 传输数据到DetailViewController中
    self.detailVC.stuName = stuName;// 实际上运行的是: [self.detailVC setStuName:stuName];
}

@end
