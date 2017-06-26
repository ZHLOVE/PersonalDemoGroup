//
//  TeacherVC.m
//  CoreData
//
//  Created by 马千里 on 16/4/14.
//  Copyright © 2016年 Five. All rights reserved.
//

#import "TeacherVC.h"

#import "AppDelegate.h"
#import "Teacher.h"
@interface TeacherVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *teacherIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *teachNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *teacherDepartmentTextField;
@property (weak, nonatomic) IBOutlet UITableView *teacherTableView;

@property(nonatomic,strong) NSMutableArray *teachers;
@property(nonatomic,weak) AppDelegate *appDelegate;
@end

@implementation TeacherVC

- (NSMutableArray *)teachers{
    if (_teachers == nil) {
        //1创建一个查询请求
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        //2 设定要查询哪种实体对象
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:self.appDelegate.managedObjectContext];
        [request setEntity:entity];
        //3查询
        NSArray *results = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
        
        _teachers = [results mutableCopy];
    }
    return _teachers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = [UIApplication sharedApplication].delegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addBtnPressed:(id)sender{
    Teacher *teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.appDelegate.managedObjectContext];
    teacher.teacherID = @([self.teacherIdTextField.text intValue]);
    teacher.name = self.teachNameTextField.text;
    teacher.department = self.teacherDepartmentTextField.text;
    [self.teachers addObject:teacher];
    [self.teacherTableView reloadData];
}

- (IBAction)updateBtnPressed:(id)sender{
    
}

- (IBAction)deleteBtnPressed:(id)sender{
    
}

- (IBAction)backBtnPressed:(id)sender {
   
}

//- (IBAction)addBtnPressed:(id)sender {
//    // 1创建一个新的Student的托管对象,在托管对象上下文中创建
//    Student *stu = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.appDelegate.managedObjectContext];
//    //2设置
//    stu.stuId = @([self.stuIdTextField.text intValue]);
//    stu.stuName = self.nameTextField.text;
//    stu.stuAge = @([self.ageTextField.text intValue]);
//    stu.stuClass = self.classTextField.text;
//    //3 添加到数组
//    [self.students addObject:stu];
//    // 存数据库
//    //    [self.appDelegate.managedObjectContext insertObject:stu];
//    //    [self.appDelegate saveContext];
//    
//    //4 更新表格
//    [self.tableview reloadData];
//    
//    
//}
//- (IBAction)delBtnPressed:(id)sender {
//    //找到要删除的实体对象，移除它
//    for (Student *stu in self.students) {
//        if ([stu.stuId intValue] == [self.stuIdTextField.text intValue]) {
//            //从托管对象上下文中删除
//            [self.appDelegate.managedObjectContext deleteObject:stu];
//            //从students删除
//            [self.students removeObject:stu];
//            //刷新表格
//            [self.tableview reloadData];
//            break;
//        }
//    }
//}
//- (IBAction)updateBtnPressed:(id)sender {
//    // 找到要修改的实体对象，修改他的内容
//    for (Student *stu in self.students)
//    {
//        if([stu.stuId intValue] == [self.stuIdTextField.text intValue])
//        {
//            // 修改内容
//            stu.stuName = self.nameTextField.text;
//            stu.stuAge = @([self.ageTextField.text intValue]);
//            stu.stuClass = self.classTextField.text;
//            // 表格刷新
//            [self.tableview reloadData];
//            break;
//        }
//    }
//    
//}


#pragma mark -UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teachers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teacherCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"teacherCell"];
    }
    
    Teacher *teacher = self.teachers[indexPath.row];
    cell.textLabel.text = teacher.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"工号:%@ 部门%@",teacher.teacherID,teacher.department];
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
