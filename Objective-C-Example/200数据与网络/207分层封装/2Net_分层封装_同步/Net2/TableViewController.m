//
//  TableViewController.m
//  Net2
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController.h"

#import "Video.h"
#import "NetManager.h"
#import <UIImageView+WebCache.h>

@interface TableViewController ()

@property (nonatomic,strong) NSArray *list;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建下拉刷新控件
    UIRefreshControl *c = [[UIRefreshControl alloc] init];
    c.attributedTitle = [[NSAttributedString alloc] initWithString:@"获取列表中"];
    [c addTarget:self action:@selector(requestVideosList) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = c;
}

- (void)requestVideosList
{
    self.list = [NetManager requestMovieList];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Video *v = self.list[indexPath.row];

    // 电影名字
    cell.textLabel.text = v.name;
    // 电影信息
    cell.detailTextLabel.text = [NSString stringWithFormat:@"时长:%i",v.length];
    // 电影图片
    NSString *imageUrlStr = [NSString stringWithFormat:@"http://192.168.13.28:8080/MJServer/%@",v.image];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"minion_01"]];
    
    return cell;
}



@end
