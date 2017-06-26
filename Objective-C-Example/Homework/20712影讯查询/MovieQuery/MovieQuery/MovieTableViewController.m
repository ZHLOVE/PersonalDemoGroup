//
//  MovieTableViewController.m
//  MovieQuery
//
//  Created by 马千里 on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "MovieTableViewController.h"


#import "NetManager.h"
#import "Movie.h"
#import "MovieTableViewCell.h"
#import "BroadCastTableViewController.h"
#import <UIImageView+WebCache.h>

@interface MovieTableViewController ()

@property (nonatomic,strong) NSArray *movieArray;

@end

@implementation MovieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Moviecell"];
    //下拉刷新控件
    UIRefreshControl *freshControl = [[UIRefreshControl alloc]init];
    freshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    [freshControl addTarget:self action:@selector(requestMovieList) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = freshControl;
    self.tableView.rowHeight = 140;
    if (!self.movieArray) {
        [self requestMovieList];
    }
    
}

#pragma mark 下拉刷新
- (void)requestMovieList{
//    NSString *movieId = @"3493";
   
    [NetManager queryMovieWithCinemaID:self.movieId successBlock:^(NSArray *array) {
        self.movieArray = [array copy];
        if (self.movieArray) {
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    } failBlock:^(NSError *error) {
        //NSLog(@"%@",[error localizedDescription]);  //这里打印错误信息
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    //    [self requestNoteList];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.movieArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Moviecell" forIndexPath:indexPath];
    Movie *movie = self.movieArray[indexPath.row];
    cell.movie = self.movieArray[indexPath.row];
    NSString *urlStr = movie.pic_url;
    NSURL *url = [NSURL URLWithString:urlStr];
    //加载图片
    [cell.movieImgView sd_setImageWithURL:url];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BroadCastTableViewController *hellVC =  [[BroadCastTableViewController alloc]init];
//    Movie *movie = self.movieArray[indexPath.row];
    //可以修改属性，但是界面上的东西不能直接修改，因为界面还没显示出来
    hellVC.hellArray = [self.movieArray copy];
    NSLog(@"接收的送影厅信息%@",hellVC.hellArray);
    [self.navigationController pushViewController:hellVC animated:YES];
}


@end
