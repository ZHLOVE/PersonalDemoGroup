//
//  ViewController.m
//  HPPleDemo
//
//  Created by niit on 16/3/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "TFHpple.h"

@interface ViewController ()<UITableViewDataSource>

@property (nonnull,strong) NSMutableArray *list;

@end

@implementation ViewController


// Build Settings中
//Header Searc Path 添加 /usr/include/libxml2

// link添加
// 添加libxml2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1. 获取数据
    NSURL *url = [NSURL URLWithString:@"http://www.haodou.com/recipe/all/201/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // 2.
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
    
    // 3. 解析网页内容，找出所需要的信息
    TFHpple *hpple = [TFHpple hppleWithHTMLData:data];
    
    // 通过一个xpath来查找所需信息
    NSString *xpath = @"//p [@class='bigimg']/a/img";
    
    NSArray *arr = [hpple searchWithXPathQuery:xpath];
    
    self.list = [NSMutableArray array];
    for(TFHppleElement *tmp in arr)
    {
        NSDictionary *dict = tmp.attributes;
        NSLog(@"菜名:%@",dict[@"alt"]);
        NSLog(@"图片:%@",dict[@"original"]);
        
        [self.list addObject:@{@"name":dict[@"alt"],@"pic":dict[@"original"]}];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *d = self.list[indexPath.row];
    cell.textLabel.text = d[@"name"];;
    
    NSData *imgData= [NSData dataWithContentsOfURL:[NSURL URLWithString:d[@"pic"]]];
    cell.imageView.image =[UIImage imageWithData:imgData];
    
    return cell;
}
@end
