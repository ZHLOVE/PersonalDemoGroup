//
//  TableViewController.m
//  Net2
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewController.h"

#import "Video.h"
#import <UIImageView+WebCache.h>
@interface TableViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *list;

@end
@implementation TableViewController



- (void)viewDidLoad{
    [super viewDidLoad];
    [self requestVideosList];
    //下拉刷新控件
    UIRefreshControl *freshControl = [[UIRefreshControl alloc]init];
    freshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"获取列表中"];
    [freshControl addTarget:self action:@selector(requestVideosList) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = freshControl;
}

- (void)requestVideosList
{
    NSString *str = @"http://192.168.13.28:8080/MJServer/video?method=get&type=JSON";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    //发送异步请求
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSArray *arr = dict[@"videos"];
            self.list = [NSMutableArray array];
            for (NSDictionary *d in  arr) {
                Video *video = [Video videoWithDict:d];
                [self.list addObject:video];
            }
        }else
        {
            //连接失败
        }
      
        //关闭下拉
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Video *video = self.list[indexPath.row];
    cell.textLabel.text = video.name;
    NSLog(@"%@",video.name);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"时长:%i",video.length];
    NSString *imageUrlStr = [NSString stringWithFormat:@"http://192.168.13.28:8080/MJServer/%@",video.image];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"minion_01"]];
     return cell;
}










@end
