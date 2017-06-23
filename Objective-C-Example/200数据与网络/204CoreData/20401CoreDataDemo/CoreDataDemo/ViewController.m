//
//  ViewController.m
//  CoreDataDemo
//
//  Created by niit on 16/4/14.
//  Copyright © 2016年 NIIT. All rights reserved.
//



#import "ViewController.h"

#import "Student.h"

#import "AppDelegate.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *stuIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,weak) AppDelegate *appDelegate;

@property (nonatomic,strong) NSMutableArray *students;
@end

// 主要概念:
//NSManagedObjectContext    托管对象上下文     (-> 数据库)
//NSEntityDescription       实体描述          (-> 表结构)
//NSManagedObject           托管对象          (-> 记录)
//NSFetchRequest            请求             (-> 查询语句)
//NSPredicate               条件
//NSSortDescriptor          排序

//xcdatamodelld 数据模型我文件

// 练习:
// 添加一个Teacher实体
// 编号 姓名 部门

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 得到应用程序代理类对象
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
}

// 懒加载 第一次访问的时候把所有学生查询出来
- (NSMutableArray *)students
{
    if(_students == nil)
    {
        // 1. 创建一个查询请求
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        // 2. 设定要查询哪种实体对象 (-> 指定查询哪表 SELECT * FROM Student)
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.appDelegate.managedObjectContext];
        [request setEntity:entity];
    
        // 3. 设置排序 ( -> ORDER BY)
//        NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"stuId" ascending:YES];
//        NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"stuAge" ascending:NO];
//        [request setSortDescriptors:@[sort1,sort2]];// (-> ORDER BY stuId,stuAge DESC )
        
        // 4. 设置查询条件 (WHERE)
//        NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"stuAge > 100"];
//        [request setPredicate:pre1];// (-> WHERE stuAge > 100)
        
//        sizeCount = 10;
//        [request setFetchOffset:sizeCount];//读取数据库的游标偏移量，从游标开始读取数据
        [request setFetchLimit:10];//每次要取多少条数据，10就是每次从数据库读取10条数据
//        [request setFetchBatchSize:500];//从数据库里每次加载500条数据来筛选数据
        
        // 5. 执行查询 executeFetchRequest 返回的是符合查询条件的托管对象数组
        NSArray *results = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
        _students = [results mutableCopy];
    }
    return _students;
}

//http://blog.sina.com.cn/u/2277101753

- (IBAction)addBtnPressed:(id)sender
{
    // 1. 创建一个新的Student的托管对象,需要在托管对象上下文中去创建 (-> 在Student表中创建记录 INSERT INTO)
    Student *stu = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    // 2. 设置值
    stu.stuId = @([self.stuIdTextField.text intValue]);
    stu.stuName = self.nameTextField.text;
    stu.stuAge = @([self.ageTextField.text intValue]);
    stu.stuClass = self.classTextField.text;
    
    // 3. 添加到数组
    [self.students addObject:stu];
    
    // 4. 更新表格
    [self.tableview reloadData];
    
}
- (IBAction)delBtnPressed:(id)sender
{
    // 找到要删除的实体对象，移除它
    for (Student *stu in self.students)
    {
        if([stu.stuId intValue] == [self.stuIdTextField.text intValue])
        {
            // 从托管对象上下文中删除该对象 （-> 数据库中删除对应行的记录 DELETE FROM)
            [self.appDelegate.managedObjectContext deleteObject:stu];
            // 从students删除
            [self.students removeObject:stu];
            // 表格刷新
            [self.tableview reloadData];
            break;
        }
    }
}
- (IBAction)modifyBtnPressed:(id)sender
{
    
    // 找到要修改的实体对象，修改他的内容
    for (Student *stu in self.students)
    {
        if([stu.stuId intValue] == [self.stuIdTextField.text intValue])
        {
            // 修改内容 (-> 修改了实体对象的内容，相当于数据库中update了改行的内容 UPDATE)
            stu.stuName = self.nameTextField.text;
            stu.stuAge = @([self.ageTextField.text intValue]);
            stu.stuClass = self.classTextField.text;
            // 表格刷新
            [self.tableview reloadData];
            break;
        }
    }
}

#pragma mark - 为表格地宫数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.students.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    Student *stu = self.students[indexPath.row];
    cell.textLabel.text = stu.stuName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"学号:%@ 年龄:%@  班级%@",stu.stuId,stu.stuAge,stu.stuClass];
    
    
    return cell;
}

@end
