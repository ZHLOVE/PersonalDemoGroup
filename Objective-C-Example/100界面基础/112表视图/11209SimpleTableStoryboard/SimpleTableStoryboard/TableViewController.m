//
//  TableViewController.m
//  SimpleTableStoryboard
//
//  Created by niit on 16/3/4.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@property (nonatomic,strong) NSArray *list;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@"起床",@"刷牙",@"吃早饭",@"重要:到学校",@"上课",@"重要:吃午饭",@"起床",@"刷牙",@"重要:打电话回家",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭",@"起床",@"刷牙",@"吃早饭",@"到学校",@"上课",@"吃午饭"];
    
    // 1 使用模板类
    // 2 使用storyborad里的原型单元格
    
    // 错误信息:
//     reason: 'unable to dequeue a cell with identifier Cell - must register a nib or a class for the identifier or connect a prototype cell in a storyboard'
    // 没有找到对应Identifier的原型单元格
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果数据中有"重要:",使用不同的原型模板
    NSString *toDoStr = self.list[indexPath.row];
    NSRange range = [toDoStr rangeOfString:@"重要:"];
    
    UITableViewCell *cell;
    if(range.location != NSNotFound)
    {   
        cell = [tableView dequeueReusableCellWithIdentifier:@"ICell" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.list[indexPath.row];
    
    return cell;
}

@end
