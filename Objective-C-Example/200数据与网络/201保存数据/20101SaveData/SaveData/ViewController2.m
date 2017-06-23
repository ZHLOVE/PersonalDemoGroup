//
//  ViewController2.m
//  SaveData
//
//  Created by niit on 16/3/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()<UITableViewDataSource,UITableViewDelegate>

// 学生数组
@property (nonatomic,strong) NSMutableArray *stuList;

@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController2

#pragma mark - plist方式

/** 重写getter方法 懒加载 */
- (NSMutableArray *)stuList
{
    if(_stuList == nil)
    {
        // 判断存档文件是否存在，如果之前已有存档文件，则从存档中读取出来以前的数据
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:[self plistPath]])
        {
            _stuList = [NSMutableArray arrayWithContentsOfFile:[self plistPath]];
        }
        else
        {
            // 没有存档文件则新建一个空数组
            _stuList = [NSMutableArray array];
        }
    }
    return _stuList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/** plist文件存储位置 */
- (NSString *)plistPath
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"students.plist"];
//    NSLog(@"存储位置:%@",filePath);
    return filePath;
}

/** 保存数据到plist(覆盖以前的数据) */
- (void)savePlist
{
    // 写入到文件
    [self.stuList writeToFile:[self plistPath] atomically:YES];
}

// 增加学生
- (IBAction)add2:(id)sender
{
    // 1. 将信息放入一个字典
    NSMutableDictionary *dict = [@{@"stuId":self.idTextField.text,
                           @"stuName":self.nameTextField.text,
                                  @"stuAge":self.ageTextField.text} mutableCopy];;
    // 2. 将字典放入学生数组
    [self.stuList addObject:dict];
    // 3. 数组保存一下
    [self savePlist];
    
    // 刷新表格
    [self.tableView reloadData];
}

// 删除学生
- (IBAction)remove2:(id)sender
{
    // 1. 遍历学生数组
    for(NSMutableDictionary *dict in self.stuList)
    {
        // 2. 如果学号相同
        if([dict[@"stuId"] isEqualToString:self.idTextField.text])
        {
            // 3. 将该学生这个字典从数组中移除
            [self.stuList removeObject:dict];
            break;
        }
    }
    // 4. 数组保存一下
    [self savePlist];
    
    // 刷新表格
    [self.tableView reloadData];
}

// 修改学生
- (IBAction)modify2:(id)sender
{
    // 1. 遍历学生数组
    for(NSMutableDictionary *dict in self.stuList)
    {
        // 2. 如果学号相同
        if([dict[@"stuId"] isEqualToString:self.idTextField.text])
        {
            // 3. 修改该学生的信息
            dict[@"stuName"] = self.nameTextField.text;
            dict[@"stuAge"] = self.ageTextField.text;
            break;
        }
    }
    // 4. 数组保存一下
    [self savePlist];
    
    // 刷新表格
    [self.tableView reloadData];
}

// 根据学号查询学生
- (IBAction)find2:(id)sender
{
    // 1. 遍历学生数组
    for(NSMutableDictionary *dict in self.stuList)
    {
        // 2. 如果学号相同
        if([dict[@"stuId"] isEqualToString:self.idTextField.text])
        {
            // 3. 将找到的这个学生信息显示到界面上
            self.nameTextField.text = dict[@"stuName"];
            self.ageTextField.text = dict[@"stuAge"];
            break;
        }
    }
}

- (IBAction)findAll:(id)sender
{
    // 1. 遍历学生数组，显示一下
    for(NSMutableDictionary *dict in self.stuList)
    {
        NSLog(@"%@ %@ %@",dict[@"stuId"],dict[@"stuName"],dict[@"stuAge"]);
    }
}


#pragma mark - tableViewDataSource Delegate Method

// 单元格模板方式:
// 1. Storyboard 原型单元格
// 2. RegisterClass
// 3. RegisterNib

// 有多少行?
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stuList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

// 单元格的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UILabel *label1 = [cell.contentView viewWithTag:101];
    UILabel *label2 = [cell.contentView viewWithTag:102];
    UILabel *label3 = [cell.contentView viewWithTag:103];
    
    NSDictionary *dict = self.stuList[indexPath.row];
    label1.text = dict[@"stuId"];
    label2.text = dict[@"stuName"];
    label3.text = dict[@"stuAge"];
    
    return cell;
}

@end
