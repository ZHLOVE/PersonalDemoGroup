//
//  ViewController.m
//  JSON
//
//  Created by student on 16/3/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "Video.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. 获取数据
    NSString *urlStr = @"http://120.25.226.186:32812/video?type=JSON";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    NSError *error;
    // 2. 解析数据转换为OC对象
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//    NSLog(@"%@",resultDict);
    // 3. 转换成模型放入列表数组
    NSArray *videosArr = resultDict[@"videos"];
    self.list = [NSMutableArray array];
    for (NSDictionary *dict in videosArr)
    {
        Video *v = [Video videoWithDict:dict];
        [self.list addObject:v];
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    Video *v = self.list[indexPath.row];
    cell.textLabel.text = v.name;
    cell.detailTextLabel.text = v.url;
    return cell;
}

@end
