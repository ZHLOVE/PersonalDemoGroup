//
//  ViewController.m
//  SQLiteDemo
//
//  Created by niit on 16/4/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "SQLiteManager.h"

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
- (IBAction)btnPressed:(id)sender {
    
    SQLiteManager *manager = [SQLiteManager shareSQLiteManager];
    
    [manager openDB:@"school.sqlite"];
}
- (IBAction)addBtnPressed:(id)sender
{
    SQLiteManager *manager = [SQLiteManager shareSQLiteManager];
    [manager addStudentByStuId:[self.stuIdTextField.text intValue] name:self.nameTextField.text age:[self.ageTextField.text intValue] class:self.classTextField.text];
}
- (IBAction)deleteBtnPressed:(id)sender {
    SQLiteManager *manager = [SQLiteManager shareSQLiteManager];
    [manager deleteStudent:[self.stuIdTextField.text intValue]];
}
- (IBAction)updateBtnPressed:(id)sender
{
    SQLiteManager *manager = [SQLiteManager shareSQLiteManager];
    [manager updateStudentByStuId:[self.stuIdTextField.text intValue] name:self.nameTextField.text age:[self.ageTextField.text intValue] class:self.classTextField.text];
}
- (IBAction)findBtnPressed:(id)sender {
        SQLiteManager *manager = [SQLiteManager shareSQLiteManager];
    [manager findAllStudents];
}

@end
