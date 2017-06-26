//
//  ViewController.m
//  sqlLite
//
//  Created by student on 16/4/13.
//  Copyright © 2016年 Five. All rights reserved.
//

#import "ViewController.h"

#import "SQLiteManager.h"
#import "Student.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *stuIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;

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
//打开数据库
- (IBAction)btnPressed:(id)sender {
//    SQLiteManager *sqlManager = [[SQLiteManager alloc]init];
    SQLiteManager *sqlManager = [SQLiteManager shareSQLiteManager];
    [sqlManager openDB:@"school"];
}

- (IBAction)addData:(id)sender {
//    SQLiteManager *sqlManager = [SQLiteManager shareSQLiteManager];
//    [sqlManager addStudentByStuId:[self.stuIdTextField.text intValue] name:self.nameTextField.text age:[self.ageTextField.text intValue] class:self.classTextField.text];
    Student *stu = [[Student alloc] init];
    stu.stuId = [self.stuIdTextField.text intValue];
    stu.stuName = self.nameTextField.text;
    stu.stuAge = [self.ageTextField.text intValue];
    stu.stuClass = self.classTextField.text;
    [stu insertStudent];

}

- (IBAction)deleteData:(id)sender {
//    SQLiteManager *sqlManager = [SQLiteManager shareSQLiteManager];
//     [sqlManager deleteStudent:[self.stuIdTextField.text intValue]];
    Student *stu = [[Student alloc] init];
    stu.stuId = [self.stuIdTextField.text intValue];
    [stu deleteStudent];
}

- (IBAction)updateData:(id)sender {
//    SQLiteManager *sqlManager = [SQLiteManager shareSQLiteManager];
//    [sqlManager updateStudentByStuId:[self.stuIdTextField.text intValue] name:self.nameTextField.text age:[self.ageTextField.text intValue] class:self.classTextField.text];
    Student *stu = [[Student alloc] init];
    stu.stuId = [self.stuIdTextField.text intValue];
    stu.stuName = self.nameTextField.text;
    stu.stuAge = [self.ageTextField.text intValue];
    stu.stuClass = self.classTextField.text;
    [stu updateStudent];

}
- (IBAction)findAll:(id)sender {
//    SQLiteManager *sqlManager = [SQLiteManager shareSQLiteManager];
//    [sqlManager findAllStudents];
    NSArray *students = [Student queryStudents];
    
    for (Student *stu in students)
    {
        NSLog(@"%@",stu);
    }

}

@end
