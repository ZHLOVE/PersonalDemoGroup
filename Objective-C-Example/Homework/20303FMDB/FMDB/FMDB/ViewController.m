//
//  ViewController.m
//  FMDB
//
//  Created by student on 16/4/14.
//  Copyright © 2016年 Five. All rights reserved.
//

#import "ViewController.h"

#import <FMDB.h>
@interface ViewController ()

@property (nonatomic,strong) FMDatabase *fmdb;
@property (weak, nonatomic) IBOutlet UITextField *textField;

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


- (IBAction)btn1Pressed:(id)sender {
    //可连接创建数据库
     NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"school.sqlite"];
    self.fmdb = [FMDatabase databaseWithPath:dbPath];
    //连接数据库
    if ([self.fmdb open]) {
        NSLog(@"打开数据库成功");
        //创建表格
        NSString *sql = @"CREATE TABLE IF NOT EXISTS T_Students ("
        "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "
        "name TEXT,"
        "age INTEGER,"
        "class TEXT,"
        "stuId INTEGER"
        ")";
        if ([self.fmdb executeUpdate:sql]) {
            NSLog(@"建表成功");
        }else{
            NSLog(@"建表失败");
        }
        //插入100个学生数据
        for (int i=0; i<100; i++) {
            NSString *name = [NSString stringWithFormat:@"学生%i",i];
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO T_Students (stuId,name,age) VALUES (%i,'%@',%i);",i+1,name,arc4random_uniform(10)+10];
            if([self.fmdb executeUpdate:sql])
            {
                NSLog(@"插入成功!");
            }
            else
            {
                NSLog(@"插入失败");
            }

        }
    }
}

- (IBAction)btn2Pressed:(id)sender {
    //查询数据
    NSString *sql = @"SELECT * FROM T_Students WHERE age > 15 AND age < 19";
    FMResultSet *result = [self.fmdb executeQuery:sql];
    while ([result next]) {
        NSString *name = [result stringForColumn:@"name"];
        int age = [result intForColumn:@"age"];
        
        NSLog(@"名字:%@ 年龄:%i",name,age);
    }
    
    
}























@end
