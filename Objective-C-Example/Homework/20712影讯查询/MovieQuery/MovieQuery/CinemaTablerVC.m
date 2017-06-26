//
//  CinemaTablerVC.m
//  MovieQuery
//
//  Created by student on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CinemaTablerVC.h"

#import "CinemaTableViewCell.h"
#import "Cinema.h"
#import "NetManager.h"
#import "MovieTableViewController.h"
#import <UIImageView+WebCache.h>
@interface CinemaTablerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *cinemaArray;

@end

@implementation CinemaTablerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"CinemaTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    //下拉刷新控件
    UIRefreshControl *freshControl = [[UIRefreshControl alloc]init];
    freshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    [freshControl addTarget:self action:@selector(requestNoteList) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = freshControl;
    self.tableView.rowHeight = 120;
    if (!self.cinemaArray) {
        [self requestNoteList];
    }
}

- (void)viewWillAppear:(BOOL)animated{
//    [self requestNoteList];
    [self.tableView reloadData];
}

#pragma mark 下拉刷新
- (void)requestNoteList{
    NSString *urlStr = @"http://v.juhe.cn/movie/cinemas.local?key=2273eaf35f8d2efae9a7a634f6f45a8d&dtype=json&lat=31.49670&lon=120.31895&radius=5000";
    [NetManager queryCinemaFromNet:urlStr successBlock:^(NSArray *array) {
        self.cinemaArray = [array copy];
        if (self.cinemaArray) {
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    } failBlock:^(NSError *error) {
         //NSLog(@"%@",[error localizedDescription]);  //这里打印错误信息
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cinemaArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CinemaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.cinema = self.cinemaArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieTableViewController *movieVC =  [[MovieTableViewController alloc]init];
    Cinema *cinema = self.cinemaArray[indexPath.row];
    //可以修改属性，但是界面上的东西不能直接修改，因为界面还没显示出来
    movieVC.movieId = cinema.uid;
    [self.navigationController pushViewController:movieVC animated:YES];
}



@end
