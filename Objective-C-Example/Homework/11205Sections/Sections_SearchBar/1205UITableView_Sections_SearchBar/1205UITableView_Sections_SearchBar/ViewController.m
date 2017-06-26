//
//  ViewController.m
//  1205UITableView_Sections_SearchBar
//
//  Created by student on 16/3/3.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"


static NSString *identifier = @"Cell";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>

@property (nonatomic,strong) NSDictionary *namesDict;
@property (nonatomic,strong) NSArray *keys;// 存放 A B ... Z

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//搜索控制器
@property (nonatomic,strong)UISearchController *searchController;
//保存搜索结果的数组
@property (nonatomic,strong)NSMutableArray *fileNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 从plist读取数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    self.namesDict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.keys = [[self.namesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // 为表格注册单元格模板,在找不到可复用单元格时,会自动使用注册的模板创建新单元格,不过单元格的样式只能是默认样式
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.tag = 1;
    //创建搜索控制器
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;//自身处理搜索结果
    self.searchController.dimsBackgroundDuringPresentation = YES;//变灰
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - tableView DataSource and Delegate Method
// 有几段?
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    if (self.searchController.active) {
        return 1;
    }else{
        return self.keys.count;
    }
}

// 第几段有几行?
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (self.searchController.active) {
        return self.fileNames.count;
    }else{
        NSString *key = self.keys[section];
        NSArray *arr = self.namesDict[key];
        return arr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    if (self.searchController.active) {
        cell.textLabel.text = self.fileNames[indexPath.row];
        return cell;
    }else{
        NSString *key = self.keys[indexPath.section];
        NSArray *arr = self.namesDict[key];
        cell.textLabel.text = arr[indexPath.row];
        return cell;
    }
}

// 段头文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   
    if(self.searchController.active)
    {
        return nil;
    }
    else
    {
        NSString *key = self.keys[section];
        return key;
    }
}

// 右侧导航
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.searchController.active)
    {
        return nil;
    }
    else
    {
        return self.keys;
    }
}

#pragma mark - 搜索控制器的事件处理
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"%s",__func__);
    NSString *searchString = searchController.searchBar.text;
    if (searchString.length>0) {
        self.fileNames = [NSMutableArray array];
        //定义谓词
        //1不忽略大小写，简单方法
//        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self contains %@",searchString];
        //2用block创建谓词
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSString *name, NSDictionary<NSString *,id> * _Nullable bindings) {
            NSRange range = [name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            return range.location != NSNotFound;}];
        for (NSString *key in self.keys) {
            //得到该字母开头的人名数组
            NSArray *names = self.namesDict[key];
            //使用谓词对象过滤数组
            NSArray *tmp = [names filteredArrayUsingPredicate:pre];
            [self.fileNames addObjectsFromArray:tmp];
        }
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



































