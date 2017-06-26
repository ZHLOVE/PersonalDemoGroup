//
//  ViewController.m
//  11202LOLTable
//
//  Created by student on 16/3/3.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"
#import "HerosModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self lolTableView];
}

- (void)lolTableView{
    UITableView *lolTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-10) style:UITableViewStylePlain];
    lolTableView.dataSource = self;
    lolTableView.delegate = self;
    [self.view addSubview:lolTableView];
 
    
}

//1段
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [HerosModel heroName].count;
}

//每个单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    // UITableViewCell的三个默认属性:
    // 1. 文本标签 textLabel
    NSArray *nameArray = [HerosModel heroName];
    cell.textLabel.text = nameArray[indexPath.row];
    // 2. 图片视图 imageView
    NSArray *imgArray = [HerosModel imgName];
    NSString *imgName = imgArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imgName];
       // 3. 副文本标签 detailLabel
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"测试%lu",indexPath.row];
    return cell;
}

#pragma mark - 为表格提供事件处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    // 使用UIAlertController 替代 UIAlertView UIActionSheet
    
    // 1. 创建UIAlertController弹框
    NSArray *infoArray = [HerosModel heroInfo];
    NSArray *nameArray = [HerosModel heroName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nameArray[indexPath.row] message:infoArray[row] preferredStyle:UIAlertControllerStyleAlert];
    // 样式:
    //    UIAlertControllerStyleActionSheet = 0, 弹出操作表
    //    UIAlertControllerStyleAlert            弹出消息框
    
    // 2. 添加确定按钮
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    
    // 3. 弹出
    [self presentViewController:alert animated:YES completion:nil];
    
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
