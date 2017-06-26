//
//  ViewController.m
//  11205
//
//  Created by student on 16/3/3.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSDictionary *namesDict;
@property (nonatomic,strong) NSArray *keys;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // 从plist读取数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    self.namesDict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.keys = [[self.namesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
   
}

#pragma mark - tableView DataSource and Delegate Method
// 有几段?
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keys.count;
}

//第几段有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //第几个key，key中所有name
    NSString *key = self.keys[section];
    NSArray *name = self.namesDict[key];
    return name.count;
}

// 第几段第几行单元格内容?
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    //第几个key，key中所有name
    NSString *key = self.keys[indexPath.section];
    NSArray *name = self.namesDict[key];
    cell.textLabel.text = name[indexPath.row];
    return cell;
 
}
//段头文字
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key = self.keys[section];
    return key;
}

// 段尾文字
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
//   NSString *key = self.keys[section];
    return nil;
}

//右侧导航
- ( NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.keys;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end























