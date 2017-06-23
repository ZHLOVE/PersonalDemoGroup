//
//  ViewController.m
//  Sections
//
//  Created by niit on 16/3/3.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

static NSString *identifier = @"Cell";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>

@property (nonatomic,strong) NSDictionary *namesDict;
@property (nonatomic,strong) NSArray *keys;// 存放 A B ... Z

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//搜索控制器
@property (nonatomic,strong) UISearchDisplayController *searchController;
//保存搜索的结果的数组
@property (nonatomic,strong) NSMutableArray *filterNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 从plist读取数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    self.namesDict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.keys = [[self.namesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // 为表格注册单元格模板,在找不到可复用单元格时,会自动使用注册的模板创建新单元格,不过单元格的样式只能是默认样式
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    // 注册单元格模板有以下方法:
    // 1. 使用类
    // 2. 使用xib
    // 3. 使用Storyboard上的原型单元格
    
    // 添加搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, 320, 44)];
    self.tableView.tableHeaderView = searchBar;
    
    // 创建搜索控制器
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.delegate = self;
    // 搜索控制器(自带一张结果表格)
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsTableView.tag = 1;
    [self.searchController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
}

#pragma mark - tableView DataSource and Delegate Method
// 当前有2张表格(名字列表，搜索结果表),需要判断传入的表格的tag，为其提供不同的数据

// 有几段?
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag == 1)
    {
        return 1;
    }
    else
    {
        return self.keys.count;
    }
}

// 第几段有几行?
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1)
    {
        return self.filterNames.count;
    }
    else
    {
        NSString *key = self.keys[section];// A B C ... Z
        NSArray *arr = self.namesDict[key];// @[@"Aaliyah",@"aplasdf",....]
        return arr.count;
    }
}

// 第几段第几行单元格内容?
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(tableView.tag == 1)
    {
        cell.textLabel.text = self.filterNames[indexPath.row];
        return cell;
    }
    else
    {
        NSString *key = self.keys[indexPath.section];
        NSArray *arr = self.namesDict[key];
        cell.textLabel.text = arr[indexPath.row];
        return cell;
    }
}

// 段头文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 1)
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
    if(tableView.tag == 1)
    {
        return nil;
    }
    else
    {
        return self.keys;
    }
}

#pragma mark - 搜索控制器的事件处理

// 搜索栏内容改变，触发该方法，返回是否要刷新结果表格
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString
{
    NSLog(@"搜索内容: %@",searchString);
    
    if(searchString.length>0)
    {
        self.filterNames = [NSMutableArray array];
        
        // 定义了一个谓词对象
        // 1. 简单方式,不忽略大小写
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self contains %@",searchString];
        // 2. 用block创建谓词
//        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSString *name, NSDictionary<NSString *,id> * _Nullable bindings) {
//            NSRange range = [name rangeOfString:searchString options:NSCaseInsensitiveSearch];
//            return range.location != NSNotFound;
//        }];
        
        // 遍历所有字母
        for(NSString *key in self.keys)
        {
            // 得到该字母开头的人名数组
            NSArray *names = self.namesDict[key];
            // 使用谓词对象过滤数组
            NSArray *tmp = [names filteredArrayUsingPredicate:pre];
            
            [self.filterNames addObjectsFromArray:tmp];
        }
    }
    
    return YES;
}

@end
