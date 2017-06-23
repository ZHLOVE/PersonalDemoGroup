//
//  ViewController.m
//  单例模式
//
//  Created by niit on 16/3/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "Student.h"

#import "Teacher.h"

@interface ViewController ()

@end

@implementation ViewController

// 练习:
// 写一个Person的单例,block方式防止运行多次

- (void)viewDidLoad {
    [super viewDidLoad];

//    Student *stu1 = [Student shareStudent];
//    stu1.name = @"张三";
//    NSLog(@"%@:%@",stu1,stu1.name);
//    
//    Student *stu2 = [Student shareStudent];
//    NSLog(@"%@:%@",stu2,stu2.name);
    
    Student *stu3 = [[Student alloc] init];
    stu3.name = @"李四";    
    NSLog(@"%@:%@",stu3,stu3.name);

    
    Student *stu4 = [[Student alloc] init];
    NSLog(@"%@:%@",stu4,stu4.name);
    
    Student *stu5 = [[Student alloc] init];
    NSLog(@"%@:%@",stu5,stu5.name);
    
    
    Teacher *teacher1 = [Teacher shareTeacher];
    Teacher *teacher2 = [[Teacher alloc] init];
    NSLog(@"%@,%@",teacher1,teacher2);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
