//
//  TableViewController.m
//  Net2
//
//  Created by niit on 16/3/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController.h"

#import "Video.h"
#import <UIImageView+WebCache.h>

@interface TableViewController ()

@property (nonatomic,strong) NSMutableArray *list;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self requestVideosList];
    
    // 下拉刷新控件
    UIRefreshControl *c = [[UIRefreshControl alloc] init];
    c.attributedTitle = [[NSAttributedString alloc] initWithString:@"获取列表中"];
    [c addTarget:self action:@selector(requestVideosList) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = c;
}

- (void)requestVideosList
{
    // 请求地址的字符串
    NSString *str = @"http://192.168.13.28:8080/MJServer/video?method=get&type=JSON";
    // 请求网址
    NSURL *url = [NSURL URLWithString:str];
    // 请求
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    // 发送异步请求
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError == nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSArray *arr = dict[@"videos"];
            
            self.list = [NSMutableArray array];
            
            for(NSDictionary *d in arr)
            {
                Video *v = [Video videoWithDict:d];
                [self.list addObject:v];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            // 连接失败
        }
        // 关闭下拉
        [self.refreshControl endRefreshing];
    }];
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
    
    // Configure the cell...
    Video *v = self.list[indexPath.row];
    
    cell.textLabel.text = v.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"时长:%i",v.length];
    NSString *imageUrlStr = [NSString stringWithFormat:@"http://192.168.13.28:8080/MJServer/%@",v.image];
//    placeholderImage 图片大小要和网络的图片大小一致
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"minion_01"]];
    
    return cell;
}



@end
