//
//  PlayerTableViewController.m
//  MusicPlayer
//
//  Created by student on 16/4/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "PlayerTableViewController.h"

#import "MusicPlayerViewController.h"
#import "TableViewCell.h"
#import "Music.h"
@interface PlayerTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSArray *musicArray;

@end

@implementation PlayerTableViewController

- (NSArray *)musicArray{
    if (_musicArray == nil) {
        _musicArray = [NSArray array];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Musics" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            Music *music = [Music dataWithDict:dict];
            [mArr addObject:music];
        }
        _musicArray = [mArr copy];
        return _musicArray;
    }
    return _musicArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 150;
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Music *music = self.musicArray[indexPath.row];
    cell.music = music;
    return cell;
}

//选中歌曲
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicPlayerViewController *musicPlayerVC = [[MusicPlayerViewController alloc]init];
    musicPlayerVC.music = self.musicArray[indexPath.row];
    musicPlayerVC.musicArray = [self.musicArray copy];
    musicPlayerVC.num = indexPath.row;
    [self presentViewController:musicPlayerVC animated:YES completion:nil];

}


@end
