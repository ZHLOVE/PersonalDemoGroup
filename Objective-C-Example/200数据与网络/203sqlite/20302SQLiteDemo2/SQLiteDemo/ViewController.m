//
//  ViewController.m
//  SQLiteDemo
//
//  Created by niit on 16/4/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "SQLiteManager.h"
#import "Student.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *stuIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSArray *students;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPressed:(id)sender {
    
    SQLiteManager *manager = [SQLiteManager shareSQLiteManager];
    [manager openDB:@"school.sqlite"];
}

- (IBAction)addBtnPressed:(id)sender
{
    Student *stu = [[Student alloc] init];
    stu.stuId = [self.stuIdTextField.text intValue];
    stu.stuName = self.nameTextField.text;
    stu.stuAge = [self.ageTextField.text intValue];
    stu.stuClass = self.classTextField.text;
    [stu insertStudent];
    
    
    
}

- (IBAction)deleteBtnPressed:(id)sender {
    Student *stu = [[Student alloc] init];
    stu.stuId = [self.stuIdTextField.text intValue];
    [stu deleteStudent];
}

- (IBAction)updateBtnPressed:(id)sender
{
    Student *stu = [[Student alloc] init];
    stu.stuId = [self.stuIdTextField.text intValue];
    stu.stuName = self.nameTextField.text;
    stu.stuAge = [self.ageTextField.text intValue];
    stu.stuClass = self.classTextField.text;
    [stu updateStudent];

}

- (IBAction)findBtnPressed:(id)sender
{
    self.students = [Student queryStudents];
    
    for (Student *stu in self.students)
    {
        NSLog(@"%@",stu);
    }
    
    [self.tableview reloadData];
    
}

#pragma mark -
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"学号:%i 年龄:%i  班级%@",stu.stuId,stu.stuAge,stu.stuClass];
    
    
    return cell;
}

@end
